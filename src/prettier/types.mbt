///|
enum Doc {
  Text(String)
  Concat(Doc, Doc)
  Group(Doc)
  Nest(Int, Doc)
  Break
}

///|
trait Prettifiable: @base.Formattable {
  prettify(Self) -> Doc
}
