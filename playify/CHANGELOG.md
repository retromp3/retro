## 2.0.1

- Added getting all genres and songs by genres.

## 2.0.0

- Migrated to null safety.

## 1.6.0

- Added getting and setting volume.
- Added getting and setting shuffle and repeat modes.

## 1.5.0+1

- Updated README.

## 1.5.0

- Added prepend, append, skipToBeginning, and getPlaylists.

Breaking Changes:

- Renamed `SongInfo` to `SongInformation`.
- Functions now throw `PlatformExceptions`.
- Several functions do not return boolean values anymore.

## 1.4.0+2

- Updated README.

## 1.4.0+1

- Fixed changelog errors.

## 1.4.0

- Breaking Changes:
- Changed setting the queue to only start from the first song in the setQueue function.

## 1.3.1+1

- Fixed previous issue with album covers in Dart.

## 1.3.1

- Fixed previous pull request so album covers of albums with multiple artists are fetched.

## 1.3.0

- Fixed issue where some albums covers did not appear when the artist name was different even though the album was the same.

## 1.2.0+1

- Updated README to better explain the plugin. No functionality changes were made.

## 1.2.0

- Breaking Changes:
- Setting the queue no longer autoplays as a default value.
- Added a function to play a single song.

## 1.1.1+1

- Changed Release Year to DateTime.

## 1.1.1

- Added Release Year and Genre for each song.

## 1.1.0+1

- Fixed an issue where the album covers would not be resized.

## 1.1.0

- Breaking Changes:
- The cover art now returns as binary data (List<int>). This is done in order to give more control over the cover art to the user.

## 1.0.0+2

- Added isPlaying() to check if a song is currently playing.

## 1.0.0+1

- Added returning null if no song was playing.

## 1.0.0

- Stable release.

## 0.0.3

- Added shuffle and repeat.
- Added setting and getting playback time.
- Added seeking forward and backward.

## 0.0.2

- Minor code formatting changes
- Added return values for non-iOS devices

## 0.0.1

- Initial release.
- Currently only iOS supported.
