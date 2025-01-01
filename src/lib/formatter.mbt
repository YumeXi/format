///|
fn Formatter::init!(
  self : Formatter,
  format_string : String
) -> Unit!FormatError {
  let mut iter = format_string.iter()
  for c in iter {
    iter = iter.drop(1)
    match c {
      '{' => {
        self.strings.push(self.builder.to_string())
        self.format_specs.push(
          String::from_iter(iter.take_while(fn(c) { c != '}' })),
        )
        self.builder.reset()
      }
      '}' =>
        if self.builder.is_empty() {
          continue
        } else {
          raise UnmatchedCurlyBrace('}')
        }
      _ => self.builder.write_char(c)
    }
  }
  if not(self.builder.is_empty()) {
    let string = self.builder.to_string()
    self.strings.push(string)
    self.builder.reset()
  }
}

///|
fn parse_spec!(self : Formatter, fmt : String) -> Unit!FormatError {
  if fmt.is_blank() {
    raise InvalidFormatSpec(fmt)
  }
  self |> ignore
  abort("unfinished code")
}

///|
fn format!(self : Formatter, args : Array[&Formattable]) -> String!FormatError {
  for i, fmt in self.format_specs {
    self.write_string(self.strings.remove(0))
    if fmt.is_empty() {
      guard let Some(obj) = args.get(i) else {
        None => raise ArgumentNotFound(arg_id="")
      }
      self.write_string(obj.format())
    } else {
      self.parse_spec!(fmt)
      abort("unfinished code")
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
