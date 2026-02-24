#!/usr/bin/env node

import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');
const dtsPath = join(projectRoot, 'npm', 'index.d.ts');
const generatorPath = join(projectRoot, 'scripts', 'generate-wasm-dts.mjs');

const before = readFileSync(dtsPath, 'utf8');

const run = spawnSync(process.execPath, [generatorPath], {
  cwd: projectRoot,
  stdio: 'inherit'
});

if (run.status !== 0) {
  process.exit(run.status ?? 1);
}

const after = readFileSync(dtsPath, 'utf8');
if (before !== after) {
  console.error('ERROR: npm/index.d.ts was out of date and has been rewritten.');
  console.error('Please commit the regenerated npm/index.d.ts.');
  process.exit(1);
}

console.log('OK: npm/index.d.ts is up to date.');
