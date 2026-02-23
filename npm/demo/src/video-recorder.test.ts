import { describe, it, expect, vi, beforeEach } from 'vitest'
import { VideoRecorder, downloadBlob } from './video-recorder'

describe('VideoRecorder', () => {
  describe('isSupported', () => {
    it('returns false when MediaRecorder is not defined', () => {
      const originalMediaRecorder = globalThis.MediaRecorder
      // @ts-expect-error - intentionally removing for test
      delete globalThis.MediaRecorder

      expect(VideoRecorder.isSupported()).toBe(false)

      globalThis.MediaRecorder = originalMediaRecorder
    })
  })

  describe('getSupportedMimeType', () => {
    beforeEach(() => {
      // Mock MediaRecorder.isTypeSupported
      globalThis.MediaRecorder = {
        isTypeSupported: vi.fn((type: string) => {
          return type === 'video/webm;codecs=vp9' || type === 'video/webm'
        })
      } as unknown as typeof MediaRecorder
    })

    it('returns first supported MIME type', () => {
      const mimeType = VideoRecorder.getSupportedMimeType()
      expect(mimeType).toBe('video/webm;codecs=vp9')
    })

    it('returns null when no types supported', () => {
      globalThis.MediaRecorder = {
        isTypeSupported: vi.fn(() => false)
      } as unknown as typeof MediaRecorder

      const mimeType = VideoRecorder.getSupportedMimeType()
      expect(mimeType).toBeNull()
    })
  })

  describe('isRecording', () => {
    it('returns false when not recording', () => {
      const recorder = new VideoRecorder()
      expect(recorder.isRecording()).toBe(false)
    })
  })
})

describe('downloadBlob', () => {
  it('creates download link and triggers click', () => {
    const mockBlob = new Blob(['test'], { type: 'video/webm' })
    const mockUrl = 'blob:test-url'

    const createObjectURL = vi.fn(() => mockUrl)
    const revokeObjectURL = vi.fn()
    globalThis.URL.createObjectURL = createObjectURL
    globalThis.URL.revokeObjectURL = revokeObjectURL

    const mockClick = vi.fn()
    const mockAppendChild = vi.fn()
    const mockRemoveChild = vi.fn()

    vi.spyOn(document, 'createElement').mockReturnValue({
      href: '',
      download: '',
      click: mockClick
    } as unknown as HTMLAnchorElement)

    vi.spyOn(document.body, 'appendChild').mockImplementation(mockAppendChild)
    vi.spyOn(document.body, 'removeChild').mockImplementation(mockRemoveChild)

    downloadBlob(mockBlob, 'test.webm')

    expect(createObjectURL).toHaveBeenCalledWith(mockBlob)
    expect(mockClick).toHaveBeenCalled()
    expect(revokeObjectURL).toHaveBeenCalledWith(mockUrl)
  })
})
