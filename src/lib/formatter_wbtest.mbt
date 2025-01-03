test "parse [[fill]align][width]" {
  let formatter = Formatter::new()
  assert_eq!(formatter.parse_field!(":->"), {
    arg_id: None,
    fill: '-',
    align: Right,
    width: 0,
  })
  assert_eq!(formatter.parse_field!(":->10"), {
    arg_id: None,
    fill: '-',
    align: Right,
    width: 10,
  })
}
