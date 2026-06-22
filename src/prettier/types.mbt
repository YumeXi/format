///|
pub(all) enum Doc {
  Empty
  Break(String)
  Text(@rope.Rope)
  Concat(Doc, Doc)
  Group(Doc)
  Nest(Int, Doc)
} derive(Show, Eq, Default)

///|
pub enum Mode {
  Flat
  Break
} derive(Show, Eq)

///|
pub(open) trait Pretty {
  fn prettify(Self) -> Doc
}

///|
pub(open) trait PrettyFormattable: Pretty + @base.Formattable + Show {
  fn pretty_format(Self, @base.FormatField?) -> Doc raise @base.FormatError
}

///|
pub impl Show for &PrettyFormattable with fn output(self, logger) {
  logger.write_object(Pretty::prettify(self))
}

///|
pub impl Show for &PrettyFormattable with fn to_string(self) {
  Pretty::prettify(self).to_string()
}

///|
pub impl @base.Formattable for &PrettyFormattable with fn format(self, f) {
  self.pretty_format(f).format(f)
}

///|
/// @alert unsafe "Panic if error occurs"
pub impl Pretty for &PrettyFormattable with fn prettify(self) {
  (try? self.pretty_format(None)).unwrap()
}
