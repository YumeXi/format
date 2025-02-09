///|
pub fn render_style(self : Style) -> (String, String) {
  let start = StringBuilder::new()
  start.write_string("\x1b[")
  let end = StringBuilder::new()
  match self.bg {
    Some(BgColor(Color16(color))) => {
      start.write_object(BgColor(Color16(color)).to_idx())
      end.write_string("\x1b[49m")
    }
    Some(BgColor(Color256(idx))) => {
      start.write_string("48;5;\{idx}m")
      end.write_string("\x1b[49m")
    }
    Some(BgColor(TrueColor(r, g, b))) => {
      start.write_string("48;2;\{r};\{g};\{b}m")
      end.write_string("\x1b[49m")
    }
    None => ()
  }
  match self.fg {
    Some(FgColor(Color16(color))) => {
      if not(self.bg.is_empty()) {
        start.write_char(';')
      }
      start.write_object(FgColor(Color16(color)).to_idx())
      end.write_string("\x1b[39m")
    }
    Some(FgColor(Color256(idx))) => {
      if not(self.bg.is_empty()) {
        start.write_char(';')
      }
      start.write_string("38;5;\{idx}m")
      end.write_string("\x1b[39m")
    }
    Some(FgColor(TrueColor(r, g, b))) => {
      if not(self.bg.is_empty()) {
        start.write_char(';')
      }
      start.write_string("38;2;\{r};\{g};\{b}m")
      end.write_string("\x1b[39m")
    }
    None => ()
  }
  match self.emphasis {
    [] => ()
    [_, ..] => {
      if not(self.bg.is_empty() && self.fg.is_empty()) {
        start.write_char(';')
      }
      let (begin_idx, end_idx) = self.emphasis[0].to_idx()
      start.write_object(begin_idx)
      end.write_string("\x1b[\{end_idx}m")
      for emphasis in self.emphasis[1:] {
        start.write_char(';')
        let (begin_idx, end_idx) = emphasis.to_idx()
        start.write_object(begin_idx)
        end.write_string("\x1b[\{end_idx}m")
      }
    }
  }
  start.write_char('m')
  (start.to_string(), end.to_string())
}

///|
impl[T : @base.Formattable] @base.Formattable for StyledArg[T] with format(
  self,
  field
) {
  let (start, end) = self.0.render_style()
  start + self.1.format!(field) + end
}
