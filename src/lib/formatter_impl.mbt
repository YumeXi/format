///|
fn align(str : String, width~ : Int, align~ : Align, fill~ : Char) -> String {
  let len = str.length()
  match align {
    Left =>
      fill.to_string().repeat(if width - len < 0 { 0 } else { width - len }) +
      str
    Right =>
      str +
      fill.to_string().repeat(if width - len < 0 { 0 } else { width - len })
    Center => {
      let left_padding = fill
        .to_string()
        .repeat(if width - len < 0 { 0 } else { (width - len) / 2 })
      let right_padding = fill
        .to_string()
        .repeat(
          if width - len < 0 {
            0
          } else {
            width - len - left_padding.length()
          },
        )
      left_padding + str + right_padding
    }
  }
}

///|
pub impl Formattable for String with format(self, field) {
  match field {
    Some(field) =>
      match field.align {
        Some(Left) | None =>
          align(self, width=field.width, align=Left, fill=field.fill)
        Some(a) => align(self, width=field.width, align=a, fill=field.fill)
      }
    None => self
  }
}

///|
pub impl Formattable for Int64 with format(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.precision {
        Some(0) => result = result.split(".").collect()[0]
        Some(precision) => result = result + "." + "0".repeat(precision)
        _ => ()
      }
      match field.align {
        Some(Right) | None =>
          result = align(
            result,
            width=field.width,
            align=Right,
            fill=field.fill,
          )
        Some(a) =>
          result = align(result, width=field.width, align=a, fill=field.fill)
      }
    }
    None => ()
  }
  result
}

///|
pub impl Formattable for Int with format(self, field) {
  self.to_int64().format(field)
}

///|
pub impl Formattable for UInt with format(self, field) {
  self.to_int64().format(field)
}

///|
pub impl Formattable for UInt64 with format(self, field) {
  self.reinterpret_as_int64().format(field)
}

///|
fn count_digit(n : Double) -> Int {
  let str = n.to_string()
  match str.split(".").collect() {
    [_, digits] => digits.length()
    [_] => 0
    _ => abort("unreachable")
  }
}

///|
pub impl Formattable for Double with format(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.precision {
        Some(0) => result = result.split(".").collect()[0]
        Some(precision) => {
          let count = count_digit(self)
          if count == 0 {
            result = result + "." + "0".repeat(precision)
          } else if precision > count {
            result = result + "0".repeat(precision - count)
          } else {
            result = result.rev().substring(start=count - precision).rev()
          }
        }
        _ => ()
      }
      match field.align {
        Some(Right) | None =>
          result = align(
            result,
            width=field.width,
            align=Right,
            fill=field.fill,
          )
        Some(a) =>
          result = align(result, width=field.width, align=a, fill=field.fill)
      }
    }
    None => ()
  }
  result
}

///|
pub impl Formattable for Float with format(self, field) {
  self.to_double().format(field)
}
