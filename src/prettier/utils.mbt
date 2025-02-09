///|
pub fn try_prettify(
  input : String,
  args : Array[&Pretty]
) -> String!@base.FormatError {
  @base.try_format!(input, args.map(fn { arg => arg.prettify() }))
}

///|
pub fn prettify(input : String, args : Array[&Pretty]) -> String {
  @base.format(input, args.map(fn { arg => arg.prettify() }))
}
