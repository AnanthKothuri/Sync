//
//  SyncApp.swift
//  Sync
//
//  Created by Ananth Kothuri on 3/17/24.
//

import SwiftUI

@main
struct SyncApp: App {
    @StateObject var spotifyController = SpotifyController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                }
                .environmentObject(spotifyController)
        }
    }
}
