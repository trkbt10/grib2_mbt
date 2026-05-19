///|
/// A lookup result that distinguishes between an authoritative WMO/local-table
/// hit (`NameKnown`) and a fallback rendering of the raw numeric code when no
/// description is available (`NameUnknown`). Both variants carry a printable
/// string so the caller can display the value either way.
pub(all) enum Grib2NameLookup {
  NameKnown(String)
  NameUnknown(String)
} derive(Show)

///|
pub fn Grib2NameLookup::display(self : Grib2NameLookup) -> String {
  match self {
    NameKnown(value) => value
    NameUnknown(raw) => raw
  }
}
