///|
pub(open) trait Formattable: Show {
  fn format(Self, FormatField?) -> String raise FormatError = _
}

///|
/// @coverage.skip
impl Formattable with fn format(self, _) {
  self.to_string()
}

///|
pub struct Formatter {
  strings : Array[String]
  format_specs : Array[String]
  builder : StringBuilder
} derive(Debug)

///|
pub suberror FormatError {
  ArgumentNotFound(arg_id~ : String)
  UnmatchedCurlyBrace(Char)
  InvalidFormatField(String)
} derive(Debug, Show)

///|
enum Align {
  Left
  Right
  Center
} derive(Debug, Eq)

///|
impl Show for Align with fn to_string(self) -> String {
  match self {
    Left => "Left"
    Right => "Right"
    Center => "Center"
  }
}

///|
/// @coverage.skip
impl Default for Align with fn default() {
  Left
}

///|
/// @coverage.skip
impl @strconv.FromStr for Align with fn from_string(str) {
  match str {
    "<" => Left
    ">" => Right
    "^" => Center
    _ => raise @strconv.StrConvError("invalid syntax")
  }
}

///|
struct FormatField {
  arg_id : Int?
  fill : Char
  align : Align?
  width : Int
  precision : Int?
  sign : Char?
  type_flag : Char?
} derive(Debug, Eq)

///|
impl Show for FormatField with fn to_string(self) -> String {
  let buf = StringBuilder::new()
  buf.write_string("FormatField { arg_id: ")
  buf.write_string(
    match self.arg_id {
      None => "None"
      Some(id) => id.to_string()
    },
  )
  buf.write_string(", fill: ")
  buf.write_string(self.fill.to_string())
  buf.write_string(", align: ")
  buf.write_string(
    match self.align {
      None => "None"
      Some(a) => a.to_string()
    },
  )
  buf.write_string(", width: ")
  buf.write_string(self.width.to_string())
  buf.write_string(", precision: ")
  buf.write_string(
    match self.precision {
      None => "None"
      Some(p) => p.to_string()
    },
  )
  buf.write_string(", sign: ")
  buf.write_string(
    match self.sign {
      None => "None"
      Some(s) => s.to_string()
    },
  )
  buf.write_string(", type_flag: ")
  buf.write_string(
    match self.type_flag {
      None => "None"
      Some(f) => f.to_string()
    },
  )
  buf.write_string(" }")
  buf.to_string()
}

///|
/// @coverage.skip
pub impl Default for FormatField with fn default() {
  {
    arg_id: None,
    fill: ' ',
    align: None,
    width: 0,
    precision: None,
    sign: None,
    type_flag: None,
  }
}
