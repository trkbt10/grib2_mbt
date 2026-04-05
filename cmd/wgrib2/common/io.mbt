///|
using @context {
  type Grib2FileContext,
  type Grib2MessageContext,
  type Grib2SubmessageFrame,
  type Grib2SectionFrame,
}

///|
pub fn native_read_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read file: " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
pub fn native_write_bytes(
  path : String,
  bytes : Bytes,
) -> Result[Unit, String] {
  try @fs.write_bytes_to_file(path, bytes) catch {
    error => Err("failed to write file: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}

///|
pub fn native_write_string(
  path : String,
  content : String,
) -> Result[Unit, String] {
  try @fs.write_string_to_file(path, content) catch {
    error => Err("failed to write file: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}

///|
pub fn native_append_bytes(
  path : String,
  bytes : Bytes,
) -> Result[Unit, String] {
  let existing = @fs.read_file_to_bytes(path) catch { _ => Bytes::new(0) }
  let out : Array[Byte] = []
  for b in existing {
    out.push(b)
  }
  for b in bytes {
    out.push(b)
  }
  native_write_bytes(path, Bytes::from_array(out))
}

///|
pub fn native_append_string(
  path : String,
  content : String,
) -> Result[Unit, String] {
  let existing = @fs.read_file_to_string(path) catch { _ => "" }
  native_write_string(path, existing + content)
}

///|
pub fn print_lines(lines : Array[String]) -> Unit {
  for line in lines {
    println(line)
  }
}

///|
pub fn print_lines_crlf(lines : Array[String]) -> Unit {
  for line in lines {
    println(line + "\r")
  }
}

///|
pub fn parse_int_option(s : String) -> Int? {
  Some(@strconv.parse_int(s)) catch {
    _ => None
  }
}

///|
pub fn parse_double_option(s : String) -> Double? {
  Some(@strconv.parse_double(s)) catch {
    _ => None
  }
}

///|
pub fn record_is_selected(
  record_index : Int,
  selected : Array[Int]?,
) -> Bool {
  match selected {
    None => true
    Some(records) => {
      for n in records {
        if n == record_index {
          return true
        }
      }
      false
    }
  }
}

///|
pub fn section_frame_bytes(
  message : Grib2MessageContext,
  frame : Grib2SectionFrame,
) -> Bytes {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~).to_bytes()
}

///|
pub fn append_bytes(out : Array[Byte], bytes : Bytes) -> Unit {
  for b in bytes {
    out.push(b)
  }
}

///|
pub fn build_output_content(lines : Array[String], crlf : Bool) -> String {
  if lines.length() == 0 {
    return ""
  }
  let eol = if crlf { "\r\n" } else { "\n" }
  lines.join(eol) + eol
}
