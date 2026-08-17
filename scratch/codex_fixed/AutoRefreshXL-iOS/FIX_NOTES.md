# Auto Refresh XL iOS alert fix

Version 1.1.1 fixes the keyword-match alert path.

## Changes

- Wait for Safari native messaging to return a real success or error response.
- Keep the native extension request alive until the local notification is scheduled.
- Use the standard iOS notification sound instead of the entitlement-restricted critical sound.
- Preserve the separate Play Sound and Notify settings when starting a monitor.
- Report native notification failures in the extension activity log.
- Keep in-page audio as a best-effort alert while using the native iOS alert path for reliability.

## Device test

1. Build and install the IPA using either included GitHub Actions workflow.
2. Open the containing app once and allow notifications.
3. Confirm notifications and sounds are enabled in iOS Settings for Auto Refresh XL.
4. In Safari, enable the extension for the test website.
5. Open the extension's Logs tab and press **Test Push Alert**.
6. Start a monitor for a keyword and confirm the banner, sound, and activity-log success entry.

Normal notification sounds still respect the iPhone's Silent Mode and Focus settings. Critical
alerts would require a separate entitlement issued by Apple and are intentionally not used here.
