//
//  ImageSearchRealm.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import RealmSwift

class ImageSearchRealm: Object, Encodable {
    
    // MARK: - Properties
    @objc dynamic var id: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var tag: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(resp: ImageResponse) {
        self.init()
        self.id = "generalId"
        self.imageURL = resp.imageURL.absoluteString
        self.tag = resp.tag
    }
}
