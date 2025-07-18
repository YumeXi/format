///|
test {
  inspect(
    @base.try_format("{}", [fg(@style.Red).compose(emph(Bold)).compose("Test")]),
    content="\x1b[31;1mTest\x1b[39m\x1b[22m",
  )
  inspect(
    @base.try_format("{}", [
      fg(@style.BrightBlue).compose(emph(Underline)).compose("Test"),
    ]),
    content="\x1b[94;4mTest\x1b[39m\x1b[24m",
  )
}

///|
test {
  inspect(
    @base.try_format("{}", [
      emph(Hidden)
      .compose(emph(Underline))
      .compose(emph(Bold))
      .compose("Multi-emphasis Test"),
    ]),
    content="\x1b[8;4;1mMulti-emphasis Test\x1b[28m\x1b[24m\x1b[22m",
  )
}
