///|
pub fn Style::lor[T : Styled](self : Style, other : T) -> StyledArg[T] {
  let other_style = other.style()
  let new_style = {
    bg: match self.bg {
      Some(color) => Some(color)
      None => other_style.bg
    },
    fg: match self.fg {
      Some(color) => Some(color)
      None => other_style.fg
    },
    emphasis: self.emphasis + other_style.emphasis,
  }
  (new_style, other)
}

///|
pub fn lor[T : Styled](self : StyledArg[Style], other : T) -> StyledArg[T] {
  ((self.style() | other.style()).style(), other)
}

///|
test {
  let _ = fg(Red) | bg(Blue) | 1.23
  let _ = fg(Red) | emph(Bold) | "test"

}

///|
pub impl ToColor for Color with to_color(self) {
  self
}

///|
pub impl ToColor for Color16 with to_color(self) {
  Color16(self)
}

///|
pub impl ToColor for Int with to_color(self) {
  Color256(self)
}

///|
pub impl ToColor for (Int, Int, Int) with to_color(self) {
  TrueColor(self.0, self.1, self.2)
}

///|
test {
  let _ = fg(Red) | bg((255, 255, 255)) | 1.23

}
