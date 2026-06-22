///|
test {
  let (start, end) = fg(@style.Red).compose(emph(Bold)).style().render_style()
  inspect(start + "Test" + end, content="\x1b[31;1mTest\x1b[39m\x1b[22m")
  let (start2, end2) = fg(@style.BrightBlue)
    .compose(emph(Underline))
    .style()
    .render_style()
  inspect(start2 + "Test" + end2, content="\x1b[94;4mTest\x1b[39m\x1b[24m")
}

///|
test {
  let (start, end) = emph(Hidden)
    .compose(emph(Underline))
    .compose(emph(Bold))
    .style()
    .render_style()
  inspect(
    start + "Multi-emphasis Test" + end,
    content="\x1b[8;4;1mMulti-emphasis Test\x1b[28m\x1b[24m\x1b[22m",
  )
}
