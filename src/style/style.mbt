///|
pub fn lor[T : Styled](self : Style, other : T) -> StyledArg[T] {
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
    emphasis: match self.emphasis {
      Some(emphasis) => Some(emphasis)
      None => other_style.emphasis
    },
  }
  (new_style, other)
}

///|
pub fn lor[T : @base.Formattable](
  self : StyledArg[Style],
  other : T
) -> StyledArg[T] {
  (self.style(), other)
}

test {
  let _ = fg(Red) | bg(Blue) | 1.23
  let _ = fg(Red) | emph(Bold) | "test"

}

///|
impl[T : @base.Formattable] @base.Formattable for StyledArg[T] with format(
  self,
  field
) {
  let start = StringBuilder::new()
  start.write_string("\x1b[")
  let end = StringBuilder::new()
  match self.0.bg {
    Some(color) => {
      start.write_object(color.to_idx())
      end.write_string("\x1b[49m")
    }
    None => ()
  }
  match self.0.fg {
    Some(color) => {
      if not(self.0.bg.is_empty()) {
        start.write_char(';')
      }
      start.write_object(color.to_idx())
      end.write_string("\x1b[39m")
    }
    None => ()
  }
  match self.0.emphasis {
    Some(emphasis) => {
      let (begin_idx, end_idx) = emphasis.to_idx()
      if not(self.0.bg.is_empty() && self.0.fg.is_empty()) {
        start.write_char(';')
      }
      start.write_object(begin_idx)
      end.write_string("\x1b[\{end_idx}m")
    }
    None => ()
  }
  start.write_char('m')
  start.to_string() + self.1.format!(field) + end.to_string()
}
