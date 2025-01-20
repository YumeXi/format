///|
pub struct Style {
  bg : BgColor?
  fg : FgColor?
  emphasis : Array[Emphasis]
} derive(Show)

///|
pub(open) trait Styled {
  style(Self) -> Style
}

///|
pub type StyledArg[T] (Style, T) derive(Show)

///|
pub impl Styled for Style with style(self) { self }

///|
impl Styled with style(_) { { bg: None, fg: None, emphasis: [] } }

///|
pub impl[T] Styled for StyledArg[T] with style(self) { self.0 }

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
} derive(Show, Eq)

///|
pub(all) enum Color {
  Color16(Color16)
  Color256(Int)
  TrueColor(Int, Int, Int)
} derive(Show, Eq)

///|
pub type FgColor Color derive(Show)

///|
pub type BgColor Color derive(Show)

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
} derive(Show, Eq)

///|
pub fn fg[T : ToColor](color : T) -> Style {
  { bg: None, fg: Some(color.to_color()), emphasis: [] }
}

///|
pub fn bg[T : ToColor](color : T) -> Style {
  { bg: Some(color.to_color()), fg: None, emphasis: [] }
}

///|
pub fn emph(emphasis : Emphasis) -> Style {
  { bg: None, fg: None, emphasis: [emphasis] }
}

///|
trait ToColor {
  to_color(Self) -> Color
}
