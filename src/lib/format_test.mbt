test "format" {
  inspect!(@lib.format("Hello {}!", ["World"]), content="Hello World!")
  inspect!(@lib.format("Hello {0:>5}!", ["Test"]), content="Hello  Test!")
  inspect!(
    @lib.format("Begin{:-^10}End", ["Test"]),
    content="Begin---Test---End",
  )
  inspect!(@lib.format("{:.0}", [12.12]), content="12")
  inspect!(@lib.format("{:.3}", [11.4514]), content="11.451")
  inspect!(@lib.format("{:.6}", [11.4514]), content="11.451400")
  inspect!(@lib.format("{:+}", [12]), content="+12")
  inspect!(@lib.format("{0:-} {1:-}", [12, -12]), content="12 -12")
}

test "example 1" {
  inspect!(
    @lib.format("Left aligned: '{:10}', Right aligned: '{:>10}'", [
      "left", "right",
    ]),
    content="Left aligned: 'left      ', Right aligned: '     right'",
  )
}
