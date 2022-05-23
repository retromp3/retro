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

## Setup

1. [Download and install Flutter](https://docs.flutter.dev/get-started/install)
2. Clone this repository
3. ```cd retro```
4. ```flutter pub get && flutter run```
5. That's it! 

_Note: If you want to develop on this, you're going to need a mac as well as an Apple Developer Account (paid or free)_

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
| Menu Layout | ✅ | ✅ |
| Music Player functions | 🚧 | 🚧 |
| Migrate to Android embedding v2 | N/A | ✅ |
| Migrate to Flutter 3 | ✅ | ✅ |
| Splash screen | 🚧 | 🚧 |
| Dynamic Menu Sizes | 🚧 | 🚧 |
| Responsive to all screens | 🚧 | 🚧 |
