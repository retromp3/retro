//
//  WatchCommunicationManager.swift
//  Shuffle Watch App
//
//  Created by Sakun on 2/21/23.
//

import Foundation
import WatchConnectivity

final class WatchCommunicationManager: NSObject, ObservableObject {
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func playNextSong() {
        session.sendMessage(["method": "nextSongFromWatch", "data": [:]], replyHandler: nil, errorHandler: nil)
    }
    
    func playPrevSong() {
        session.sendMessage(["method": "prevSongFromWatch", "data": [:]], replyHandler: nil, errorHandler: nil)
    }
    
}

extension WatchCommunicationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated else { return }
        //requestCounters()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        guard self.session.isReachable else { return }
        //requestCounters()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let method = message["method"] as? String, let data = message["data"] as? [String: Any] else { return }
        
    }
}

