///|
pub fn try_format!(
  format_string : String,
  args : Array[&Formattable]
) -> String!FormatError {
  let formatter = Formatter::new()
  formatter.init!(format_string)
  formatter.format!(args)
}

pub fn format(
  format_string : String,
  args : Array[&Formattable]
) -> String {
  match try_format?(format_string, args) {
    Ok(result) => result
    Err(err) => abort(err.to_string())
  }
}
