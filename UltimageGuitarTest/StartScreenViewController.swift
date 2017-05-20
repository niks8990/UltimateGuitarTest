//
//  StartScreenViewController.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit

class StartScreenViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSearchMusicButtonPress(_ sender: Any) {
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchAlbumsViewController") as! SearchAlbumsViewController
        
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func onShowSavedAlbumsButtonPress(_ sender: Any) {
        let savedViewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedAlbumsViewController") as! SavedAlbumsViewController
        
        self.navigationController?.pushViewController(savedViewController, animated: true)
        
    }
    

}
