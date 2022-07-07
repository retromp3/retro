import Foundation
import MediaPlayer

typealias StateUpdateDelegate = (MPMusicPlayerController) -> Void

@available(iOS 10.3, *)
public class PlayifyPlayer {
    ///The music player controller instance.
    var player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    var stateUpdateDelegate: StateUpdateDelegate?

    ///Set the queue with unique song ids.
    func setQueue(songIDs: [String], startPlaying: Bool?, startID: String?) throws {
        if let startID = startID {
            if !songIDs.contains(startID) {
                throw PlayifyError.runtimeError("songIDs does not contain startID!")
            }
        }
        let songs = getMediaItemsWithIDs(songIDs: songIDs)
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        
        //If a startID is given, find and set the song as the start item.
        if let startID = startID {
            if let startItem = getMediaItemsWithIDs(songIDs: [startID]).first {
                descriptor.startItem = startItem
            }
        }
        
        player.setQueue(with: descriptor)
        
        if let startPlaying = startPlaying {
            if(startPlaying){
                player.prepareToPlay(completionHandler: {error in
                    if error == nil {
                        self.play()
                    }
                })
            }
            else {
                player.prepareToPlay()
            }
        }
    }
    
    ///Get MediaItems via a PersistentID using predicates and queries.
    private func getMediaItemsWithIDs(songIDs: [String]) -> [MPMediaItem] {
        var songs: [MPMediaItem] = []
        for songID in songIDs {
            let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
            let query = MPMediaQuery(filterPredicates: Set([songFilter]))
            if let items = query.items, let first = items.first {
                songs.append(first)
            }
        }
        return songs
    }
    
    ///Skip to the beginning of the queue.
    func skipToBeginning(){
        player.skipToBeginning()
    }
    
    ///Prepend songs to the current queue.
    func prepend(songIDs: [String]){
        let songs = getMediaItemsWithIDs(songIDs: songIDs)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        player.prepend(descriptor)
    }
    
    ///Append songs to the current queue.
    func append(songIDs: [String]){
        let songs = getMediaItemsWithIDs(songIDs: songIDs)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        player.append(descriptor)
    }
    
    
    ///Start seeking forward.
    func seekForward(){
        player.beginSeekingForward()
    }
    
    ///Start seeking backwards.
    func seekBackward(){
        player.beginSeekingBackward()
    }
    
    ///Stop seeking.
    func endSeeking(){
        player.endSeeking()
    }
    
    ///Get the current time of the song.
    func getPlaybackTime() -> Float{
        return Float(player.currentPlaybackTime)
    }
    
    ///Set the current time of the song.
    func setPlaybackTime(time: Float){
        player.currentPlaybackTime = TimeInterval(time)
    }
    
    ///Set a shuffle mode.
    func setShuffleMode(mode: String){
        if(mode == "off"){
            player.shuffleMode =  MPMusicShuffleMode.off
        }
        else if(mode == "songs"){
            player.shuffleMode =  MPMusicShuffleMode.songs
        }
    }
    
    ///Get the shuffle mode.
    func getShuffleMode() -> String? {
        if(player.shuffleMode == MPMusicShuffleMode.off){
            return "off"
        }
        else if(player.shuffleMode == MPMusicShuffleMode.songs){
            return "songs"
        }
        return nil
    }
    
    ///Set a repeat mode.
    func setRepeatMode(mode: String){
        if(mode == "none"){
            player.repeatMode =  MPMusicRepeatMode.none
        }
        else if(mode == "one"){
            player.repeatMode =  MPMusicRepeatMode.one
        }
        else if(mode == "all"){
            player.repeatMode = MPMusicRepeatMode.all
        }
    }
    
    ///Get the repeat mode.
    func getRepeatMode() -> String? {
        if(player.repeatMode == MPMusicRepeatMode.none){
            return "none"
        }
        else if(player.repeatMode ==  MPMusicRepeatMode.one){
            return "one"
        }
        else if(player.repeatMode == MPMusicRepeatMode.all){
            return "all"
        }
        return nil
    }
    
    ///Play a song with an ID.
    func playItem(songID: String){
        let song = getMediaItemsWithIDs(songIDs: [songID])
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: song))
        
        player.setQueue(with: descriptor)
        player.prepareToPlay(completionHandler: {error in
            if error == nil {
                self.player.play()
            }
        })
    }
    
    //Get songs by genre.
    func getSongsByGenre(genre: String) -> [MPMediaItem] {
        let genrePredicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        let query = MPMediaQuery(filterPredicates: Set([genrePredicate]))
        return query.items ?? []
    }
    
    //Get all genres.
    func getAllGenres() -> Set<String> {
        let query = MPMediaQuery.genres()
        var genres: Set<String> = []
        guard let collections = query.collections else {
            return []
        }
        for genre in collections {
            if !genre.items.isEmpty {
                if let genre = genre.items[0].genre {
                    genres.insert(genre)
                }
            }
        }
        return genres
    }
    
    ///Play the current queue.
    func play(){
        player.play()
    }
    
    ///Pause the current playing song.
    func pause(){
        player.pause()
    }
    
    ///Skip to the next song in the queue.
    func next(){
        player.skipToNextItem()
    }
    
    ///Skip to the previous song in the queue.
    func previous(){
        player.skipToPreviousItem()
    }
    
    ///Get info about the current playing song.
    func nowPlaying() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    ///Retrieve all songs in the library.
    func getAllSongs() -> [MPMediaItem] {
        let songsQuery = MPMediaQuery.songs()
        let songs = songsQuery.items ?? []
        return songs
    }
    
    ///Check if the player is in the playing state.
    func isPlaying() -> Bool {
        return player.playbackState == MPMusicPlaybackState.playing
    }
    
    ///Get all the playlists.
    func getPlaylists() -> [MPMediaItemCollection]? {
        let query = MPMediaQuery.playlists()
        if let playlists = query.collections {
            return playlists
        }
        return nil
    }
    
    ///Set the volume to a value.
    func setVolume(volume: Float){
        MPVolumeView.setVolume(volume)
    }
    
    ///Get the device's current output volume.
    func getVolume(completionHandler: @escaping (Float) -> Void) {
        MPVolumeView.getVolume(completionHandler: completionHandler)
    }
    
    ///Increment the volume by an amount. The volume can be incremented with negative number in order to decrease it..
    func incrementVolume(amount: Float){
        getVolume(completionHandler: {volume in
            guard volume + amount > 0 else {
                MPVolumeView.setVolume(0)
                return
            }
            guard volume + amount < 1 else {
                MPVolumeView.setVolume(1)
                return
            }
            
            MPVolumeView.setVolume(volume + amount)
        })
    }
    public func startNotifications() {
        player.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self,
            selector: #selector(stateChanged),
            name: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: player)
        NotificationCenter.default.addObserver(self,
            selector: #selector(stateChanged),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player)
    }

    public func stopNotifications() {
        player.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self,
            name: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: player)
        NotificationCenter.default.removeObserver(self,
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player)
    }

    @objc private func stateChanged(notification: NSNotification) {
        stateUpdateDelegate?(player)
    }
}
