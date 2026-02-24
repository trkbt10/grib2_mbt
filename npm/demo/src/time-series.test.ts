import { describe, it, expect } from 'vitest'
import { getParameterName, getLevelName } from './time-series'

describe('getParameterName', () => {
  it('returns TMP for category 0, number 0', () => {
    expect(getParameterName(0, 0)).toBe('TMP')
  })

  it('returns UGRD for category 2, number 2', () => {
    expect(getParameterName(2, 2)).toBe('UGRD')
  })

  it('returns VGRD for category 2, number 3', () => {
    expect(getParameterName(2, 3)).toBe('VGRD')
  })

  it('returns HGT for category 3, number 5', () => {
    expect(getParameterName(3, 5)).toBe('HGT')
  })

  it('returns generic name for unknown parameters', () => {
    expect(getParameterName(99, 99)).toBe('PARAM_99_99')
  })
})

describe('getLevelName', () => {
  it('returns pressure level for type 100', () => {
    // 50000 Pa = 500 hPa
    expect(getLevelName(100, 0, 50000)).toBe('500 hPa')
  })

  it('returns MSL for type 101', () => {
    expect(getLevelName(101, 0, 0)).toBe('mean sea level')
  })

  it('returns surface for type 1', () => {
    expect(getLevelName(1, 0, 0)).toBe('surface')
  })

  it('returns height above ground for type 103', () => {
    expect(getLevelName(103, 0, 2)).toBe('2 m above ground')
  })

  it('returns generic name for unknown level types', () => {
    expect(getLevelName(999, 0, 0)).toBe('level_999')
  })

  it('handles scale factor for pressure levels', () => {
    // 500 with scale -2 = 500 * 10^2 = 50000 Pa = 500 hPa
    expect(getLevelName(100, -2, 500)).toBe('500 hPa')
  })
})
