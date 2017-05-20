//
//  Album.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit
import SwiftyJSON

class Album: NSObject {

    var artistName:             String?
    var name:                   String?
    var id:                     String?
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["title"].stringValue
        
        let artist = json["artist-credit"].arrayValue[0]["artist"].dictionaryValue
        self.artistName = artist["name"]?.stringValue
    }
    
    init(cdAlbum: CDAlbum) {
        self.artistName = cdAlbum.artistName
        self.id = cdAlbum.id
        self.name = cdAlbum.name
    }
}
