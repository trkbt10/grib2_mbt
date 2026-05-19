///|
/// Right-align `text` to `width` columns by padding on the left with spaces.
/// When the text already exceeds the requested width it is returned as-is so
/// that callers can compose this with `-text_col` style formatting without
/// truncation surprises.
pub fn pad_left(text : String, width : Int) -> String {
  if text.length() >= width {
    text
  } else {
    " ".repeat(width - text.length()) + text
  }
}
