//
//  SearchAlbumsViewController.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchAlbumsViewController: BaseViewController {
    
    @IBOutlet weak var tableView:                   UITableView!
    @IBOutlet weak var searchTextField:             UITextField!
    
    var albumList:                                  [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        searchTextField.addAccessoryDone()
        searchTextField.autocorrectionType = .no
    }
    
    @IBAction func onSearchButtonPress(_ sender: Any) {
        let albumName = searchTextField.text!
        
        if albumName.characters.count == 0 {
            let alertController = UIAlertController(title: "Oups", message: "Please, fill search field", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Connector.shared.doRetrieveAlbumsByName(albumName) { (data, success, error) in
                if let albumData = data as? [Album], success {
                    self.albumList = albumData
                    self.tableView.reloadData()
                } else {
                    print(error ?? "")
                }
            }
        }
        searchTextField.resignFirstResponder()
    }
    

}

extension SearchAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        if DataManager.shared.containsAlbumWithId(currentAlbum.id) {
            cell.setActionButtonType(.saved)
        } else {
            cell.setActionButtonType(.notSaved)
        }
        
        cell.onAdd = { [unowned cell] () in
            DataManager.shared.insertAlbum(currentAlbum)
            cell.setActionButtonType(.saved)
        }
        
        cell.onRemove = { [unowned cell]  () in
            DataManager.shared.deleteAlbumById(currentAlbum.id)
            cell.setActionButtonType(.notSaved)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
