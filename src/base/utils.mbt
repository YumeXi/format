///|
let debug_enabled : Ref[Bool] = @ref.new(false)

///|
pub fn[T : Show] debug(
  v : T,
  with_loc~ : Bool = true,
  loc~ : SourceLoc = _
) -> Unit {
  if debug_enabled.val {
    if with_loc {
      println("[\{v} at \{loc}]")
    } else {
      println(["\{v}"])
    }
  }
}

///|
pub fn set_debug(enabled~ : Bool) -> Unit {
  debug_enabled.val = enabled
}
