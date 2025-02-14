///|
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
enum Tree {
  Leaf(Int)
  Node(Array[Tree])
} derive(Show)

///|
test "show tree 1" {
  ///|
  fn show_tree(tree : Tree) {
    match tree {
      Leaf(x) => content(x)
      Node(xs) =>
        surround(
          "Node(",
          nest(space() + intersperse(text(",") + space(), xs.map(show_tree))) +
          space(),
          ")",
        )
    }
  }
  ///| Only an example for colorful pretty printing
  fn _show_tree_with_color(tree : Tree) {
    match tree {
      Leaf(x) => content(x)
      Node(xs) =>
        enclose(
          "Node(",
          nest(
            space() +
            colorize(
              intersperse(text(",") + space(), xs.map(_show_tree_with_color)),
            ),
          ) +
          space(),
          ")",
        )
    }
  }

  let tree = Node([
    Leaf(100),
    Leaf(200),
    Leaf(300000000),
    Node([
      Leaf(400),
      Leaf(500),
      Node([Leaf(6000000), Leaf(7000000), Leaf(80000000), Leaf(80000000)]),
      Leaf(900),
    ]),
    Leaf(1000),
  ])
  inspect!(
    show_tree(tree).print(width=60),
    content=
      #|Node(
      #|  100,
      #|  200,
      #|  300000000,
      #|  Node(
      #|    400,
      #|    500,
      #|    Node( 6000000, 7000000, 80000000, 80000000 ),
      #|    900
      #|  ),
      #|  1000
      #|)
    ,
  )
}

///| Reference: https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
test "show tree 2" {
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
