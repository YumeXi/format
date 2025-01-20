///|
fn Emphasis::to_idx(self : Emphasis) -> (Int, Int) {
  match self {
    Bold => (1, 22)
    Faint => (2, 22)
    Italic => (3, 23)
    Underline => (4, 24)
    Blink => (5, 25)
    Inverse => (7, 27)
    Hidden => (8, 28)
    Strikethrough => (9, 29)
  }
}
