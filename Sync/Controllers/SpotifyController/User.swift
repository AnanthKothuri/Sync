//
//  User.swift
//  Sync
//
//  Created by Ananth Kothuri on 3/17/24.
//

import Foundation

extension SpotifyController: SPTAppRemoteUserAPIDelegate {
    
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        // actions when capabilities change
    }
    
    
    func fetchUserCapabilities(completion: @escaping (SPTAppRemoteUserCapabilities?, Error?) -> Void) {
        self.appRemote.userAPI?.fetchCapabilities(callback: { capabilities, error in
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let capabilities = capabilities as? SPTAppRemoteUserCapabilities else {
                let error = NSError(domain: "Sync", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to cast capabilities"])
                completion(nil, error)
                return
            }

            completion(capabilities, nil)
        })
        
    }

}
