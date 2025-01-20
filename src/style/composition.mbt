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
pub fn lor[T : @base.Formattable + Styled](
  self : StyledArg[Style],
  other : T
) -> StyledArg[T] {
  ((self.style() | other.style()).style(), other)
}

test {
  let _ = fg(Red) | bg(Blue) | 1.23
  let _ = fg(Red) | emph(Bold) | "test"

}
