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
impl Formattable for String with format(self, field) {
  let mut result = self
  match field {
    Some(field) =>
      match field.align {
        Left =>
          result = field.fill
            .to_string()
            .repeat(
              if field.width - self.length() < 0 {
                0
              } else {
                field.width - self.length()
              },
            ) +
            result
        Right =>
          result = result +
            field.fill
            .to_string()
            .repeat(
              if field.width - self.length() < 0 {
                0
              } else {
                field.width - self.length()
              },
            )
        Center => {
          let left_padding = field.fill
            .to_string()
            .repeat(
              if field.width - self.length() < 0 {
                0
              } else {
                (field.width - self.length()) / 2
              },
            )
          let right_padding = field.fill
            .to_string()
            .repeat(
              if field.width - self.length() < 0 {
                0
              } else {
                field.width - self.length() - left_padding.length()
              },
            )
          result = left_padding + result + right_padding
        }
      }
    None => ()
  }
  result
}

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
  align : Align
  width : Int
} derive(Show, Eq)

///|
impl Default for FormatField with default() {
  { arg_id: None, fill: ' ', align: Left, width: 0 }
}
