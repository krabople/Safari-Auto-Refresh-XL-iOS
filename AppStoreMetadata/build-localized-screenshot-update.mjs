import { createRequire } from 'node:module';
import { pathToFileURL } from 'node:url';
import fs from 'node:fs/promises';
import path from 'node:path';

const require = createRequire(import.meta.url);
const { chromium } = require('playwright');
const sharp = require('sharp');

const repo = path.resolve(import.meta.dirname, '..');
const storeRoot = 'C:/Users/krabo/OneDrive/Documents/App dev stuff/Auto Refresh XL App Store Stuff';
const resources = path.join(repo, 'AutoRefreshXLExtension', 'Resources');
const popupUrl = pathToFileURL(path.join(resources, 'popup.html')).href;
const chromePath = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const locales = ['en-GB','en-US','de-DE','fr-FR','es-ES','it-IT','pt-BR','nl-NL','ja-JP','ko-KR','zh-Hans','zh-Hant'];
const terms = { de: 'auf Lager', fr: 'en stock', es: 'en stock', it: 'disponibile', pt: 'em estoque', nl: 'op voorraad', ja: '在庫あり', ko: '재고 있음', 'zh-CN': '有货', 'zh-TW': '有貨' };

const oldPhoneRoot = path.join(storeRoot, 'Localized-Final');
const newPhoneRoot = path.join(storeRoot, 'Localized-Final-v4');
const oldPadRoot = path.join(storeRoot, 'iPad-Honest-Final');
const newPadRoot = path.join(storeRoot, 'iPad-Honest-Final-v2');
const phoneBase = path.join(storeRoot, 'UK-AppStore-1242x2688', '01-Auto-Refresh-XL-UK.png');

function titleOverlay() {
  return Buffer.from(`<svg width="1242" height="2688" xmlns="http://www.w3.org/2000/svg">
    <rect x="48" y="248" width="990" height="105" fill="#0a0f1b"/>
    <text x="52" y="315" fill="white" font-family="Arial, sans-serif" font-size="47" font-weight="700">Auto Refresh XL</text>
  </svg>`);
}

function ipadBackdrop(popupX, popupY, popupWidth, popupHeight) {
  return Buffer.from(`<svg width="2064" height="2752" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <linearGradient id="background" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#090f1c"/><stop offset="1" stop-color="#122237"/></linearGradient>
      <filter id="blur"><feGaussianBlur stdDeviation="26"/></filter>
      <radialGradient id="glow"><stop stop-color="#00f2fe" stop-opacity="0.13"/><stop offset="1" stop-color="#00f2fe" stop-opacity="0"/></radialGradient>
    </defs>
    <rect width="2064" height="2752" fill="url(#background)"/>
    <ellipse cx="1030" cy="1210" rx="820" ry="820" fill="url(#glow)"/>
    <rect x="${popupX - 18}" y="${popupY - 18}" width="${popupWidth + 36}" height="${popupHeight + 36}" rx="24" fill="#000" opacity="0.5" filter="url(#blur)"/>
  </svg>`);
}

async function preparePopupPage(context) {
  await context.route('**/popup.js', route => route.abort());
  const page = await context.newPage();
  await page.goto(popupUrl, { waitUntil: 'load' });
  await page.waitForTimeout(80);
  await page.evaluate(exampleTerms => {
    document.querySelector('#countdownDisplay').textContent = '00:00';
    document.querySelector('#statusText').textContent = window.ARXL_I18N.t('INACTIVE');
    document.querySelector('#startStopText').textContent = window.ARXL_I18N.t('START REFRESH');
    document.querySelectorAll('.chip').forEach(chip => chip.classList.toggle('active', chip.dataset.seconds === '5'));
    document.querySelector('#inputSeconds').value = '5';
    document.querySelector('#toggleOverlay').checked = true;
    document.querySelector('#toggleMonitor').checked = true;
    document.querySelector('#targetText').value = exampleTerms[window.ARXL_I18N.language] || 'in stock';
  }, terms);
  return page;
}

async function copyUnchangedScreenshots(oldRoot, newRoot, locale, kind) {
  const existingFiles = await fs.readdir(path.join(oldRoot, locale));
  for (let number = 2; number <= 5; number += 1) {
    const prefix = String(number).padStart(2, '0');
    const oldName = existingFiles.find(name => name.startsWith(`${prefix}-`) && name.toLowerCase().endsWith('.png'));
    if (!oldName) throw new Error(`Missing existing ${kind} screenshot ${prefix} for ${locale}`);
    const newName = kind === 'phone'
      ? `${prefix}-Auto-Refresh-XL-${locale}-v4.png`
      : `${prefix}-Auto-Refresh-XL-${locale}-iPad-v2.png`;
    await sharp(path.join(oldRoot, locale, oldName))
      .flatten({ background: '#ffffff' })
      .removeAlpha()
      .png({ compressionLevel: 9, palette: false })
      .toFile(path.join(newRoot, locale, newName));
  }
}

const browser = await chromium.launch({ headless: true, executablePath: chromePath });
try {
  for (const locale of locales) {
    const phoneOut = path.join(newPhoneRoot, locale);
    const padOut = path.join(newPadRoot, locale);
    await fs.mkdir(phoneOut, { recursive: true });
    await fs.mkdir(padOut, { recursive: true });
    const completedPhone = (await fs.readdir(phoneOut)).filter(name => name.endsWith('.png')).length >= 5;
    const completedPad = (await fs.readdir(padOut)).filter(name => name.endsWith('.png')).length >= 5;
    if (completedPhone && completedPad) {
      console.log(`Already rendered ${locale}`);
      continue;
    }

    const phoneContext = await browser.newContext({ viewport: { width: 414, height: 759 }, deviceScaleFactor: 3, locale });
    const phonePage = await preparePopupPage(phoneContext);
    const phonePopup = await phonePage.screenshot();
    await phoneContext.close();

    await sharp(phoneBase)
      .composite([
        { input: phonePopup, left: 0, top: 411 },
        { input: titleOverlay(), left: 0, top: 0 }
      ])
      .removeAlpha()
      .png({ compressionLevel: 9 })
      .toFile(path.join(phoneOut, `01-Auto-Refresh-XL-${locale}-v4.png`));
    await copyUnchangedScreenshots(oldPhoneRoot, newPhoneRoot, locale, 'phone');

    const padContext = await browser.newContext({ viewport: { width: 520, height: 720 }, deviceScaleFactor: 2, locale });
    const padPage = await preparePopupPage(padContext);
    const padPopup = await padPage.locator('.app-container').screenshot();
    await padContext.close();

    const popupWidth = 1420;
    const metadata = await sharp(padPopup).metadata();
    const popupHeight = Math.round(metadata.height * popupWidth / metadata.width);
    const popupX = Math.round((2064 - popupWidth) / 2);
    const popupY = Math.round((2752 - popupHeight) / 2);
    const resizedPopup = await sharp(padPopup).resize({ width: popupWidth }).png().toBuffer();
    await sharp(ipadBackdrop(popupX, popupY, popupWidth, popupHeight))
      .composite([{ input: resizedPopup, left: popupX, top: popupY }])
      .removeAlpha()
      .png({ compressionLevel: 9 })
      .toFile(path.join(padOut, `01-Auto-Refresh-XL-${locale}-iPad-v2.png`));
    await copyUnchangedScreenshots(oldPadRoot, newPadRoot, locale, 'pad');

    console.log(`Rendered ${locale}`);
  }
} finally {
  await browser.close();
}

console.log(`iPhone screenshots: ${newPhoneRoot}`);
console.log(`iPad screenshots: ${newPadRoot}`);
