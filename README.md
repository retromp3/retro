![hero](https://i.imgur.com/GFJhfkk.png)

## About

[![Discord](https://badgen.net/discord/members/6v9TEhn)](https://discord.retromusic.co/)
[![Twitter](https://badgen.net/twitter/follow/retro_mp3)](https://twitter.com/retro_mp3)


Retro aims to bring back the iPod Classic experience to iOS and Android. I originally started working on it nearly 2 years ago and released it as a [TestFlight beta](https://beta.retromusic.co) (because Apple wouldn't allow it on the App Store) and have been maintaining it myself since. I've since open sourced it because I can't work on this as actively as I'd like, but I'm doing the best that I can :)

## Stack

* Flutter/Dart for main app
* Swift/SwiftUI for WatchOS companion app (Retro Shuffle)
* API: [Spotify SDK](https://github.com/brim-borium/spotify_sdk), [MusicKit](https://github.com/iberatkaya/playify)

# Setup

If you'd like to run the app on your own device you can [sideload](Sideloading.md) it or compile everything from source, you can do so by following the instructions below.

## Instructions

* Download and install Flutter. You can find instructions on how to do this [here](https://flutter.dev/docs/get-started/install).

**Note**: Retro has not been migrated to Dart 3 yet, so to run the app you'll have to use Flutter v3.7.12.

### IOS Setup
1. Ensure you have an Apple Developer account (paid or free). You can find instructions on how to do this [here](https://developer.apple.com/programs/enroll/).
2. Clone this repository.
3. `cd retro`
4. Open the ios folder in Xcode and select your Apple Developer account for signing. You may have to change the bundle id.
5. Create a Spotify app [here](https://developer.spotify.com/dashboard/applications) and insert the Client ID and Redirect URIs in the .env.example file. Make sure to rename it to .env. The Redirect URI in your Spotify dashboard can be pretty much anything i.e. comspotify://co.retromusic. Ensure that the bundle id in Xcode matches the one under iOS app bundles in the Spotify Dashboard
6. Head back to the terminal and run `flutter pub get && flutter run`.
7. That should be it! The app should run fine on your iOS device.

### Android Setup
1. Clone this repository.
2. `cd retro`
3. Create a Spotify app [here](https://developer.spotify.com/dashboard/applications) and insert the Client ID and Redirect URIs in the .env.example file. Make sure to rename it to .env. The Redirect URI in your Spotify dashboard can be pretty much anything i.e. comspotify://co.retromusic.
4. `cd android` and generate an SHA1 Fingerprint with `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android` in your Terminal
5. Under 'Android packages' in your Spotify dashboard, add the corresponding package/applicationID to it and paste the SHA1 fingerprint that was generated from the previous step. The android package name can be found in the `AndroidMainfest.xml` files in the `android/app/src (debug, main, profile)` directories. Ideally change the package name to something unique.
6. Head back to the terminal and run `flutter pub get && flutter run`.
7. That should be it! The app should run fine on your Android device in debug mode.

## Contributing

Firstly, I appreciate you for taking the time to contribute 😁

If you're fixing a bug, feel free to just submit a PR and specify what it is that you're fixing! If there's something that you believe should be changed, open an issue here or discuss it on the [Discord](https://discord.retromusic.co) before actually making said change.

Other than that, I don't really have any specific requirements.
