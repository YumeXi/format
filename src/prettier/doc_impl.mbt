///|
pub impl Pretty for Doc with fn prettify(self) {
  self
}

///|
pub impl Pretty for String with fn prettify(self) {
  text(self)
}

///|
pub impl Pretty for @rope.Rope with fn prettify(self) {
  Text(self)
}

///|
pub impl Pretty for Int with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for Bool with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for Float with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for Double with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for Char with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for Unit with fn prettify(_) {
  text("()")
}

///|
pub impl Pretty for Int64 with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for UInt64 with fn prettify(self) {
  content(self)
}

///|
pub impl Pretty for UInt with fn prettify(self) {
  content(self)
}

///|
pub impl[T : Pretty] Pretty for T? with fn prettify(self) {
  match self {
    Some(x) => surround("Some(", x.prettify(), ")")
    None => text("None")
  }
}

///|
pub impl[T : Pretty] Pretty for Array[T] with fn prettify(self) {
  surround("[", intersperse(text(","), self.map(x => x.prettify())), "]")
}

///|
pub impl[T : Pretty] Pretty for FixedArray[T] with fn prettify(self) {
  surround(
    "[",
    intersperse(text(","), self.iter().map(x => x.prettify()).collect()),
    "]",
  )
}

///|
pub impl[T : Pretty, E : Pretty] Pretty for Result[T, E] with fn prettify(self) {
  match self {
    Ok(x) => surround("Ok(", x, ")")
    Err(e) => surround("Err(", e.prettify(), ")")
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Map[A, B] with fn prettify(self) {
  let entries = self
    .iter()
    .map(fn(ab) {
      let (k, v) = ab
      group(k.prettify() + text(":") + space() + v.prettify())
    })
  surround(
    "{",
    nest(space() + intersperse(text(",") + space(), entries.collect())) +
    space(),
    "}",
  )
}

///|
pub impl Pretty for Json with fn prettify(self) {
  match self {
    Null => text("null")
    True => text("true")
    False => text("false")
    Number(n) => Pretty::prettify(n)
    String(s) => surround("\"", Pretty::prettify(s), "\"")
    Array(arr) => Pretty::prettify(arr)
    Object(obj) => {
      let entries = obj
        .iter()
        .map(pair => {
          let (k, v) = pair
          group(
            surround("\"", Pretty::prettify(k), "\"") +
            text(":") +
            space() +
            Pretty::prettify(v),
          )
        })
      surround(
        "{",
        nest(space() + intersperse(text(",") + space(), entries.collect())) +
        space(),
        "}",
      )
    }
  }
}

///|
test {
  let json : Json = {
    "name": "John Doe",
    "age": 30,
    "isMarried": true,
    "hobbies": ["reading", "swimming"],
  }
  Pretty::prettify(json).print(width=60)
  |> inspect(
    content=(
      #|{
      #|  "name": "John Doe",
      #|  "age": 30,
      #|  "isMarried": true,
      #|  "hobbies": ["reading","swimming"]
      #|}
    ),
  )
}

///|
pub impl[T : Pretty] Pretty for @style.StyledArg[T] with fn prettify(self) {
  let (start, end) = self.0.render_style()
  surround(
    @rope.hidden_string(start),
    self.1.prettify(),
    @rope.hidden_string(end),
  )
}

///|
impl @style.Styled for Doc with fn style(_self) {
  { bg: None, fg: None, emphasis: [] }
}

///|
test {
  inspect(
    Pretty::prettify(
      @style.fg(@style.Red).compose(
        group(text("hello") + nest(break_with(", ") + text("world"))),
      ),
    ).print(width=12),
    content="\x1b[31mhello, world\x1b[39m",
  )
}
