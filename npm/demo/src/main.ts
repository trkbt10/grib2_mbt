/**
 * GRIB2 WASM Demo - Main Application
 */

import type { LoadedFile, TimeSeriesFrame } from './types';
import { initBrowser, openGrib2 } from './grib2';
import { renderGrid, drawColorScale, calculateStats } from './canvas-renderer';
import { TimeSeriesManager, applyTemporalMovingAverage, getParameterName } from './time-series';
import { VideoRecorder, downloadBlob } from './video-recorder';

// Fixture paths (served from public directory)
const FIXTURES = {
  MSM: [
    '/fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin',
    '/fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin',
    '/fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin'
  ],
  GSM: [
    '/fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin'
  ]
};

// DOM Elements
const statusEl = document.getElementById('status') as HTMLDivElement;
const loadMsmBtn = document.getElementById('loadMsm') as HTMLButtonElement;
const loadGsmBtn = document.getElementById('loadGsm') as HTMLButtonElement;
const fileInput = document.getElementById('fileInput') as HTMLInputElement;
const paramSelect = document.getElementById('paramSelect') as HTMLSelectElement;
const levelSelect = document.getElementById('levelSelect') as HTMLSelectElement;
const timeSlider = document.getElementById('timeSlider') as HTMLInputElement;
const timeValue = document.getElementById('timeValue') as HTMLSpanElement;
const playBtn = document.getElementById('playBtn') as HTMLButtonElement;
const avgSlider = document.getElementById('avgSlider') as HTMLInputElement;
const avgValue = document.getElementById('avgValue') as HTMLSpanElement;
const recordBtn = document.getElementById('recordBtn') as HTMLButtonElement;
const gridCanvas = document.getElementById('gridCanvas') as HTMLCanvasElement;
const scaleCanvas = document.getElementById('scaleCanvas') as HTMLCanvasElement;
const statsEl = document.getElementById('stats') as HTMLDivElement;

// State
const timeSeriesManager = new TimeSeriesManager();
const videoRecorder = new VideoRecorder();
let currentFrames: TimeSeriesFrame[] = [];
let isPlaying = false;
let playInterval: number | null = null;
let currentNi = 505;
let currentNj = 481;
let globalMinValue = 220;
let globalMaxValue = 320;

function setStatus(message: string, type: 'loading' | 'error' | 'success' = 'loading'): void {
  statusEl.textContent = message;
  statusEl.className = `status ${type}`;
}

function enableControls(enabled: boolean): void {
  loadMsmBtn.disabled = !enabled;
  loadGsmBtn.disabled = !enabled;
  fileInput.disabled = !enabled;
}

function enableTimelineControls(enabled: boolean): void {
  timeSlider.disabled = !enabled;
  playBtn.disabled = !enabled;
  avgSlider.disabled = !enabled;
  recordBtn.disabled = !enabled;
}

