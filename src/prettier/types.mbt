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

///|
impl @base.Formattable for &Prettifiable with format(self, field) {
  self.prettify().format!(field)
}
