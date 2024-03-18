//
//  ContentView.swift
//  Sync
//
//  Created by Ananth Kothuri on 3/17/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var spotifyController: SpotifyController
    
    var body: some View {
        VStack {
            Button(action: {
                spotifyController.connect()
            }, label: {
                Text("Connect")
            })
            
            Button(action: {
                spotifyController.pause()
            }, label: {
                Text("Pause")
            })
            
            Button(action: {
                spotifyController.resume()
            }, label: {
                Text("Resume")
            })
            
            Button(action: {
                spotifyController.fetchUserCapabilities { capabilities, error in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else if let capabilities = capabilities{
                        print(capabilities.canPlayOnDemand)
                    }
                }
                
            }, label: {
                Text("Capabilities")
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