async function loadFile(url: string): Promise<LoadedFile> {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch ${url}: ${response.status}`);
  }

  const arrayBuffer = await response.arrayBuffer();
  const data = new Uint8Array(arrayBuffer);

  const grib2 = openGrib2(data);
  const name = url.split('/').pop() ?? url;

  return { name, grib2 };
}

async function loadFixtures(urls: string[]): Promise<void> {
  enableControls(false);
  enableTimelineControls(false);
  timeSeriesManager.clear();

  setStatus(`Loading ${urls.length} file(s)...`);

  try {
    for (let i = 0; i < urls.length; i++) {
      setStatus(`Loading file ${i + 1}/${urls.length}...`);
      const file = await loadFile(urls[i]);
      timeSeriesManager.addFile(file);
    }

    updateParameterSelect();
    setStatus(`Loaded ${urls.length} file(s) successfully`, 'success');
    enableControls(true);
  } catch (error) {
    setStatus(`Error: ${error instanceof Error ? error.message : error}`, 'error');
    enableControls(true);
  }
}

function updateParameterSelect(): void {
  const params = timeSeriesManager.getParameterNames();

  paramSelect.innerHTML = '';

  if (params.length === 0) {
    paramSelect.innerHTML = '<option value="">No parameters found</option>';
    paramSelect.disabled = true;
    return;
  }

  for (const param of params) {
    const option = document.createElement('option');
    option.value = param;
    option.textContent = param;
    paramSelect.appendChild(option);
  }

  paramSelect.disabled = false;

  // Auto-select TMP if available
  const tmpParam = params.find(p => p.includes('TMP') || p.includes('Temperature'));
  if (tmpParam) {
    paramSelect.value = tmpParam;
  }

  updateLevelSelect();
}

function updateLevelSelect(): void {
  const param = paramSelect.value;
  const levels = timeSeriesManager.getPressureLevelOptions(param);

  levelSelect.innerHTML = '';

  if (levels.length === 0) {
    levelSelect.innerHTML = '<option value="">No levels</option>';
    levelSelect.disabled = true;
    return;
  }

  for (const level of levels) {
    const option = document.createElement('option');
    option.value = level.key;
    option.textContent = level.label;
    levelSelect.appendChild(option);
  }

  levelSelect.disabled = false;

  // Auto-select 500 hPa if available
  const level500 = levels.find(l => Math.abs(l.hpa - 500) <= 1e-9);
  if (level500) {
    levelSelect.value = level500.key;
  }

  updateTimeSeries();
}

function updateTimeSeries(): void {
  const param = paramSelect.value;
  const levelKey = levelSelect.value;

  if (!param || !levelKey) {
    currentFrames = [];
    enableTimelineControls(false);
    return;
  }

  currentFrames = timeSeriesManager.buildTimeSeriesByLevelKey(param, levelKey);

  if (currentFrames.length === 0) {
    enableTimelineControls(false);
    return;
  }

  // Update grid dimensions from first frame
  const record = currentFrames[0].record;
  const { ni, nj } = record.gridDimensions;
  currentNi = ni;
  currentNj = nj;

  // Update timeline slider
  timeSlider.min = '0';
  timeSlider.max = String(currentFrames.length - 1);
  timeSlider.value = '0';

  enableTimelineControls(true);
  renderCurrentFrame();
}

function renderCurrentFrame(): void {
  const frameIndex = parseInt(timeSlider.value, 10);
  const avgRadius = parseInt(avgSlider.value, 10);

  if (currentFrames.length === 0 || frameIndex >= currentFrames.length) {
    return;
  }

  const frame = currentFrames[frameIndex];
  timeValue.textContent = `FH+${frame.forecastHour}h`;

  try {
    const grid = applyTemporalMovingAverage(currentFrames, frameIndex, avgRadius);

    if (!grid) {
      setStatus('Failed to decode grid data', 'error');
      return;
    }

    // Calculate stats for the first render to set global min/max
    const stats = calculateStats(grid.values);

    // Use global range for consistent coloring across time
    if (frameIndex === 0 && avgRadius === 0) {
      // Expand range slightly for better visualization
      const margin = (stats.max - stats.min) * 0.1;
      globalMinValue = stats.min - margin;
      globalMaxValue = stats.max + margin;
    }

    renderGrid(gridCanvas, grid.values, currentNi, currentNj, {
      minValue: globalMinValue,
      maxValue: globalMaxValue
    });

    // Draw color scale
    const paramName = getParameterName(
      frame.record.parameterCategory,
      frame.record.parameterNumber
    );
    const unit = paramName.includes('TMP') ? 'K' : '';
    drawColorScale(scaleCanvas, globalMinValue, globalMaxValue, unit);

    // Show stats
    statsEl.innerHTML = `
      <strong>Grid:</strong> ${currentNi} x ${currentNj} |
      <strong>Min:</strong> ${stats.min.toFixed(2)} |
      <strong>Max:</strong> ${stats.max.toFixed(2)} |
      <strong>Mean:</strong> ${stats.mean.toFixed(2)} |
      <strong>Valid:</strong> ${stats.validCount.toLocaleString()} points
    `;
    statsEl.classList.remove('hidden');

  } catch (error) {
    setStatus(`Render error: ${error instanceof Error ? error.message : error}`, 'error');
  }
}

function startPlayback(): void {
  if (isPlaying) return;

  isPlaying = true;
  playBtn.textContent = 'Pause';

  playInterval = window.setInterval(() => {
    let next = parseInt(timeSlider.value, 10) + 1;
    if (next >= currentFrames.length) {
      next = 0;
    }
    timeSlider.value = String(next);
    renderCurrentFrame();
  }, 500);
}

function stopPlayback(): void {
  if (!isPlaying) return;

  isPlaying = false;
  playBtn.textContent = 'Play';

  if (playInterval !== null) {
    clearInterval(playInterval);
    playInterval = null;
  }
}

async function startRecording(): Promise<void> {
  if (videoRecorder.isRecording()) {
    // Stop recording
    recordBtn.textContent = 'Saving...';
    recordBtn.disabled = true;

    try {
      const blob = await videoRecorder.stopRecording();
      downloadBlob(blob, `grib2-animation-${Date.now()}.webm`);
      setStatus('Video saved!', 'success');
    } catch (error) {
      setStatus(`Recording error: ${error instanceof Error ? error.message : error}`, 'error');
    }

    recordBtn.textContent = 'Record';
    recordBtn.disabled = false;
    recordBtn.classList.remove('recording');
    stopPlayback();
    return;
  }

  // Start recording
  if (!VideoRecorder.isSupported()) {
    setStatus('Video recording is not supported in this browser', 'error');
    return;
  }

  try {
    // Reset to start
    timeSlider.value = '0';
    renderCurrentFrame();

    videoRecorder.startRecording(gridCanvas, { frameRate: 5 });
    recordBtn.textContent = 'Stop';
    recordBtn.classList.add('recording');
    setStatus('Recording... Click Stop when done', 'loading');

    // Start playback
    startPlayback();
  } catch (error) {
    setStatus(`Failed to start recording: ${error instanceof Error ? error.message : error}`, 'error');
  }
}

// Event Listeners
loadMsmBtn.addEventListener('click', () => loadFixtures(FIXTURES.MSM));
loadGsmBtn.addEventListener('click', () => loadFixtures(FIXTURES.GSM));

fileInput.addEventListener('change', async () => {
  const file = fileInput.files?.[0];
  if (!file) return;

  enableControls(false);
  enableTimelineControls(false);
  timeSeriesManager.clear();

  setStatus(`Loading ${file.name}...`);

  try {
    const arrayBuffer = await file.arrayBuffer();
    const data = new Uint8Array(arrayBuffer);

    const grib2 = openGrib2(data);
    timeSeriesManager.addFile({ name: file.name, grib2 });

    updateParameterSelect();
    setStatus(`Loaded ${file.name} (${grib2.recordCount} records)`, 'success');
  } catch (error) {
    setStatus(`Error: ${error instanceof Error ? error.message : error}`, 'error');
  }

  enableControls(true);
  fileInput.value = '';
});

paramSelect.addEventListener('change', updateLevelSelect);
levelSelect.addEventListener('change', updateTimeSeries);

timeSlider.addEventListener('input', () => {
  if (!isPlaying) {
    renderCurrentFrame();
  }
});

avgSlider.addEventListener('input', () => {
  avgValue.textContent = avgSlider.value;
  renderCurrentFrame();
});

playBtn.addEventListener('click', () => {
  if (isPlaying) {
    stopPlayback();
  } else {
    startPlayback();
  }
});

recordBtn.addEventListener('click', startRecording);

// Initialize
async function init(): Promise<void> {
  try {
    setStatus('Initializing WASM module...');

    // WASM file is served from public directory
    const wasmUrl = '/grib2.wasm';
    await initBrowser(wasmUrl);

    setStatus('Ready. Select a fixture or upload a file.', 'success');
    enableControls(true);
  } catch (error) {
    setStatus(`Failed to initialize: ${error instanceof Error ? error.message : error}`, 'error');
  }
}

init();
