///| @coverage.skip
pub fn Formatter::new() -> Formatter {
  { builder: StringBuilder::new(), strings: [], format_specs: [] }
}

///|
fn write_string(self : Formatter, string : String) -> Unit {
  self.builder.write_string(string)
}

///|
pub fn Formatter::init(
  self : Formatter,
  format_string : String
) -> Unit raise FormatError {
  // TODO: Rewrite in a more functional style
  let temp_builder = StringBuilder::new()
  let mut iterating_spec = false
  for c in format_string {
    match c {
      '{' => {
        iterating_spec = true
        self.strings.push(self.builder.to_string())
        self.builder.reset()
      }
      '}' =>
        if iterating_spec {
          self.format_specs.push(temp_builder.to_string())
          temp_builder.reset()
          iterating_spec = false
        } else {
          raise UnmatchedCurlyBrace(c)
        }
      _ =>
        if iterating_spec {
          temp_builder.write_char(c)
        } else {
          self.builder.write_char(c)
        }
    }
  }
  if iterating_spec {
    raise UnmatchedCurlyBrace('{')
  }
  if not(self.builder.is_empty()) {
    let string = self.builder.to_string()
    self.strings.push(string)
    self.builder.reset()
  }
}

///|
fn reset(self : Formatter) -> Unit {
  self.builder.reset()
  self.strings.clear()
  self.format_specs.clear()
}

///|
/// A format field follows the syntax
/// `{[arg_id][:[[fill]align][sign][width][.precision][type]]}`, where:
///  - `arg_id` : Index of the argument to format
///  - `fill` : Character to use for padding (default: ' ')
///  - `align` : Alignment specifier (`<` for left, `>` for right, `^`
/// for center)
///  - `sign` : Sign specifier (`+` to show plus for positive numbers,
/// and `-` to show minus for negative numbers)
///  - `width` : Minimum field width
///  - `precision` : Precision of decimal
///  - `type` : Type specifier (e.g., 'x' for hexadecimal, 'e' for
/// scientific notation)
fn parse_field(
  self : Formatter,
  field : String
) -> FormatField raise FormatError {
  self |> ignore
  if field.is_blank() {
    raise InvalidFormatField(field)
  }
  fn parse_spec(spec : String) -> FormatField raise FormatError {
    let mut iter = spec.iter()
    let mut field = FormatField::default()
    // Parse fill and alignment
    l0~: for c in iter {
      let ch = c
      l1~: loop ch {
        '>' | '<' | '^' as ch => {
          iter = iter.drop(1)
          guard (try? @strconv.parse(ch.to_string())) is Ok(align) else {
            raise InvalidFormatField(spec)
          }
          field = { ..field, align: Some(align) }
          break l0~
        }
        _ as ch =>
          match iter.take(2).drop(1).peek() {
            Some('>' | '<' | '^' as align) => {
              field = { ..field, fill: ch }
              iter = iter.drop(1)
              continue l1~ align
            }
            Some('{' | '}') => abort("unexpected curly brace")
            _ => break l1~
          }
      }
    }
    // Parse sign
    match iter.peek() {
      Some('+') => {
        iter = iter.drop(1)
        field = { ..field, sign: Some('+') }
      }
      Some('-') => {
        iter = iter.drop(1)
        field = { ..field, sign: Some('-') }
      }
      _ => ()
    }
    // Parse width
    match iter.peek() {
      Some('0'..='9') => {
        let mut len = 0
        guard (try? @strconv.parse(
            String::from_iter(
              [
                ..iter.take_while(fn(c) {
                  len += 1
                  match c {
                    '0'..='9' => true
                    _ => false
                  }
                }),
              ],
            ),
          ))
          is Ok(width) else {
          raise InvalidFormatField(spec)
        }
        field = { ..field, width, }
        iter = iter.drop(len)
      }
      _ => ()
    }
    // Parse precision
    match iter.peek() {
      Some('.') => {
        let mut len = 0
        guard (try? @strconv.parse(
            String::from_iter(
              [
                ..iter
                .drop(1)
                .take_while(fn(c) {
                  len += 1
                  match c {
                    '0'..='9' => true
                    _ => false
                  }
                }),
              ],
            ),
          ))
          is Ok(precision) else {
          raise InvalidFormatField(spec)
        }
        field = { ..field, precision: Some(precision) }
        iter = iter.drop(len)
      }
      _ => ()
    }
    iter = iter.drop(1)
    // Parse type flag
    match iter.peek() {
      Some(c) => {
        iter = iter.drop(1)
        field = { ..field, type_flag: Some(c) }
      }
      _ => ()
    }
    field
  }

  match field.find(":") {
    None =>
      if field.is_empty() {
        FormatField::default()
      } else {
        guard (try? @strconv.parse(field)) is Ok(arg_id) else {
          raise InvalidFormatField(field)
        }
        { ..FormatField::default(), arg_id: Some(arg_id) }
      }
    Some(i) => {
      let arg_id = match field.substring(end=i) {
        "" => None
        str => {
          guard (try? @strconv.parse(str)) is Ok(arg_id) else {
            raise InvalidFormatField(field)
          }
          Some(arg_id)
        }
      }
      let spec = field.substring(start=i + 1)
      { ..parse_spec(spec), arg_id, }
    }
  }
}

///|
pub fn Formatter::format(
  self : Formatter,
  args : Array[&Formattable]
) -> String raise FormatError {
  for i, fmt in self.format_specs {
    match self.strings.length() >= 1 {
      true => self.write_string(self.strings.remove(0))
      false => ()
    }
    if fmt.is_empty() {
      guard args.get(i) is Some(obj) else {
        raise ArgumentNotFound(arg_id=i.to_string())
      }
      self.write_string(obj.format(None))
    } else {
      let field = self.parse_field(fmt)
      guard args.get(field.arg_id.unwrap_or(i)) is Some(obj) else {
        raise ArgumentNotFound(arg_id=i.to_string())
      }
      self.write_string(obj.format(Some(field)))
    }
  }
  if not(self.strings.is_empty()) {
    self.builder.write_string(self.strings.remove(0))
  }
  self.collect()
}

///|
fn collect(self : Formatter) -> String {
  let string = self.builder.to_string()
  self.builder.reset()
  string
}
