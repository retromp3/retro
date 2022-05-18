Retro Music Player (Reboot)
==

## About

Retro aims to bring back the iPod Classic experience to iOS and Android. I originally started working on it nearly 2 years ago and released it as a [TestFlight beta](https://beta.retromusic.co) (because Apple wouldn't allow it on the App Store) and have been maintaining it myself since.

Unfortunately Retro in its current state is too hard to maintain––mainly due to poor choices I made 2 years ago that hinders the app today. It's far too difficult to add new stuff to it without breaking other parts of the app, not to mention the number of existing issues that have gone unfixed for so long.

That said, I've decided to start over from scratch, rely on fewer dependencies, and (hopefully) write cleaner + better code 😅. I've had a handful of requests from people asking how they can help before and I've always wanted to eventually open-source the app, but I believe now is the right time.

## Stack

* Flutter/Dart
* API: [Spotify SDK](https://github.com/brim-borium/spotify_sdk), [MusicKit](https://github.com/iberatkaya/playify)

## Setup

1. [Download and install Flutter](https://docs.flutter.dev/get-started/install)
2. Clone this repository
3. ```cd retro```
4. ```flutter pub get && flutter run```
5. That's it! 

_Note: If you want to develop on this, you're going to need an Apple Developer Account_

## Contributing

Firstly, I appreciate you for taking the time to contribute 😁

If you're fixing a bug, feel free to just submit a PR and specify what it is that you're fixing! If there's something that you believe should be changed, open an issue here or discuss it on the [Discord](https://discord.retromusic.co) before actually making said change.
