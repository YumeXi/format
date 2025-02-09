# YumeXi/format

The library provides formatting facilities for MoonBit.

## Usage

### Formatting

The `base` module implements basic formatting functions and types.

We can use `try_format!` to format a string. If you don't want to get an error, you can use `format` instead. By the way, `print` can be used to format arguments and print to the console.

For example:

```moonbit
test {
  assert_eq!(format("Hello {}!", ["World"]), "Hello World!")
  assert_eq!(try_format!("Hello {}!", ["World"]), "Hello World!")
}
```

The formatting syntax is similar to Rust's `format!` macro and Cpp's `std::format` function. But we don't support named arguments due to its complexity and the lack of need (MoonBit already has a builtin string interpolation syntax).

To use it for user-defined types, you should implement `Formattable` trait with `format` method. We plan to allow custom formatting field to strength the extensibility in the future.

### Terminal Styling

The `style` module provides terminal styling functions and types.

We can use the `|` operator to compose styles and finally apply it to a string.
In the future, we may support styling specifier in the format syntax.

For example:

```moonbit
test {
  @base.print("{}", [fg(@style.Red) | emph(Bold) | "Bold red text"])
}
```

### Pretty Printing

The `prettier` package provides pretty printing facilities.

We can implement the `Pretty` trait with `prettify` method for a type to format values as a document, and using combinator to build up the document.

For example:
```moonbit
test {
  let doc = group(text("hello") + nest(break_with(" , ") + text("world")))
  // Here we overload the `width` parameter to specify the pretty printing width.
  assert_eq!(prettify("{:6}", [doc]), "hello\n  world")
}
```
