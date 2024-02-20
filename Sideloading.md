## Sideloading
Retro does support sideloading, but requires further setup. \
If properly compiled, the onboarding assistent will ask for a client ID. To obtain one, register at spotify developer (developer.spotify.com/dashboard) and create a new app. Name it what you want, add any description and type 'comspotify://co.retromusic' as redirect url.
Accept the terms and enable iOS and android support. \
If you're on iOS make sure to enter the bundle ID you used to sideload your app under iOS app bundles, if you're on android add a package named 'co.retromusic.app2' as well as the following SHA1 key: [tba].\
Finally enter the client id obtained from spotify into the onboarding assistent. Make sure to avoid typos, as there's currently no way to change the client id afterwards without a full reinstall. Retro should work now (if it doesn't, try restarting the app).

## Technical Information
To compile a retro build with sideloading support, the cliend ID in '.env' has to be 'invalid'. Else the onboarding assistent won't ask for one. Also, the redirect url should be "comspotify://co.retromusic".
