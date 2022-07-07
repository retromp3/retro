import Flutter
import UIKit
import MediaPlayer

public class SwiftPlayifyPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    override init() {
        super.init()
        player.stateUpdateDelegate = updateHandler
    }
    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.kaya.playify/playify", binaryMessenger: registrar.messenger())
        let streamChannel = FlutterEventChannel(
            name: "com.kaya.playify/playify_status",
            binaryMessenger: registrar.messenger())
        let instance = SwiftPlayifyPlugin()
        streamChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @available(iOS 10.3, *)
    private lazy var player = PlayifyPlayer()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 10.3, *) {
            if(call.method == "play"){
                player.play()
                result(nil)
            }
            else if(call.method == "playItem"){
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songID = args["songID"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songID was not provided!"))
                    return
                }
                player.playItem(songID: songID)
                result(nil)
            }
            else if(call.method == "pause") {
                player.pause()
                result(nil)
            }
            else if(call.method == "next") {
                player.next()
                result(nil)
            }
            else if(call.method == "previous") {
                player.previous()
                result(nil)
            }
            else if(call.method == "seekForward") {
                player.seekForward()
                result(nil)
            }
            else if(call.method == "seekBackward") {
                player.seekBackward()
                result(nil)
            }
            else if(call.method == "endSeeking") {
                player.endSeeking()
                result(nil)
            }
            else if(call.method == "isPlaying"){
                let isplaying = player.isPlaying()
                result(Bool(isplaying))
            }
            else if(call.method == "setShuffleMode") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let mode = args["mode"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter mode was not provided!"))
                    return
                }
                player.setShuffleMode(mode: mode)
                result(nil)
            }
            else if(call.method == "setRepeatMode") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let mode = args["mode"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter mode was not provided!"))
                    return
                }
                player.setRepeatMode(mode: mode)
                result(nil)
            }
            else if(call.method == "getPlaybackTime") {
                let time = player.getPlaybackTime()
                result(Float(time))
            }
            else if(call.method == "skipToBeginning") {
                player.skipToBeginning()
                result(nil)
            }
            else if(call.method == "prepend") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                player.prepend(songIDs: songIDs)
                result(nil)
            }
            else if(call.method == "append") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                player.append(songIDs: songIDs)
                result(nil)
            }
            else if(call.method == "setPlaybackTime") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let time = args["time"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter time was not provided!"))
                    return
                }
                player.setPlaybackTime(time: time.floatValue)
                result(nil)
            }
            else if(call.method == "setQueue"){
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                guard let startPlaying = args["startPlaying"] as? Bool else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter startPlaying was not provided!"))
                    return
                }
                let startID = args["startID"] as? String
                do {
                    try player.setQueue(songIDs: songIDs, startPlaying: startPlaying, startID: startID)
                    result(nil)
                } catch PlayifyError.runtimeError(let errorMessage) {
                    result(FlutterError(code: "setQueueError", message: "Set Queue Error", details: errorMessage))
                } catch {
                    result(FlutterError(code: "setQueueError", message: "Set Queue Error", details: error.localizedDescription))
                }
                
            }
            else if(call.method == "nowPlaying") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let size = args["size"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter size was not provided!"))
                    return
                }
                guard let metadata = player.nowPlaying() else {
                    result(FlutterError(code: "songError", message: "Current Song Error", details: "An error occured while getting the current song playing!"))
                    return
                }
                
                let image = metadata.artwork?.image(at: CGSize(width: size.intValue, height: size.intValue))
                
                //Resize image since there is an issue with getting the album cover with the desired size
                let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: size.intValue, height: size.intValue)) : nil
                
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                let imgdata = resizedImage?.jpegData(compressionQuality: 1.0)

                
                var data = metadata.toDict()
                data["image"] = imgdata ?? []
                
                result(data)
            }
            else if(call.method == "getAllSongs"){
                let allsongs = player.getAllSongs()
                var mysongs: [[String: Any]] = []
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let size = args["size"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter size was not provided!"))
                    return
                }
                var albums: [[String: String]] = []
                for metadata in allsongs {
                    var songDict = metadata.toDict()
                    
                    var albumExists = false
                    var albumExistsArtistName = ""

                    for album in albums {
                        let myalbumTitle = album["albumTitle"]
                        if myalbumTitle == metadata.albumTitle {
                            albumExists = true
                            albumExistsArtistName = album["artistName"] ?? ""
                        }
                    }
                    //If the album with a name does not exist or the name is the same but the artist's name
                    //is different, get the album cover.
                    if(!albumExists || (albumExists && albumExistsArtistName != metadata.artist)){
                        let image = metadata.artwork?.image(at: CGSize(width: size.intValue, height: size.intValue))
                        
                        //Resize image since there is an issue with getting the album cover with the desired size
                        let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: size.intValue, height: size.intValue)) : nil

                        //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                        let imgdata = resizedImage?.jpegData(compressionQuality: 0.85)
                        
                        songDict["image"] = imgdata ?? []
                        mysongs.append(songDict)
                        albums.append(["albumTitle": metadata.albumTitle ?? "", "artistName": metadata.artist ?? ""])
                    }
                    else {
                        mysongs.append(songDict)
                    }
                }
                result(mysongs)
            }
            else if(call.method == "getPlaylists") {
                let playlists = player.getPlaylists()
                let res: [[String: Any]] = playlists?.map({ playlist in
                    [
                        "title": playlist.value(forProperty: MPMediaPlaylistPropertyName) ?? "",
                        "playlistID": playlist.persistentID,
                        "songs": playlist.items.map({song in
                            song.toDict()
                        })
                    ]
                }) ?? []
                result(res)
            }
            else if(call.method == "setVolume") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let volume = args["volume"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter volume was not provided!"))
                    return
                }
                player.setVolume(volume: volume.floatValue)
                result(nil)
            }
            else if(call.method == "getVolume") {
                player.getVolume(completionHandler: {volume in
                    result(Float(volume))
                })
            }
            else if(call.method == "getShuffleMode") {
                let mode = player.getShuffleMode()
                guard let shuffleMode = mode else {
                    result(FlutterError(code: "Error", message: "Error Getting Shuffle Mode", details: "An error occurred while getting the shuffle mode!"))
                    return
                }
                return result(shuffleMode)
            }
            else if(call.method == "getRepeatMode") {
                let mode = player.getRepeatMode()
                guard let repeatMode = mode else {
                    result(FlutterError(code: "Error", message: "Error Getting Shuffle Mode", details: "An error occurred while getting the repeat mode!"))
                    return
                }
                return result(repeatMode)
            }
            else if(call.method == "incrementVolume") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let amount = args["amount"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter amount was not provided!"))
                    return
                }
                player.incrementVolume(amount: amount.floatValue)
                result(nil)
            }
            else if(call.method == "getAllGenres") {
                let genres = Array(player.getAllGenres())
                result(genres)
            }
            else if(call.method == "getSongsByGenre") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let genre = args["genre"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter genre was not provided!"))
                    return
                }
                guard let size = args["size"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter size was not provided!"))
                    return
                }

                let songs: [[String: Any]] = player.getSongsByGenre(genre: genre).map { metadata in
                    var dict = metadata.toDict()   
                    
                    let image = metadata.artwork?.image(at: CGSize(width: size.intValue, height: size.intValue))
                    
                    let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: size.intValue, height: size.intValue)) : nil

                    //Convert image to Uint8 Array to send to Flutter
                    let imgdata = resizedImage?.jpegData(compressionQuality: 0.85)
                    
                    dict["image"] = imgdata ?? []
                    return dict
                }
                result(songs)
            }
        }
        else {
            result(FlutterError(code: "invalidOSVersion", message: "Requires Min iOS 10.3", details: "Playify requires a minimum of iOS 10.3!"))
         }
    }
    
    
    //Taken from https://stackoverflow.com/a/39681316/11701504
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    public func onListen(
        withArguments _: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        eventSink = events
        player.startNotifications()
        updateHandler(controller: player.player)
        return nil
    }

    private func updateHandler(controller: MPMusicPlayerController) {
        eventSink?(controller.playbackState.rawValue)
    }

    public func onCancel(withArguments _: Any?) -> FlutterError? {
        player.stopNotifications()
        eventSink = nil
        return nil
    }
}
