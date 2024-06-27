# Sideloading

Retro supports sideloading, but it requires additional setup. Follow the steps below to sideload Retro on your iOS device.

## Prerequisites

1. Download and install [AltStore](https://faq.altstore.io/) on your iOS device. Follow the instructions provided in the link for installation.

## Steps

1. **Download the Retro IPA:**
   - Get the latest Retro IPA file from the [releases page](https://github.com/retromp3/retro/releases).

2. **Install Retro IPA using AltStore:**
   - Open AltStore on your iOS device.
   - Tap the `+` icon in the top left corner.
   - Select the Retro IPA file you downloaded.

3. **Configure Spotify Client ID:**
   - Register at the Spotify Developer Dashboard [here](https://developer.spotify.com/dashboard/applications) and create a new app.
   - Name the app and add any description.
   - Set the Redirect URI to `comspotify://co.retromusic`.
   - Enable iOS support and enter the bundle ID you used to sideload your app under iOS app bundles.
   - Obtain the Client ID from the Spotify Developer Dashboard.

4. **Enter Client ID in Retro:**
   - Open Retro on your iOS device.
   - During the onboarding process, you will be prompted to enter the Spotify Client ID.
   - Enter the Client ID carefully to avoid typos.

## Technical Information

To compile a Retro build with sideloading support, the Client ID in `.env` has to be `invalid`. Else, the onboarding assistant won't ask for one. Also, the Redirect URI should be `comspotify://co.retromusic`.