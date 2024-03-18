//
//  Playback.swift
//  Sync
//
//  Created by Ananth Kothuri on 3/17/24.
//

import Foundation

extension SpotifyController {
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {_, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func seekForward15Seconds() {
        self.appRemote.playerAPI?.seekForward15Seconds(defaultCallback)
    }

    func seekBackward15Seconds() {
        self.appRemote.playerAPI?.seekBackward15Seconds(defaultCallback)
    }

    func pickPodcastSpeed() {
        self.appRemote.playerAPI?.getAvailablePodcastPlaybackSpeeds({ (speeds, error) in
            if error == nil, let speeds = speeds as? [SPTAppRemotePodcastPlaybackSpeed] {
                // does nothing
            }
        })
    }

    func skipNext() {
        self.appRemote.playerAPI?.skip(toNext: defaultCallback)
    }

    func skipPrevious() {
        self.appRemote.playerAPI?.skip(toPrevious: defaultCallback)
    }

    func resume() {
        self.appRemote.playerAPI?.resume(defaultCallback)
    }

    func pause() {
        print("pausing")
        self.appRemote.playerAPI?.pause(defaultCallback)
    }

    func toggleShuffle() {
        getPlayerState { [self] playerState, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let playerState = playerState {
                self.appRemote.playerAPI?.setShuffle(!playerState.playbackOptions.isShuffling, callback: defaultCallback)
            }
        }
    }

    func getPlayerState(completion: @escaping (SPTAppRemotePlayerState?, Error?) -> Void) {
        _ = self.appRemote.playerAPI?.getPlayerState { result, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            let playerState = result as? SPTAppRemotePlayerState
            completion(playerState, nil)
        }
    }

    func getCurrentPodcastSpeed(completion: @escaping (SPTAppRemotePodcastPlaybackSpeed?, Error?) -> Void) {
        _ = self.appRemote.playerAPI?.getCurrentPodcastPlaybackSpeed({ speed, error in
            guard error == nil, let speed = speed as? SPTAppRemotePodcastPlaybackSpeed else {
                completion(nil, error)
                return
            }
            completion(speed, nil)
        })
    }


    func playTrackWithIdentifier(_ identifier: String) {
        self.appRemote.playerAPI?.play(identifier, callback: defaultCallback)
    }

//    private func subscribeToPlayerState() {
//        guard (!subscribedToPlayerState) else { return }
//        appRemote?.playerAPI!.delegate = self
//        appRemote?.playerAPI?.subscribe { (_, error) -> Void in
//            guard error == nil else { return }
//            self.subscribedToPlayerState = true
//            self.updatePlayerStateSubscriptionButtonState()
//        }
//    }
//
//    private func unsubscribeFromPlayerState() {
//        guard (subscribedToPlayerState) else { return }
//        appRemote?.playerAPI?.unsubscribe { (_, error) -> Void in
//            guard error == nil else { return }
//            self.subscribedToPlayerState = false
//            self.updatePlayerStateSubscriptionButtonState()
//        }
//    }

    func toggleRepeatMode() {
        getPlayerState { [self] playerState, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let playerState = playerState {
                let repeatMode: SPTAppRemotePlaybackOptionsRepeatMode = {
                    switch playerState.playbackOptions.repeatMode {
                    case .off: return .track
                    case .track: return .context
                    case .context: return .off
                    default: return .off
                    }
                }()

                self.appRemote.playerAPI?.setRepeatMode(repeatMode, callback: defaultCallback)
            }
        }
    }
}
