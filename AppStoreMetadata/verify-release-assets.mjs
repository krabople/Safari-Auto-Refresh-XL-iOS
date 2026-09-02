import { createRequire } from 'node:module';
import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const repo = path.resolve(import.meta.dirname, '..');
const storeRoot = 'C:/Users/krabo/OneDrive/Documents/App dev stuff/Auto Refresh XL App Store Stuff';
const locales = ['en-GB','en-US','de-DE','fr-FR','es-ES','it-IT','pt-BR','nl-NL','ja-JP','ko-KR','zh-Hans','zh-Hant'];

async function visibleDigest(file) {
  const pixels = await sharp(file)
    .flatten({ background: '#ffffff' })
    .removeAlpha()
    .raw()
    .toBuffer();
  return crypto.createHash('sha256').update(pixels).digest('hex');
}

async function findNumberedScreenshot(root, locale, number) {
  const prefix = `${String(number).padStart(2, '0')}-`;
  const names = await fs.readdir(path.join(root, locale));
  const name = names.find(item => item.startsWith(prefix) && item.toLowerCase().endsWith('.png'));
  if (!name) throw new Error(`Missing screenshot ${prefix} for ${locale} in ${root}`);
  return path.join(root, locale, name);
}

async function verifyScreenshotSet({ oldRoot, newRoot, width, height, label }) {
  let count = 0;
  for (const locale of locales) {
    for (let number = 1; number <= 5; number += 1) {
      const file = await findNumberedScreenshot(newRoot, locale, number);
      const metadata = await sharp(file).metadata();
      if (metadata.width !== width || metadata.height !== height) {
        throw new Error(`${label} ${locale} screenshot ${number} is ${metadata.width}x${metadata.height}`);
      }
      if (metadata.hasAlpha) throw new Error(`${label} ${locale} screenshot ${number} contains alpha`);
      if (number > 1) {
        const previous = await findNumberedScreenshot(oldRoot, locale, number);
        if (await visibleDigest(file) !== await visibleDigest(previous)) {
          throw new Error(`${label} ${locale} screenshot ${number} changed unexpectedly`);
        }
      }
      count += 1;
    }
  }
  return count;
}

const phoneCount = await verifyScreenshotSet({
  oldRoot: path.join(storeRoot, 'Localized-Final'),
  newRoot: path.join(storeRoot, 'Localized-Final-v4'),
  width: 1242,
  height: 2688,
  label: 'iPhone'
});
const ipadCount = await verifyScreenshotSet({
  oldRoot: path.join(storeRoot, 'iPad-Honest-Final'),
  newRoot: path.join(storeRoot, 'iPad-Honest-Final-v2'),
  width: 2064,
  height: 2752,
  label: 'iPad'
});

for (const size of [16, 48, 128, 1024]) {
  const file = path.join(repo, 'AutoRefreshXLExtension', 'Resources', 'icons', `icon${size}.png`);
  const metadata = await sharp(file).metadata();
  if (metadata.width !== size || metadata.height !== size || metadata.hasAlpha) {
    throw new Error(`Invalid icon${size}.png metadata: ${JSON.stringify(metadata)}`);
  }
}

console.log(`Verified ${phoneCount} iPhone screenshots, ${ipadCount} iPad screenshots, and 4 icon assets.`);
