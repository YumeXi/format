///|
pub let hardline : Doc = Break("\n")

///|
pub fn empty() -> Doc {
  Empty
}

///|
pub fn text(s : String) -> Doc {
  Text(@rope.from_string(s))
}

///|
pub fn content[T : Show](v : T) -> Doc {
  text(v.to_string())
}

///|
pub fn nest(indent~ : Int = 2, doc : Doc) -> Doc {
  Nest(indent, doc)
}

///|
pub fn concat(array : Array[&Pretty]) -> Doc {
  array[:-1].rev_fold(init=array.last().or(empty()).prettify(), fn(doc, elem) {
    elem.prettify() + doc
  })
}

test {
  let array : Array[&Pretty] = [text("hello"), break_with(", "), text("world")]
  assert_eq!(
    concat(array),
    Concat(text("hello"), Concat(Break(", "), text("world"))),
  )
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

///|
pub fn surround(open : &Pretty, doc : &Pretty, close : &Pretty) -> Doc {
  group(open.prettify() + doc.prettify() + close.prettify())
}
