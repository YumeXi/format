// pub impl BitOr for Style with lor(self : Style, other : &Styled) -> StyledArg[&Styled] {
//   let other_style = other.style()
//   let new_style = {
//     bg: match self.bg {
//       Some(color) => Some(color)
//       None => other_style.bg
//     },
//     fg: match self.fg {
//       Some(color) => Some(color)
//       None => other_style.fg
//     },
//     emphasis: self.emphasis + other_style.emphasis,
//   }
//   (new_style, other)
// }

// pub impl BitOr for StyledArg[Style] with lor(self : StyledArg[Style], other : &Styled) -> StyledArg[&Styled] {
//   ((self.style() | other.style()).style(), other)
// }

///|
pub fn[T : Styled] StyledArg::compose(
  self : StyledArg[Style],
  other : T,
) -> StyledArg[T] {
  StyledArg(self.style().compose(other.style()).style(), other)
}

///|
pub fn[T] StyledArg::with_value(
  self : StyledArg[Style],
  value : T,
) -> StyledArg[T] {
  StyledArg(self.0, value)
}

///|
pub fn[T : Styled] Style::compose(self : Style, other : T) -> StyledArg[T] {
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
  StyledArg(new_style, other)
}

///|
test {
  let _ = fg(Red).compose(bg(Blue)).compose(1.23)
  let _ = fg(Red).compose(emph(Bold)).with_value("test")
}

///|
pub impl ToColor for Color with fn to_color(self) {
  self
}

///|
pub impl ToColor for Color16 with fn to_color(self) {
  Color16(self)
}

///|
pub impl ToColor for Int with fn to_color(self) {
  Color256(self)
}

///|
pub impl ToColor for (Int, Int, Int) with fn to_color(self) {
  TrueColor(self.0, self.1, self.2)
}

///|
test {
  let _ = fg(Red).compose(bg((255, 255, 255))).compose(1.23)
}
