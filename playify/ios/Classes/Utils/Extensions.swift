import MediaPlayer

@available(iOS 10.0, *)
extension MPMediaItem {
    ///Returns a dicationary without the image data set.
    func toDict() -> [String: Any] {
        return [
            "artist": artist ?? "",
            "songTitle": title ?? "",
            "albumTitle": albumTitle ?? "",
            "trackNumber": albumTrackNumber,
            "albumTrackNumber": albumTrackNumber,
            "albumTrackCount": albumTrackCount,
            "genre": genre ?? "",
            "releaseDate": Int64((releaseDate?.timeIntervalSince1970 ?? 0) * 1000),
            "playCount": playCount,
            "discCount": discCount,
            "discNumber": discNumber,
            "isExplicitItem": isExplicitItem,
            "songID": persistentID,
            "playbackDuration": playbackDuration
        ]
    }
}

///Update system volume
///Taken from https://stackoverflow.com/a/57449875.
///@author: https://stackoverflow.com/users/1371853/swiftboy
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView(frame: .zero)
        
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
    static func getVolume(completionHandler: @escaping (Float) -> Void) {
        
        let volumeView = MPVolumeView(frame: .zero)
        
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            completionHandler(slider?.value ?? 0)
        }
    }
}
