///|
let split_length : Int = 2048

// let join_length : Int = split_length / 2

///|
pub struct Leaf {
  buf : String
  start : Int
  end : Int
} derive(Default, Show, Eq)

///|
pub struct Node {
  left : Rope?
  right : Rope?
} derive(Default, Show, Eq)

///|
pub(all) enum Rope {
  Leaf(Leaf, len~ : Int)
  Node(Node, len~ : Int)
} derive(Eq)

///|
pub impl Default for Rope with default() {
  Leaf(Leaf::default(), len=0)
}

///|
pub impl Show for Rope with output(self, logger) {
  match self {
    Leaf(leaf, ..) => Logger::write_string(logger, leaf.buf)
    Node(node, ..) => {
      logger.write_object(node.left.unwrap_or_default())
      logger.write_object(node.right.unwrap_or_default())
    }
  }
}

///|
pub fn op_add(self : Rope, other : Rope) -> Rope {
  match (self, other) {
    (Node(_, len=0), _) => other
    (_, Node(_, len=0)) => self
    (Leaf(leaf, len=0), _) =>
      if leaf.end - leaf.start == 0 {
        other
      } else {
        from_string(leaf.buf + other.to_string())
      }
    (_, Leaf(leaf, len=0)) =>
      if leaf.end - leaf.start == 0 {
        other
      } else {
        from_string(leaf.buf + other.to_string())
      }
    (
      Leaf(_, len=len1)
      | Node(_, len=len1),
      Leaf(_, len=len2)
      | Node(_, len=len2),
    ) =>
      if len1 + len2 <= split_length {
        from_string(self.to_string() + other.to_string())
      } else {
        Node({ left: Some(self), right: Some(other) }, len=len1 + len2)
      }
  }
}

///|
pub fn from_string(buf : String) -> Rope {
  Leaf({ buf, start: 0, end: buf.length() }, len=buf.length())
}

///|
pub fn length(self : Rope) -> Int {
  match self {
    Leaf(_, len~) => len
    Node(_, len~) => len
  }
}

///|
pub fn hidden_string(s : String) -> Rope {
  // Uses fake length to avoid counting the hidden characters when pretty printing
  Leaf({ buf: s, start: 0, end: s.length() }, len=0)
}
