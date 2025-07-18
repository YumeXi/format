///|
pub(open) trait Formattable: Show {
  format(Self, FormatField?) -> String raise FormatError = _
}

///| @coverage.skip
impl Formattable with format(self, _) {
  self.to_string()
}

///|
pub struct Formatter {
  strings : Array[String]
  format_specs : Array[String]
  builder : StringBuilder
} derive(Show)

///|
pub suberror FormatError {
  ArgumentNotFound(arg_id~ : String)
  UnmatchedCurlyBrace(Char)
  InvalidFormatField(String)
} derive(Show)

///|
enum Align {
  Left
  Right
  Center
} derive(Show, Eq)

///| @coverage.skip
impl Default for Align with default() {
  Left
}

///| @coverage.skip
impl @strconv.FromStr for Align with from_string(str) {
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
} derive(Show, Eq)

///| @coverage.skip
pub impl Default for FormatField with default() {
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
