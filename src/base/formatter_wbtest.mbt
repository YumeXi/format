///|
test "parse '{' '}'" {
  let formatter = Formatter::new()
  assert_true!(formatter.init?("{}").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("{ }").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("{").is_err())
  formatter.reset()
  assert_true!(formatter.init?("}").is_err())
  formatter.reset()
  assert_true!(formatter.init?("{:0}").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("Hello {}!").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("{0:-} {0:-}").is_ok())
  formatter.reset()
}

///|
test "parse [[fill]align][width]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":->"), {
    ..FormatField::default(),
    fill: '-',
    align: Some(Right),
  })
  assert_eq!(formatter.parse_field!(":->10"), {
    ..FormatField::default(),
    fill: '-',
    align: Some(Right),
    width: 10,
  })
}

///|
test "parse [sign]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":+"), {
    ..FormatField::default(),
    sign: Some('+'),
  })
  assert_eq!(formatter.parse_field!(":-.0"), {
    ..FormatField::default(),
    sign: Some('-'),
    precision: Some(0),
  })
}

///|
test "parse [\".\" precision]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":.2"), {
    ..FormatField::default(),
    precision: Some(2),
  })
}
