import { createRequire } from 'node:module';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const storeRoot = 'C:/Users/krabo/OneDrive/Documents/App dev stuff/Auto Refresh XL App Store Stuff';
const previewRoot = path.join(storeRoot, 'Localization-v4-Previews');
const locales = ['en-GB','en-US','de-DE','fr-FR','es-ES','it-IT','pt-BR','nl-NL','ja-JP','ko-KR','zh-Hans','zh-Hant'];

function escapeXml(value) {
  return value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
}

async function findShot(root, locale, suffix) {
  const names = await fs.readdir(path.join(root, locale));
  const name = names.find(item => item.startsWith('01-') && item.endsWith(suffix));
  if (!name) throw new Error(`Screenshot 01 not found for ${locale}`);
  return path.join(root, locale, name);
}

async function makeSheet({ root, suffix, output, thumbWidth, thumbHeight, title }) {
  const columns = 4;
  const rows = 3;
  const gap = 22;
  const labelHeight = 44;
  const margin = 36;
  const titleHeight = 86;
  const width = (margin * 2) + (columns * thumbWidth) + ((columns - 1) * gap);
  const height = titleHeight + margin + (rows * (labelHeight + thumbHeight)) + ((rows - 1) * gap) + margin;
  const composites = [];

  for (let index = 0; index < locales.length; index += 1) {
    const locale = locales[index];
    const x = margin + (index % columns) * (thumbWidth + gap);
    const y = titleHeight + margin + Math.floor(index / columns) * (labelHeight + thumbHeight + gap);
    const screenshot = await findShot(root, locale, suffix);
    const input = await sharp(screenshot).resize(thumbWidth, thumbHeight, { fit: 'fill' }).png().toBuffer();
    const label = Buffer.from(`<svg width="${thumbWidth}" height="${labelHeight}" xmlns="http://www.w3.org/2000/svg"><rect width="100%" height="100%" fill="#111827"/><text x="12" y="29" fill="#f8fafc" font-family="Arial, sans-serif" font-size="22" font-weight="700">${escapeXml(locale)}</text></svg>`);
    composites.push({ input: label, left: x, top: y });
    composites.push({ input, left: x, top: y + labelHeight });
  }

  const heading = Buffer.from(`<svg width="${width}" height="${titleHeight}" xmlns="http://www.w3.org/2000/svg"><rect width="100%" height="100%" fill="#0b1220"/><text x="${margin}" y="55" fill="white" font-family="Arial, sans-serif" font-size="34" font-weight="700">${escapeXml(title)}</text></svg>`);
  composites.unshift({ input: heading, left: 0, top: 0 });
  await sharp({ create: { width, height, channels: 3, background: '#070b13' } })
    .composite(composites)
    .jpeg({ quality: 92, chromaSubsampling: '4:4:4' })
    .toFile(output);
}

await fs.mkdir(previewRoot, { recursive: true });
await makeSheet({
  root: path.join(storeRoot, 'Localized-Final-v4'),
  suffix: '-v4.png',
  output: path.join(previewRoot, 'iPhone-interval-localisations-v4.jpg'),
  thumbWidth: 248,
  thumbHeight: 536,
  title: 'Updated iPhone screenshot 1 — all localisations'
});
await makeSheet({
  root: path.join(storeRoot, 'iPad-Honest-Final-v2'),
  suffix: '-iPad-v2.png',
  output: path.join(previewRoot, 'iPad-interval-localisations-v2.jpg'),
  thumbWidth: 310,
  thumbHeight: 413,
  title: 'Updated iPad screenshot 1 — all localisations'
});

console.log(previewRoot);
