import { createRequire } from 'node:module';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const storeRoot = 'C:/Users/krabo/OneDrive/Documents/App dev stuff/Auto Refresh XL App Store Stuff';
const roots = [
  path.join(storeRoot, 'Localized-Final-v4'),
  path.join(storeRoot, 'iPad-Honest-Final-v2')
];

let converted = 0;
for (const root of roots) {
  for (const localeEntry of await fs.readdir(root, { withFileTypes: true })) {
    if (!localeEntry.isDirectory()) continue;
    const localeDirectory = path.join(root, localeEntry.name);
    for (const name of await fs.readdir(localeDirectory)) {
      if (!/^0[1-5]-.*\.png$/i.test(name)) continue;
      const source = path.join(localeDirectory, name);
      const temporary = `${source}.opaque.png`;
      await sharp(source)
        .flatten({ background: '#ffffff' })
        .removeAlpha()
        .png({ compressionLevel: 9, palette: false })
        .toFile(temporary);
      await fs.rename(temporary, source);
      converted += 1;
    }
  }
}

console.log(`Normalised ${converted} screenshots to opaque RGB PNG files.`);
