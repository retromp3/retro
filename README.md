![hero](https://i.imgur.com/GFJhfkk.png)

## About

[![Discord](https://badgen.net/discord/members/6v9TEhn)](https://discord.retromusic.co/)
[![Twitter](https://badgen.net/twitter/follow/retro_mp3)](https://twitter.com/retro_mp3)


Retro aims to bring back the iPod Classic experience to iOS and Android. I originally started working on it nearly 2 years ago and released it as a [TestFlight beta](https://beta.retromusic.co) (because Apple wouldn't allow it on the App Store) and have been maintaining it myself since.

Unfortunately Retro in its current state is too hard to maintain due to poor choices I made 2 years ago that hinders the app today. It's far too difficult to add new stuff to it without breaking other parts of the app, not to mention the number of existing issues that have gone unfixed for so long.

That said, I've decided that it would be best to restart from scratch, rely on fewer dependencies, and (hopefully) write cleaner + better code in the process 😅. I've had a handful of requests from people in the past asking how they can help and I've always wanted to eventually open-source the app, but I believe now is the right time.

This version of Retro will eventually succeed the current [build that's available on TestFlight](https://beta.retromusic.co).

## Stack

* Flutter/Dart
* API: [Spotify SDK](https://github.com/brim-borium/spotify_sdk), [MusicKit](https://github.com/iberatkaya/playify)

# Setup

Long story short, we can't distribute the app as an IPA because the Spotify functionality won't work.

The workaround for this is to compile the app yourself and insert your own Spotify API key and Redirect URIs in the .env file.

### Instructions

1. Download and install Flutter. You can find instructions on how to do this [here](https://flutter.dev/docs/get-started/install).
2. Ensure you have an Apple Developer account (paid or free). You can find instructions on how to do this [here](https://developer.apple.com/programs/enroll/).
3. Clone this repository.
4. `cd retro`
5. Open the ios folder in Xcode and select your Apple Developer account for signing.
6. Create a Spotify app [here](https://developer.spotify.com/dashboard/applications) and insert the Client ID and Redirect URIs in the .env.example file. Make sure to rename it to .env.
7. Head back to the terminal and run `flutter pub get && flutter run`.
8. That should be it! The app should run fine on your iOS device.

## Contributing

Firstly, I appreciate you for taking the time to contribute 😁

If you're fixing a bug, feel free to just submit a PR and specify what it is that you're fixing! If there's something that you believe should be changed, open an issue here or discuss it on the [Discord](https://discord.retromusic.co) before actually making said change.

Other than that, I don't really have any specific requirements.

### TODO
This is a list of all the things that are left to complete (there's likely more that I can't think of atm). Feel free to add onto it.

| Description  | iOS | Android |
|---|---|---|
| Apple Music implementation | 🚧 | N/A |
| Spotify implementation | 🚧 | 🚧 |
| Play Music from files | 🚧 | 🚧 |
| Skins (Background) | ✅ | ✅ |
| Skins (Wheel) | 🚧 | 🚧 |
| iPod Animations | 🚧 | 🚧 |
| Games | 🚧 | 🚧 |
| iPod Themes | 🚧 | 🚧 |
| Configurable app icons | 🚧 | 🚧 |
| Clickwheel feedback | ✅ | ✅ |
| Exponential scrolling | ✅ | ✅ |
| Menu Layout | ✅ | ✅ |
| Music Player functions | 🚧 | 🚧 |
| Migrate to Android embedding v2 | N/A | ✅ |
| Migrate to Flutter 3 | ✅ | ✅ |
| Splash screen | 🚧 | 🚧 |
| Dynamic Menu Sizes | 🚧 | 🚧 |
| Responsive to all screens | 🚧 | 🚧 |
