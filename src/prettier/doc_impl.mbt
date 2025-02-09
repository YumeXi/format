///|
pub impl Pretty for Doc with prettify(self) { self }

///|
pub impl Pretty for String with prettify(self) { text(self) }

///|
pub impl Pretty for Int with prettify(self) { content(self) }

///|
pub impl Pretty for Bool with prettify(self) { content(self) }

///|
pub impl Pretty for Float with prettify(self) { content(self) }

///|
pub impl Pretty for Double with prettify(self) { content(self) }

///|
pub impl Pretty for Char with prettify(self) { content(self) }

///|
pub impl Pretty for Unit with prettify(_) { text("()") }

///|
pub impl Pretty for Int64 with prettify(self) { content(self) }

///|
pub impl Pretty for UInt64 with prettify(self) { content(self) }

///|
pub impl Pretty for UInt with prettify(self) { content(self) }

///|
pub impl[T : Pretty] Pretty for T? with prettify(self) {
  match self {
    Some(x) => surround("Some(", x.prettify(), ")")
    None => text("None")
  }
}

///|
pub impl[T : Pretty] Pretty for Array[T] with prettify(self) {
  surround("[", intersperse(text(","), self.map(fn { x => x.prettify() })), "]")
}

///|
pub impl[T : Pretty] Pretty for FixedArray[T] with prettify(self) {
  surround(
    "[",
    intersperse(text(","), self.iter().map(fn { x => x.prettify() }).collect()),
    "]",
  )
}

///|
pub impl[T : Pretty, E : Pretty + Error] Pretty for Result[T, E] with prettify(
  self
) {
  match self {
    Ok(x) => surround("Ok(", x, ")")
    Err(e) => surround("Err(", e.prettify(), ")")
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Map[A, B] with prettify(self) {
  let entries = self
    .iter()
    .map(fn {
      (k, v) => group(k.prettify() + text(":") + space() + v.prettify())
    })
  surround(
    "{",
    nest(space() + intersperse(text(",") + space(), entries.collect())) +
    space(),
    "}",
  )
}

///|
pub impl Pretty for Json with prettify(self) {
  match self {
    Null => text("null")
    True => text("true")
    False => text("false")
    Number(n) => n.prettify()
    String(s) => surround("\"", s.prettify(), "\"")
    Array(arr) => arr.prettify()
    Object(obj) => {
      let entries = obj
        .iter()
        .map(fn {
          (k, v) =>
            group(
              surround("\"", k.prettify(), "\"") +
              text(":") +
              space() +
              v.prettify(),
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

test {
  let json : Json = {
    "name": "John Doe",
    "age": 30,
    "isMarried": true,
    "hobbies": ["reading", "swimming"],
  }
  prettify("{:50}", [json])
  |> inspect!(
    content=
      #|{
      #|  "name": "John Doe",
      #|  "age": 30,
      #|  "isMarried": true,
      #|  "hobbies": ["reading","swimming"]
      #|}
    ,
  )
}
