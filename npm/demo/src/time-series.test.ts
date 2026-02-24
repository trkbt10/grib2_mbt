import { describe, it, expect } from 'vitest'
import { getParameterName, getLevelName, TimeSeriesManager } from './time-series'
import type { Grib2Record, RecordIterator } from './grib2'
import type { LoadedFile } from './types'

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

function mockRecord(opts: {
  category: number
  number: number
  levelType: number
  scaleFactor: number
  scaledValue: number
  forecastTime: number
}) {
  return {
    section4: {
      parameterCategory: opts.category,
      parameterNumber: opts.number,
      typeOfFirstFixedSurface: opts.levelType,
      scaleFactorOfFirstFixedSurface: opts.scaleFactor,
      scaledValueOfFirstFixedSurface: opts.scaledValue,
      indicatorOfUnitOfTimeRange: 1,
      forecastTime: opts.forecastTime
    }
  } as unknown as Grib2Record
}

function mockLoadedFile(records: Grib2Record[]): LoadedFile {
  return {
    name: 'mock',
    grib2: {
      records: () => records as unknown as RecordIterator
    } as unknown as LoadedFile['grib2']
  }
}

describe('TimeSeriesManager pressure level keys', () => {
  it('builds stable level options and labels including tiny scientific values', () => {
    const manager = new TimeSeriesManager()
    const records = [
      mockRecord({
        category: 0,
        number: 0,
        levelType: 100,
        scaleFactor: 0,
        scaledValue: 50000,
        forecastTime: 0
      }),
      mockRecord({
        category: 0,
        number: 0,
        levelType: 100,
        scaleFactor: 132,
        scaledValue: 60000,
        forecastTime: 1
      })
    ]
    manager.addFile(mockLoadedFile(records))

    const levels = manager.getPressureLevelOptions('TMP')
    expect(levels.length).toBe(2)
    expect(levels[0].key).toBe('100:0:50000')
    expect(levels[0].label).toBe('500 mb')
    expect(levels[1].key).toBe('100:132:60000')
    expect(levels[1].label).toMatch(/e-130 mb$/)
  })

  it('selects frames by level key without floating-point comparison issues', () => {
    const manager = new TimeSeriesManager()
    const records = [
      mockRecord({
        category: 0,
        number: 0,
        levelType: 100,
        scaleFactor: 132,
        scaledValue: 60000,
        forecastTime: 6
      }),
      mockRecord({
        category: 0,
        number: 0,
        levelType: 100,
        scaleFactor: 132,
        scaledValue: 60000,
        forecastTime: 0
      }),
      mockRecord({
        category: 0,
        number: 0,
        levelType: 100,
        scaleFactor: 0,
        scaledValue: 50000,
        forecastTime: 3
      })
    ]
    manager.addFile(mockLoadedFile(records))

    const frames = manager.buildTimeSeriesByLevelKey('TMP', '100:132:60000')
    expect(frames.length).toBe(2)
    expect(frames[0].forecastHour).toBe(0)
    expect(frames[1].forecastHour).toBe(6)
  })
})
