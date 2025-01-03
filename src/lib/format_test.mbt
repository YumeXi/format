test "format" {
  inspect!(@lib.format!("Hello {}!", ["World"]), content="Hello World!")
  inspect!(@lib.format!("Hello {0:>5}!", ["Test"]), content="Hello Test !")
}
