/**
 * Video recorder using MediaRecorder API
 */

export interface RecorderOptions {
  frameRate?: number;
  videoBitsPerSecond?: number;
}

/**
 * VideoRecorder: Wrapper for MediaRecorder API to record canvas animations.
 */
export class VideoRecorder {
  private mediaRecorder: MediaRecorder | null = null;
  private chunks: Blob[] = [];
  private stream: MediaStream | null = null;

  /**
   * Check if MediaRecorder is supported.
   */
  static isSupported(): boolean {
    return typeof MediaRecorder !== 'undefined' &&
           typeof HTMLCanvasElement.prototype.captureStream === 'function';
  }

  /**
   * Get supported MIME types.
   */
  static getSupportedMimeType(): string | null {
    const types = [
      'video/webm;codecs=vp9',
      'video/webm;codecs=vp8',
      'video/webm',
      'video/mp4'
    ];

    for (const type of types) {
      if (MediaRecorder.isTypeSupported(type)) {
        return type;
      }
    }
    return null;
  }

  /**
   * Start recording from a canvas.
   */
  startRecording(canvas: HTMLCanvasElement, options: RecorderOptions = {}): void {
    if (!VideoRecorder.isSupported()) {
      throw new Error('MediaRecorder API is not supported in this browser');
    }

    const mimeType = VideoRecorder.getSupportedMimeType();
    if (!mimeType) {
      throw new Error('No supported video MIME type found');
    }

    const frameRate = options.frameRate ?? 10;
    this.stream = canvas.captureStream(frameRate);
    this.chunks = [];

    const recorderOptions: MediaRecorderOptions = {
      mimeType,
      videoBitsPerSecond: options.videoBitsPerSecond ?? 2500000
    };

    this.mediaRecorder = new MediaRecorder(this.stream, recorderOptions);

    this.mediaRecorder.ondataavailable = (event) => {
      if (event.data.size > 0) {
        this.chunks.push(event.data);
      }
    };

    this.mediaRecorder.start(100); // Collect data every 100ms
  }

  /**
   * Stop recording and return the video blob.
   */
  stopRecording(): Promise<Blob> {
    return new Promise((resolve, reject) => {
      if (!this.mediaRecorder) {
        reject(new Error('No recording in progress'));
        return;
      }

      this.mediaRecorder.onstop = () => {
        const mimeType = this.mediaRecorder?.mimeType ?? 'video/webm';
        const blob = new Blob(this.chunks, { type: mimeType });
        this.cleanup();
        resolve(blob);
      };

      this.mediaRecorder.onerror = (event) => {
        this.cleanup();
        reject(new Error(`Recording error: ${event}`));
      };

      this.mediaRecorder.stop();
    });
  }

  /**
   * Check if currently recording.
   */
  isRecording(): boolean {
    return this.mediaRecorder?.state === 'recording';
  }

  /**
   * Clean up resources.
   */
  private cleanup(): void {
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
      this.stream = null;
    }
    this.mediaRecorder = null;
    this.chunks = [];
  }
}

/**
 * Download a blob as a file.
 */
export function downloadBlob(blob: Blob, filename: string): void {
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
