///|
/// Context facade: re-export the @context data-model types —
/// `Grib2ParseError`, `Grib2ContextEditError`, `Grib2SectionFrame`,
/// `Grib2SubmessageFrame`, `Grib2MessageContext`, `Grib2FileContext`. Lets
/// downstream consumers refer to them under the umbrella package instead of
/// importing @context directly.
pub using @context {
  type Grib2ParseError,
  type Grib2ContextEditError,
  type Grib2SectionFrame,
  type Grib2SubmessageFrame,
  type Grib2MessageContext,
  type Grib2FileContext,
}
