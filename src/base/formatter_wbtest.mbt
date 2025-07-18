///|
test "parse '{' '}'" {
  let formatter = Formatter::new()
  fn init_ok(format_string : String) {
    let ok = (try? formatter.init(format_string)).is_ok()
    formatter.reset()
    ok
  }

  assert_true(init_ok("{}"))
  assert_true(init_ok("{ }"))
  assert_true(init_ok("{"))
  assert_true(init_ok("}"))
  assert_true(init_ok("{:0}"))
  assert_true(init_ok("Hello {}!"))
  assert_true(init_ok("{0:-} {0:-}"))
}

///|
test "parse [[fill]align][width]" {
  let formatter = Formatter::new()
  assert_eq(formatter.parse_field(":->"), {
    ..FormatField::default(),
    fill: '-',
    align: Some(Right),
  })
  assert_eq(formatter.parse_field(":->10"), {
    ..FormatField::default(),
    fill: '-',
    align: Some(Right),
    width: 10,
  })
}

///|
test "parse [sign]" {
  let formatter = Formatter::new()
  assert_eq(formatter.parse_field(":+"), {
    ..FormatField::default(),
    sign: Some('+'),
  })
  assert_eq(formatter.parse_field(":-.0"), {
    ..FormatField::default(),
    sign: Some('-'),
    precision: Some(0),
  })
}

///|
test "parse [\".\" precision]" {
  let formatter = Formatter::new()
  assert_eq(formatter.parse_field(":.2"), {
    ..FormatField::default(),
    precision: Some(2),
  })
}
