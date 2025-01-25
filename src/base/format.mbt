///|
/// Formats a string with the given arguments.
///
/// Parameters:
///
/// * `format_string` : A string containing format specifiers.
/// * `args` : An array of formattable values to be inserted into the format
/// string
///
/// Returns the formatted string.
///
/// Throws an error of type `FormatError` in the following cases:
///
/// * `ArgumentNotFound` : When a format specifier references a non-existent
/// argument
/// * `UnmatchedCurlyBrace` : When there are mismatched curly braces in the
/// format string
/// * `InvalidFormatField` : When a format specifier has invalid syntax
///
/// Example:
///
/// ```moonbit
/// test "try_format" {
///   let args : Array[&Formattable] = [(42 : Int), ("world" : String)]
///   inspect!(try_format!("Hello {1}, {:03d}!", args), content="Hello world, 042!")
/// }
/// ```
pub fn try_format!(
  format_string : String,
  args : Array[&Formattable]
) -> String!FormatError {
  let formatter = Formatter::new()
  formatter.init!(format_string)
  formatter.format!(args)
}

///|
/// @alert unsafe "Panic if receiving an error"
pub fn format(format_string : String, args : Array[&Formattable]) -> String {
  match try_format?(format_string, args) {
    Ok(result) => result
    Err(err) => abort(err.to_string())
  }
}

///|
fn println_mono(s : String) -> Unit = "%println"

///|
pub fn print(format_string : String, args : Array[&Formattable]) -> Unit {
  println_mono(format(format_string, args))
}
