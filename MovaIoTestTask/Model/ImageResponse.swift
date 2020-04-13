//
//  ImageResponse.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation

struct ImageResponse {
    let tag: String
    let imageURL: URL
}

extension ImageResponse {
    init?(json: [String: Any], tag: String) {
        guard let results = json["urls"] as? [String: Any], let imageURL = results["small"] as? String else {
            return nil
        }

        self.tag = tag
        self.imageURL = URL(string: imageURL)!
    }
    
    init(realm: ImageSearchRealm) {
        self.tag = realm.tag
        self.imageURL = URL(string: realm.imageURL)!
    }
}
