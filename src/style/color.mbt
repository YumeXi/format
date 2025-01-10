///|
fn to_idx(self : FgColor) -> Int {
  match self._ {
    Black => 30
    Red => 31
    Green => 32
    Yellow => 33
    Blue => 34
    Magenta => 35
    Cyan => 36
    White => 37
    BrightBlack => 90
    BrightRed => 91
    BrightGreen => 92
    BrightYellow => 93
    BrightBlue => 94
    BrightMagenta => 95
    BrightCyan => 96
    BrightWhite => 97
  }
}

///|
fn to_idx(self : BgColor) -> Int {
  match self._ {
    Black => 40
    Red => 41
    Green => 42
    Yellow => 43
    Blue => 44
    Magenta => 45
    Cyan => 46
    White => 47
    BrightBlack => 100
    BrightRed => 101
    BrightGreen => 102
    BrightYellow => 103
    BrightBlue => 104
    BrightMagenta => 105
    BrightCyan => 106
    BrightWhite => 107
  }
}
