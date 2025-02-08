///|
pub impl Prettifiable for String with prettify(self) { text(self) }

///|
pub impl Prettifiable for Int with prettify(self) { text(self.to_string()) }
