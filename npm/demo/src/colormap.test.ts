import { describe, it, expect } from 'vitest'
import { temperatureColormap, temperatureKelvinToColor, createColorScale } from './colormap'

describe('temperatureColormap', () => {
  it('returns blue at t=0', () => {
    const [r, g, b] = temperatureColormap(0)
    expect(r).toBe(0)
    expect(g).toBe(0)
    expect(b).toBe(255)
  })

  it('returns white at t=0.5', () => {
    const [r, g, b] = temperatureColormap(0.5)
    expect(r).toBe(255)
    expect(g).toBe(255)
    expect(b).toBe(255)
  })

  it('returns red at t=1', () => {
    const [r, g, b] = temperatureColormap(1)
    expect(r).toBe(255)
    expect(g).toBe(0)
    expect(b).toBe(0)
  })

  it('clamps values below 0', () => {
    const [r, g, b] = temperatureColormap(-0.5)
    expect(r).toBe(0)
    expect(g).toBe(0)
    expect(b).toBe(255)
  })

  it('clamps values above 1', () => {
    const [r, g, b] = temperatureColormap(1.5)
    expect(r).toBe(255)
    expect(g).toBe(0)
    expect(b).toBe(0)
  })

  it('interpolates between blue and white at t=0.25', () => {
    const [r, g, b] = temperatureColormap(0.25)
    expect(r).toBe(128)
    expect(g).toBe(128)
    expect(b).toBe(255)
  })

  it('interpolates between white and red at t=0.75', () => {
    const [r, g, b] = temperatureColormap(0.75)
    expect(r).toBe(255)
    expect(g).toBe(128)
    expect(b).toBe(128)
  })
})

describe('temperatureKelvinToColor', () => {
  it('maps minimum kelvin to blue', () => {
    const [r, g, b] = temperatureKelvinToColor(220, 220, 320)
    expect(r).toBe(0)
    expect(g).toBe(0)
    expect(b).toBe(255)
  })

  it('maps maximum kelvin to red', () => {
    const [r, g, b] = temperatureKelvinToColor(320, 220, 320)
    expect(r).toBe(255)
    expect(g).toBe(0)
    expect(b).toBe(0)
  })

  it('maps middle kelvin to white', () => {
    const [r, g, b] = temperatureKelvinToColor(270, 220, 320)
    expect(r).toBe(255)
    expect(g).toBe(255)
    expect(b).toBe(255)
  })
})

describe('createColorScale', () => {
  it('creates ImageData with correct dimensions', () => {
    const imageData = createColorScale(100, 20)
    expect(imageData.width).toBe(100)
    expect(imageData.height).toBe(20)
    expect(imageData.data.length).toBe(100 * 20 * 4)
  })

  it('has full opacity for all pixels', () => {
    const imageData = createColorScale(10, 5)
    for (let i = 3; i < imageData.data.length; i += 4) {
      expect(imageData.data[i]).toBe(255)
    }
  })

  it('starts with blue on the left', () => {
    const imageData = createColorScale(10, 1)
    expect(imageData.data[0]).toBe(0)   // R
    expect(imageData.data[1]).toBe(0)   // G
    expect(imageData.data[2]).toBe(255) // B
  })

  it('ends with red on the right', () => {
    const imageData = createColorScale(10, 1)
    const lastPixel = (10 - 1) * 4
    expect(imageData.data[lastPixel]).toBe(255)     // R
    expect(imageData.data[lastPixel + 1]).toBe(0)   // G
    expect(imageData.data[lastPixel + 2]).toBe(0)   // B
  })
})
