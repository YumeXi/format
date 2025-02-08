///|
pub fn format(input : String, args : Array[&Prettifiable]) -> String {
  @base.format(input, args.map(fn { arg => arg.prettify() }))
}
