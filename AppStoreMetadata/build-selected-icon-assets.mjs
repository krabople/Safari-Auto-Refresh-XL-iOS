import { createRequire } from 'node:module';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const repo = path.resolve(import.meta.dirname, '..');
const source = path.join(repo, 'AppStoreMetadata', 'Icon-Concepts', 'selected-alert-orbit-source.png');
const iconDirectory = path.join(repo, 'AutoRefreshXLExtension', 'Resources', 'icons');
const sizes = [16, 48, 128, 1024];

await fs.access(source);
await fs.mkdir(iconDirectory, { recursive: true });

for (const size of sizes) {
  await sharp(source)
    .resize(size, size, { fit: 'cover', kernel: sharp.kernel.lanczos3 })
    .flatten({ background: '#071333' })
    .removeAlpha()
    .png({ compressionLevel: 9, palette: false })
    .toFile(path.join(iconDirectory, `icon${size}.png`));
}

console.log(`Built ${sizes.length} opaque icon assets from ${source}`);
