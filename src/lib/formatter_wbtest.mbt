test "parse '{' '}'" {
  let formatter = Formatter::new()
  assert_true!(formatter.init?("{}").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("{ }").is_ok())
  formatter.reset()
  assert_true!(formatter.init?("{").is_err())
  assert_true!(formatter.init?("}").is_err())
  formatter.reset()
  assert_true!(formatter.init?("{:0}").is_ok())
  formatter.reset()
}

test "parse [[fill]align][width]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":->"), {
    arg_id: None,
    fill: '-',
    align: Some(Right),
    width: 0,
    precision: None,
  })
  assert_eq!(formatter.parse_field!(":->10"), {
    arg_id: None,
    fill: '-',
    align: Some(Right),
    width: 10,
    precision: None,
  })
}

test "parse [\".\" precision]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":.2"), {
    ..FormatField::default(),
    precision: Some(2),
  })
}
