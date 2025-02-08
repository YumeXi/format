///|
pub(all) enum Doc {
  Break(String)
  Text(String)
  Concat(Doc, Doc)
  Group(Doc)
  Nest(Int, Doc)
} derive(Show)

///|
pub enum Mode {
  Flat
  Break
} derive(Show)

///|
pub(open) trait Prettifiable: @base.Formattable {
  prettify(Self) -> Doc
}
