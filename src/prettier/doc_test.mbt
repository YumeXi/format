test {
  let doc = group(text("hello") + nest(break_with(" , ") + text("world")))
  inspect!(
    @base.format("{:11}", [doc]),
    content=
      #|hello
      #|  world
    ,
  )
  inspect!(
    @base.format("{:14}", [doc]),
    content=
      #|hello , world
    ,
  )
}
