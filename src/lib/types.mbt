///|
pub(open) trait Formattable: Show {
  format(Self) -> String
  pretty_format(Self) -> String
}

///|
impl Formattable with format(self) { self.to_string() }

///|
impl Formattable with pretty_format(self) { self.format() }

///|
struct Formatter {
  strings : Array[String]
  format_specs : Array[String]
  builder : StringBuilder
}

///|
fn Formatter::new() -> Formatter {
  {
    builder: StringBuilder::new(),
    strings: [],
    format_specs: [],
  }
}

///|
fn write_string(self : Formatter, string : String) -> Unit {
  self.builder.write_string(string)
}

///|
type! FormatError {
  ArgumentNotFound(arg_id~ : String)
  UnmatchedCurlyBrace(Char)
  InvalidFormatSpec(String)
}
