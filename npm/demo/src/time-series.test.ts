import { describe, it, expect } from 'vitest'
import { extractForecastHour, TimeSeriesManager } from './time-series'
import type { RecordMeta, LoadedFile } from './types'

describe('extractForecastHour', () => {
  it('extracts hour from "3 hour fcst"', () => {
    expect(extractForecastHour('3 hour fcst')).toBe(3)
  })

  it('extracts hour from "12 hour fcst"', () => {
    expect(extractForecastHour('12 hour fcst')).toBe(12)
  })

  it('returns 0 for "anl" (analysis)', () => {
    expect(extractForecastHour('anl')).toBe(0)
  })

  it('returns 0 for analysis text', () => {
    expect(extractForecastHour('analysis')).toBe(0)
  })

  it('handles case insensitive', () => {
    expect(extractForecastHour('6 Hour Fcst')).toBe(6)
  })

  it('converts days to hours', () => {
    expect(extractForecastHour('1 day fcst')).toBe(24)
    expect(extractForecastHour('2 day fcst')).toBe(48)
  })

  it('returns 0 for empty string', () => {
    expect(extractForecastHour('')).toBe(0)
  })
})

describe('TimeSeriesManager', () => {
  function createMockMeta(
    parameterName: string,
    levelName: string,
    forecastTail: string,
    recordIndex: number
  ): RecordMeta {
    return {
      recordIndex,
      recordId: `record-${recordIndex}`,
      messageOffset: 0,
      messageTotalLength: 1000,
      referenceTime: '2024-12-06T00:00:00Z',
      discipline: 0,
      edition: 2,
      parameterName,
      levelName,
      forecastTail,
      section3Template: 0,
      section4Template: 0,
      section5Template: 0,
      section3Ni: 505,
      section3Nj: 481,
      section3Lat1Microdeg: 22400000,
      section3Lon1Microdeg: 120000000,
      section3Lat2Microdeg: 47600000,
      section3Lon2Microdeg: 150000000,
      section5NumDefinedPoints: 243005
    }
  }

  function createMockFile(name: string, handle: number, records: RecordMeta[]): LoadedFile {
    return { name, handle, records }
  }

  it('getParameterNames returns unique sorted names', () => {
    const manager = new TimeSeriesManager()
    manager.addFile(createMockFile('file1.bin', 1, [
      createMockMeta('TMP', '500 mb', 'anl', 1),
      createMockMeta('HGT', '500 mb', 'anl', 2),
      createMockMeta('TMP', '850 mb', 'anl', 3)
    ]))

    const params = manager.getParameterNames()
    expect(params).toEqual(['HGT', 'TMP'])
  })

  it('getPressureLevels returns sorted levels for a parameter', () => {
    const manager = new TimeSeriesManager()
    manager.addFile(createMockFile('file1.bin', 1, [
      createMockMeta('TMP', '500 mb', 'anl', 1),
      createMockMeta('TMP', '850 mb', 'anl', 2),
      createMockMeta('TMP', '1000 mb', 'anl', 3)
    ]))

    const levels = manager.getPressureLevels('TMP')
    expect(levels).toEqual([1000, 850, 500])
  })

  it('buildTimeSeries returns frames sorted by forecast hour', () => {
    const manager = new TimeSeriesManager()
    manager.addFile(createMockFile('file1.bin', 1, [
      createMockMeta('TMP', '500 mb', '6 hour fcst', 1),
      createMockMeta('TMP', '500 mb', 'anl', 2),
      createMockMeta('TMP', '500 mb', '3 hour fcst', 3)
    ]))

    const frames = manager.buildTimeSeries('TMP', 500)
    expect(frames.length).toBe(3)
    expect(frames[0].forecastHour).toBe(0)
    expect(frames[1].forecastHour).toBe(3)
    expect(frames[2].forecastHour).toBe(6)
  })

  it('buildTimeSeries filters by pressure level', () => {
    const manager = new TimeSeriesManager()
    manager.addFile(createMockFile('file1.bin', 1, [
      createMockMeta('TMP', '500 mb', 'anl', 1),
      createMockMeta('TMP', '850 mb', 'anl', 2),
      createMockMeta('TMP', '500 mb', '3 hour fcst', 3)
    ]))

    const frames = manager.buildTimeSeries('TMP', 500)
    expect(frames.length).toBe(2)
    expect(frames.every(f => f.meta.levelName.includes('500 mb'))).toBe(true)
  })

  it('clear removes all files and frames', () => {
    const manager = new TimeSeriesManager()
    manager.addFile(createMockFile('file1.bin', 1, [
      createMockMeta('TMP', '500 mb', 'anl', 1)
    ]))

    expect(manager.getParameterNames().length).toBeGreaterThan(0)

    manager.clear()
    expect(manager.getParameterNames()).toEqual([])
    expect(manager.frameCount).toBe(0)
  })
})
