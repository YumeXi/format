///|
pub(all) struct Style {
  bg : BgColor?
  fg : FgColor?
  emphasis : Array[Emphasis]
} derive(Debug, Default)

///|
pub(open) trait Styled {
  fn style(Self) -> Style
}

///|
pub struct StyledArg[T](Style, T) derive(Debug)

///|
pub impl Styled for Style with fn style(self) {
  self
}

///|
pub impl[T] Styled for StyledArg[T] with fn style(self) {
  self.0
}

///|
pub(all) enum Color16 {
  Black
  Red
  Green
  Yellow
  Blue
  Magenta
  Cyan
  White
  BrightBlack
  BrightRed
  BrightGreen
  BrightYellow
  BrightBlue
  BrightMagenta
  BrightCyan
  BrightWhite
} derive(Debug, Eq, Arbitrary)

///|
pub(all) enum Color {
  Color16(Color16)
  Color256(Int)
  TrueColor(Int, Int, Int)
} derive(Debug, Eq)

///|
pub struct FgColor(Color) derive(Debug)

///|
pub struct BgColor(Color) derive(Debug)

///|
pub(all) enum Emphasis {
  Bold
  Faint
  Italic
  Underline
  Blink
  Inverse
  Hidden
  Strikethrough
} derive(Debug, Eq)

///|
pub fn[T : ToColor] fg(color : T) -> Style {
  { bg: None, fg: Some(FgColor(color.to_color())), emphasis: [] }
}

///|
pub fn[T : ToColor] bg(color : T) -> Style {
  { bg: Some(BgColor(color.to_color())), fg: None, emphasis: [] }
}

///|
pub fn emph(emphasis : Emphasis) -> Style {
  { bg: None, fg: None, emphasis: [emphasis] }
}

///|
pub trait ToColor {
  fn to_color(Self) -> Color
}

///|
impl Styled for Double with fn style(self) {
  { bg: None, fg: None, emphasis: [] }
}
