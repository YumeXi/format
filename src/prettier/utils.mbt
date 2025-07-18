///|
pub fn try_prettify(
  input : String,
  args : Array[&Pretty]
) -> String raise @base.FormatError {
  @base.try_format(input, args.map(arg => arg.prettify()))
}

///|
pub fn prettify(input : String, args : Array[&Pretty]) -> String {
  @base.format(input, args.map(arg => arg.prettify()))
}
