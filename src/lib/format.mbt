///|
pub fn format!(
  format_string : String,
  args : Array[&Formattable]
) -> String!FormatError {
  let formatter = Formatter::new()
  formatter.init!(format_string)
  formatter.format!(args)
}
