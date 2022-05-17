Retro Music Player
==

## About

Retro aims to bring back the iPod Classic (1-1) experience to iOS and Android. I originally started working on it nearly 2 years ago and released it as a [TestFlight beta](https://beta.retromusic.co) and have been maintaining it myself since.

Retro in its current state is too hard to maintain––mainly due to poor choices I made 2 years ago that hinders the app today. It's far too difficult to add new stuff to it without breaking other parts of the app, not to mention the number of existing issues that have gone unfixed for so long.

That said, I've decided to start over from scratch, rely on fewer dependencies, and (hopefully) write cleaner + better code 😅. I also figured that open-sourcing it would be a better way to go about this as I've had a lot of requests for it before.

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

If you're fixing a bug, feel free to just submit a PR and specify what it is that you're fixing!
