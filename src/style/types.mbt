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
pub(all) enum Color {
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
type FgColor Color derive(Show)

///|
type BgColor Color derive(Show)

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
pub fn fg(color : Color) -> Style {
  { bg: None, fg: Some(color), emphasis: [] }
}

///|
pub fn bg(color : Color) -> Style {
  { bg: Some(color), fg: None, emphasis: [] }
}

///|
pub fn emph(emphasis : Emphasis) -> Style {
  { bg: None, fg: None, emphasis: [emphasis] }
}
