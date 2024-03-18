//
//  SpotifyController.swift
//  Sync
//
//  Created by Ananth Kothuri on 3/17/24.
//

import SwiftUI
//import SpotifyiOS
import Combine

class SpotifyController: NSObject, ObservableObject {
    let spotifyClientID = "c119a089f47a46d492d20b3bdcd27306"
    let spotifyRedirectURL = URL(string:"sync://spotify-login-callback")!
    
    var accessToken: String? = nil
    
    var playURI = ""
    
//    private var connectCancellable: AnyCancellable?
//
//    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
//        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                self.connect()
//            }
//        
//        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                self.disconnect()
//            }

    }
        
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
        
    }
    
    func connect() {
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            self.appRemote.authorizeAndPlayURI("")
            return
        }
        
        appRemote.connect()
    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
}


extension SpotifyController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected with error: \(error?.localizedDescription ?? "None")")
    }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
    }

}