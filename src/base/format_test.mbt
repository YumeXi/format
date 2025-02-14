///|
test "format" {
  inspect!(@base.format("Hello {}!", ["World"]), content="Hello World!")
  inspect!(@base.format("Hello {0:>5}!", ["Test"]), content="Hello  Test!")
  inspect!(
    @base.format("Begin{:-^10}End", ["Test"]),
    content="Begin---Test---End",
  )
  inspect!(@base.format("{:.0}", [12.12]), content="12")
  inspect!(@base.format("{:.3}", [11.4514]), content="11.451")
  inspect!(@base.format("{:.6}", [11.4514]), content="11.451400")
  inspect!(@base.format("{:+}", [12]), content="+12")
  inspect!(@base.format("{0:-} {1:-}", [12, -12]), content="12 -12")
}

///|
test "example 1" {
  inspect!(
    @base.format("Left aligned: '{:10}', Right aligned: '{:>10}'", [
      "left", "right",
    ]),
    content="Left aligned: 'left      ', Right aligned: '     right'",
  )
}
