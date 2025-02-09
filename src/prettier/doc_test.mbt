test {
  let doc = group(text("hello") + nest(break_with(" , ") + text("world")))
  inspect!(
    @base.format("{:11}", [doc]),
    content=
      #|hello
      #|  world
    ,
  )
  inspect!(
    @base.format("{:14}", [doc]),
    content=
      #|hello , world
    ,
  )
}

///| Reference: https://github.com/Yoorkin/prettyprinter/blob/main/example/tree.mbt
enum Tree[A] {
  Leaf(A)
  Node(Array[Tree[A]])
} derive(Show)

///|
pub impl[A : Pretty] Pretty for Tree[A] with prettify(tree : Tree[A]) {
  match tree {
    Leaf(x) => x.prettify()
    Node(xs) =>
      group(
        text("Node(") +
        nest(
          space() + intersperse(text(",") + space(), xs.map(Pretty::prettify)),
        ) +
        space() +
        text(")"),
      )
  }
}

test {
  let tree = Node([
    Leaf(100),
    Leaf(200),
    Leaf(300000000),
    Node([
      Leaf(400),
      Leaf(500),
      Node([Leaf(6000000), Leaf(7000000), Leaf(80000000), Leaf(80000001)]),
      Leaf(900),
    ]),
    Leaf(1000),
  ])
  inspect!(
    prettify("{:60}", [tree]),
    content=
      #|Node(
      #|  100,
      #|  200,
      #|  300000000,
      #|  Node(
      #|    400,
      #|    500,
      #|    Node( 6000000, 7000000, 80000000, 80000001 ),
      #|    900
      #|  ),
      #|  1000
      #|)
    ,
  )
}

/// Reference: https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
test "show tree" {
  enum Tree {
    Node(String, Array[Tree])
  }
  fn show_tree(self : Tree) -> Doc {
    let Node(s, ts) = self
    group(nest(indent=s.length(), text(s) + show_bracket(ts[:])))
  }

  fn show_bracket(ts : ArrayView[Tree]) -> Doc {
    match ts {
      [] => empty()
      ts => text("[") + nest(indent=1, show_trees(ts)) + text("]")
    }
  }

  fn show_trees(ts : ArrayView[Tree]) -> Doc {
    match ts {
      [t] => show_tree(t)
      [t, .. ts] => show_tree(t) + text(",") + space() + show_trees(ts)
      [] => abort("unreachable")
    }
  }

  let tree = Node("aaa", [
    Node("bbbb", [Node("cc", []), Node("dd", [])]),
    Node("eee", []),
    Node("fff", [Node("gg", []), Node("hh", []), Node("ii", [])]),
  ])
  let doc = show_tree(tree)
  inspect!(
    prettify("{:80}", [doc]),
    content="aaa[bbbb[cc, dd], eee, fff[gg, hh, ii]]",
  )
  inspect!(
    prettify("{:10}", [doc]),
    content=
      #|aaa[bbbb[cc,
      #|         dd],
      #|    eee,
      #|    fff[gg,
      #|        hh,
      #|        ii]]
    ,
  )
  inspect!(
    prettify("{:20}", [doc]),
    content=
      #|aaa[bbbb[cc, dd],
      #|    eee,
      #|    fff[gg, hh, ii]]
    ,
  )
}
