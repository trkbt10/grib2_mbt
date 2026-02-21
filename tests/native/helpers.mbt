///|
pub fn import_probe() -> Int {
  let _ = @lib.fib(1)
  if @fs.path_exists("fixtures") {
    1
  } else {
    0
  }
}
