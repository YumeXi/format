# YumeXi/format

The library provides formatting facilities for MoonBit.

## Usage

### Formatting

The `base` module implements basic formatting functions and types.

We can use `try_format!` to format a string. If you don't want to get an error, you can use `format` instead.

For example:

```moonbit
test {
  assert_eq!(format("Hello {}!", ["World"]), "Hello World!")
  assert_eq!(try_format!("Hello {}!", ["World"]), "Hello World!")
}
```

The formatting syntax is similar to Rust's `format!` macro and Cpp's `std::format` function. But we don't support named arguments due to its complexity and the lack of need (MoonBit already has a builtin string interpolation syntax).

### Terminal Styling

The `style` module provides terminal styling functions and types.

We can use the `|` operator to compose styles and finally apply it to a string.
In the future, we may support styling specifier in the format syntax.

For example:

```moonbit
test {
  println(format("{}", [fg(@style.Red) | emph(Bold) | "Bold red text"]))
}
```

### Pretty Printing

The `prettier` package provides pretty printing facilities.

We can implement `prettify` method to format a value as a document, and using combinator to build up the document.

For example:
```moonbit
test {
  let doc = group(text("hello") + nest(break_with(" , ") + text("world")))
  // Here we overload the `width` parameter to specify the pretty printing width.
  assert_eq!(format("{:6}", doc), "hello\n  world")
}
```
