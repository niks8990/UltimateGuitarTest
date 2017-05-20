//
//  SavedAlbumsViewController.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit

class SavedAlbumsViewController: BaseViewController {

    @IBOutlet weak var tableView:               UITableView!
    
    var albumList:                              [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        
        let result = DataManager.shared.getAlbumsList()
        
        if result.hasResult {
            albumList = result.data as! [Album]
        }
    }

}

extension SavedAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        
        let currentAlbum = albumList[indexPath.row]
        
        cell.setAlbum(currentAlbum)
        
        cell.setActionButtonType(.saved)
        
        cell.onRemove = { [unowned self] () in
            DataManager.shared.deleteAlbumById(currentAlbum.id)
            self.albumList.remove(at: self.albumList.index(of: currentAlbum)!)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
