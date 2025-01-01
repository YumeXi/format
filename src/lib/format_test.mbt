test "format" {
  inspect!(@lib.format!("Hello {}!", ["World"]), content="Hello World!")
}
