///|
pub let hardline : Doc = Break("\n")

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
pub fn line() -> Doc {
  Break("\n")
}

///|
pub fn space() -> Doc {
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

///|
pub fn intersperse(sep : Doc, docs : Array[Doc]) -> Doc {
  match docs {
    [] => empty()
    [x, .. xs] => xs.fold(init=x, fn(l, r) { l + sep + r })
  }
}
