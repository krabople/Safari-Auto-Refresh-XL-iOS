# GitHub Secrets for TestFlight

Configure these repository secrets under **Settings → Secrets and variables → Actions**:

- `BUILD_CERTIFICATE_BASE64`: Base64-encoded Apple Distribution `.p12` containing its private key.
- `P12_PASSWORD`: Password used when exporting that `.p12`.
- `APPSTORE_ISSUER_ID`: App Store Connect API issuer ID.
- `APPSTORE_KEY_ID`: App Store Connect API key ID.
- `APPSTORE_PRIVATE_KEY`: Complete contents of the associated `.p8` private key.

Never commit certificates, provisioning profiles, private keys, passwords, or generated IPA files. The release workflow uses the App Store Connect API key to manage provisioning and upload the exported archive.

Run **Build and upload iOS app to TestFlight** manually from the repository's Actions page when a release is ready.
