///|
fn align(str : String, width~ : Int, align~ : Align, fill~ : Char) -> String {
  let len = str.length()
  match align {
    Left =>
      str +
      fill.to_string().repeat(if width - len < 0 { 0 } else { width - len })
    Right =>
      fill.to_string().repeat(if width - len < 0 { 0 } else { width - len }) +
      str
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
fn int64_to_string(n : Int64, type_flag : Char) -> String {
  match type_flag {
    'd' => n.to_string()
    'b' | 'B' => {
      let mut n = n
      let mut binary_string = ""
      if n < 0 {
        // TODO: Handle overflow
        n = n + (1 << 64).to_int64()
      }
      if n == 0 {
        return "0".to_string()
      }
      for i in -64..=0 {
        let i = -i
        let bit = (n >> i) & 1
        binary_string += bit.to_string()
      }
      binary_string.trim_start("0")
    }
    'o' | 'O' => {
      let mut n = n
      let mut octal_string = ""
      if n == 0 {
        return "0".to_string()
      }
      while n != 0 {
        let remainder = (n % 8).abs()
        octal_string += remainder.to_string()
        n /= 8
      }
      String::from_array(octal_string.to_array().rev())
    }
    'x' | 'X' => {
      let mut n = n
      let mut hex_string = ""
      if n == 0 {
        return "0".to_string()
      }
      let hex_digits = match type_flag {
        'x' => "0123456789abcdef"
        'X' => "0123456789ABCDEF"
        _ => abort("unreachable")
      }
      while n != 0 {
        let remainder = (n % 16).abs()
        hex_string += hex_digits[remainder.to_int()].to_string()
        n /= 16
      }
      String::from_array(hex_string.to_array().rev())
    }
    'e' | 'E' => {
      let mut n = n.to_double()
      if n == 0 {
        return "0\{type_flag}0".to_string()
      }
      let negative = n < 0
      if negative {
        n = -n
      }
      let mut exponent = 0
      let mut temp = n
      while temp >= 10 {
        temp /= 10
        exponent += 1
      }
      let mantissa = n / 10.0.pow(exponent.to_double())
      let sign = if negative { "-" } else { "" }
      "\{sign}\{mantissa}e\{exponent}"
    }
    _ => abort("unreachable")
  }
}

test {
  inspect!(int64_to_string(12, 'b'), content="1100")
  inspect!(int64_to_string(-12, 'o'), content="14")
  inspect!(int64_to_string(32767, 'x'), content="7fff")
  inspect!(int64_to_string(32767, 'O'), content="77777")
}

///|
pub impl Formattable for Int64 with format(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.type_flag {
        Some('b' | 'B' | 'o' | 'O' | 'x' | 'X' | 'e' | 'E' as flag) =>
          result = int64_to_string(self, flag)
        Some(flag) =>
          raise InvalidFormatField("Invalid type flag '\{flag}' for Int64")
        None => ()
      }
      match field.sign {
        Some('+') => if self >= 0 { result = "+" + result }
        Some('-') =>
          if self < 0 && not(result.starts_with("-")) {
            // Add a negative sign if the result doesn't already have one
            result = "-" + result
          }
        Some(_) => abort("unreachable")
        None => ()
      }
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

///| @coverage.skip
pub impl Formattable for Int with format(self, field) {
  self.to_int64().format!(field)
}

///| @coverage.skip
pub impl Formattable for UInt with format(self, field) {
  self.to_int64().format!(field)
}

///|
pub impl Formattable for UInt64 with format(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.type_flag {
        _ => () // TODO: How to reuse the code for Int64 and reduce code duplication?
      }
      match field.sign {
        Some('+') => result = "+" + result
        _ => ()
      }
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
fn count_digit(n : Double) -> Int {
  let str = n.to_string()
  match str.split(".").collect() {
    [_, digits] => digits.length()
    [_] => 0
    _ => abort("unreachable")
  }
}

///|
fn double_to_string(n : Double, type_flag : Char) -> String {
  match type_flag {
    'e' | 'E' => {
      let mut n = n
      if n == 0.0 {
        return "0\{type_flag}0".to_string()
      }
      let negative = n < 0.0
      if negative {
        n = -n
      }
      let mut exponent = 0
      while n >= 10.0 {
        n /= 10.0
        exponent += 1
      }
      while n < 1.0 {
        n *= 10.0
        exponent -= 1
      }
      let mantissa = "\{n}"
      let mantissa = mantissa.trim_end("0").trim_end(".")
      let sign = if negative { "-" } else { "" }
      "\{sign}\{mantissa}e\{exponent}"
    }
    _ => abort("unreachable")
  }
}

///|
pub impl Formattable for Double with format!(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.type_flag {
        Some('e' | 'E' as flag) => result = double_to_string(self, flag)
        Some(flag) =>
          raise InvalidFormatField("Invalid type flag '\{flag}' for Double")
        None => ()
      }
      match field.sign {
        Some('+') => if self >= 0 { result = "+" + result }
        Some('-') =>
          if self < 0 && not(result.starts_with("-")) {
            result = "-" + result
          }
        Some(_) => abort("unreachable")
        None => ()
      }
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

///| @coverage.skip
pub impl Formattable for Float with format(self, field) {
  self.to_double().format!(field)
}

///|
pub impl Formattable for BigInt with format(self, field) {
  let mut result = self.to_string()
  match field {
    Some(field) => {
      match field.type_flag {
        Some('x' | 'X' as flag) =>
          result = self.to_hex(uppercase=if flag == 'X' { true } else { false })
        Some(flag) =>
          raise InvalidFormatField(
            "the type flag '\{flag}' is not supported for BigInt",
          )
        None => ()
      }
      match field.sign {
        Some('+') => if self >= 0 { result = "+" + result }
        Some('-') =>
          if self < 0 && not(result.starts_with("-")) {
            result = "-" + result
          }
        Some(_) => abort("unreachable")
        None => ()
      }
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
