//
//  SearchResultTableViewCell.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumNameLabel:                  UILabel!
    @IBOutlet weak var artistNameLabel:                 UILabel!
    @IBOutlet weak var yearLabel:                       UILabel!
    @IBOutlet weak var actionButton:                    RoundCornersButton!
    
    var searchResultType:                               SearchResultType = .notSaved
    var onAdd:                                          ((Void)->Void)?
    var onRemove:                                       ((Void)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func setActionButtonType(_ type: SearchResultType) {
        searchResultType = type
        switch searchResultType {
        case .notSaved:
            actionButton.backgroundColor = Colors.APP_LIGHT_GREEN_COLOR
            actionButton.setTitle("ADD", for: .normal)
        case .saved:
            actionButton.backgroundColor = Colors.APP_RED_COLOR
            actionButton.setTitle("REMOVE", for: .normal)
        }
    }
    
    func setAlbum(_ album: Album) {
        albumNameLabel.text = album.name
        artistNameLabel.text = album.artistName
        yearLabel.text = album.id
    }
    
    @IBAction func onActionButtonPress(_ sender: Any) {
        switch searchResultType {
        case .saved:
            if let action = onRemove {
                action()
            }
        case .notSaved:
            if let action = onAdd {
                action()
            }
        }
    }
}

enum SearchResultType {
    case saved
    case notSaved
}
