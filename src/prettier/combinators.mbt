///|
let hardline : Doc = Break("\n")

///|
pub fn empty() -> Doc {
  Text("")
}

///|
pub fn text(s : String) -> Doc {
  Text(s)
}

///|
pub fn nest(indent~ : Int = 2, doc : Doc) -> Doc {
  Nest(indent, doc)
}

///|
pub fn line_break() -> Doc {
  Break("\n")
}

///|
pub fn space_break() -> Doc {
  Break(" ")
}

///|
pub fn break_with(s : String) -> Doc {
  Break(s)
}

///|
pub fn group(doc : Doc) -> Doc {
  Group(doc)
}
