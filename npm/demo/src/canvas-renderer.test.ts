import { describe, it, expect } from 'vitest'
import { calculateStats } from './canvas-renderer'

describe('calculateStats', () => {
  it('calculates min, max, mean for valid values', () => {
    const values = [10, 20, 30, 40, 50]
    const stats = calculateStats(values)
    expect(stats.min).toBe(10)
    expect(stats.max).toBe(50)
    expect(stats.mean).toBe(30)
    expect(stats.validCount).toBe(5)
  })

  it('handles null values', () => {
    const values: Array<number | null> = [10, null, 30, null, 50]
    const stats = calculateStats(values)
    expect(stats.min).toBe(10)
    expect(stats.max).toBe(50)
    expect(stats.mean).toBe(30)
    expect(stats.validCount).toBe(3)
  })

  it('handles all null values', () => {
    const values: Array<number | null> = [null, null, null]
    const stats = calculateStats(values)
    expect(stats.min).toBe(0)
    expect(stats.max).toBe(0)
    expect(stats.mean).toBe(0)
    expect(stats.validCount).toBe(0)
  })

  it('handles empty array', () => {
    const stats = calculateStats([])
    expect(stats.min).toBe(0)
    expect(stats.max).toBe(0)
    expect(stats.mean).toBe(0)
    expect(stats.validCount).toBe(0)
  })

  it('handles single value', () => {
    const stats = calculateStats([42])
    expect(stats.min).toBe(42)
    expect(stats.max).toBe(42)
    expect(stats.mean).toBe(42)
    expect(stats.validCount).toBe(1)
  })

  it('handles negative values', () => {
    const values = [-30, -10, 0, 10, 30]
    const stats = calculateStats(values)
    expect(stats.min).toBe(-30)
    expect(stats.max).toBe(30)
    expect(stats.mean).toBe(0)
    expect(stats.validCount).toBe(5)
  })
})
