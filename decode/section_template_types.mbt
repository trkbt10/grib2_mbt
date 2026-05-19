///|
/// Whether the Section 3 Grid Definition Template number is recognised by the
/// decoder. Unknown templates still surface their numeric ID so callers can
/// pass the message through other tooling.
pub(all) enum Grib2Section3Template {
  Section3TemplateKnown(Int)
  Section3TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section3Template::id(self : Grib2Section3Template) -> Int {
  match self {
    Section3TemplateKnown(id) => id
    Section3TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section3Template::is_known(self : Grib2Section3Template) -> Bool {
  match self {
    Section3TemplateKnown(_) => true
    Section3TemplateUnknown(_) => false
  }
}

///|
/// Whether the Section 4 Product Definition Template number is recognised.
pub(all) enum Grib2Section4Template {
  Section4TemplateKnown(Int)
  Section4TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section4Template::id(self : Grib2Section4Template) -> Int {
  match self {
    Section4TemplateKnown(id) => id
    Section4TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section4Template::is_known(self : Grib2Section4Template) -> Bool {
  match self {
    Section4TemplateKnown(_) => true
    Section4TemplateUnknown(_) => false
  }
}

///|
/// Whether the Section 5 Data Representation Template number is recognised.
pub(all) enum Grib2Section5Template {
  Section5TemplateKnown(Int)
  Section5TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section5Template::id(self : Grib2Section5Template) -> Int {
  match self {
    Section5TemplateKnown(id) => id
    Section5TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section5Template::is_known(self : Grib2Section5Template) -> Bool {
  match self {
    Section5TemplateKnown(_) => true
    Section5TemplateUnknown(_) => false
  }
}
