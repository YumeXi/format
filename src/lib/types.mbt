///|
pub(open) trait Formattable: Show {
  format(Self, FormatField?) -> String
  // TODO: Consider moving it to a separate trait?
  pretty_format(Self, FormatField?) -> String
}

///|
impl Formattable with format(self, _) { self.to_string() }

///|
impl Formattable with pretty_format(self, _field) { self.format(_field) }

///|
struct Formatter {
  strings : Array[String]
  format_specs : Array[String]
  builder : StringBuilder
} derive(Show)

///|
type! FormatError {
  ArgumentNotFound(arg_id~ : String)
  UnmatchedCurlyBrace(Char)
  InvalidFormatField(String)
}

///|
enum Align {
  Left
  Right
  Center
} derive(Show, Eq)

///|
impl Default for Align with default() { Left }

///|
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
} derive(Show, Eq)

///|
impl Default for FormatField with default() {
  { arg_id: None, fill: ' ', align: None, width: 0, precision: None }
}
