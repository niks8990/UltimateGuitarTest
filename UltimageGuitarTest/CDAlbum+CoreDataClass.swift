//
//  CDAlbum+CoreDataClass.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import Foundation
import CoreData

@objc(CDAlbum)
public class CDAlbum: NSManagedObject {

    func populate(album: Album) {
        self.id = album.id
        self.name = album.name
        self.artistName = album.artistName
    }
}
