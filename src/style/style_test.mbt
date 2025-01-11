test {
  inspect!(
    @base.format!("{}", [fg(Red) | emph(Bold) | "Test"]),
    content="\x1b[31;1mTest\x1b[39m\x1b[22m",
  )
  inspect!(
    @base.format!("{}", [fg(BrightBlue) | emph(Underline) | "Test"]),
    content="\x1b[94;4mTest\x1b[39m\x1b[24m",
  )
}

test {
  inspect!(
    @base.format!("{}", [emph(Hidden) | emph(Underline) | emph(Bold) | "Multi-emphasis Test"]),
    content="\x1b[8;4;1mMulti-emphasis Test\x1b[28m\x1b[24m\x1b[22m"
  )
}
