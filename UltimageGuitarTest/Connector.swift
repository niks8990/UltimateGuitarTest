//
//  Connector.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

enum HTTP_METHOD: String{
    case GET = "GET"
    case POST = "POST"
    case UPLOAD = "UPLOAD"
}

typealias ServiceResponse = (Any?, _ success: Bool, _ error: Error?) -> Void

class Connector: NSObject {
    
    static let shared = Connector()
    
    fileprivate override init() {
        super.init()
    }
    
    func doRetrieveAlbumsByName(_ name: String, onCompletion: @escaping ServiceResponse) {
        let params = ["query" : "release:\(name)", "fmt" : "json"]
        
        doSessionTaskWithParams(params) { (data, success, error) in
            
            if let jsonData = data as? JSON, success {
                var albumsList: [Album] = []
                let releasesList = jsonData["release-groups"].arrayValue
                
                for release in releasesList {
                    albumsList.append(Album(json:release))
                }
                
                onCompletion(albumsList, success, error)
            } else {
                print(error ?? "didn't recieve data on Connector")
            }
        }
    }
    
    fileprivate func doSessionTaskWithParams(_ parameters: Any?, onCompletion: @escaping ServiceResponse) {
        let urlString = "http://musicbrainz.org/ws/2/release-group/"
        
        guard isReachable() else {
            let error = NSError(domain: urlString, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            onCompletion(nil, false, error as Error)
            return
        }
        
        let manager = sessionManager()
        
        #if DEBUG
            print(urlString, parameters ?? "")
        #endif
        manager.get(urlString, parameters: parameters, progress: nil, success: { (dataTask, object) in
            self.doComplitionWithObject(object, onCompletion)
        }, failure: { (dataTask, error) in
            self.doComplitionWithError(dataTask, error: error, onCompletion)
        })
        
    }
    
    fileprivate func sessionManager() -> AFHTTPSessionManager {
        let securityPolicy = AFSecurityPolicy(pinningMode: .none)
        let manager = AFHTTPSessionManager()
        manager.securityPolicy = securityPolicy
        manager.completionQueue = DispatchQueue.main
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }
    
    fileprivate func doComplitionWithObject(_ object: Any?, _ onComplition: @escaping ServiceResponse) {
        var status = true
        var jsonObject = JSON(data: object as! Data)
        if let serverStatus = jsonObject["success"].bool {
            status = serverStatus
            var newData: Any? = jsonObject["data"]
            if !status {
                newData = jsonObject["error"].string
            }
            #if DEBUG
                print(newData.debugDescription)
            #endif
            onComplition(newData, status, nil)
            return
        }
        #if DEBUG
            print(jsonObject)
        #endif
        onComplition(jsonObject, status, nil)
    }
    
    fileprivate func doComplitionWithError(_ object: Any?, error: Error?, _ onComplition: @escaping ServiceResponse) {
        var jsonObject: JSON?
        if let data = object as? Data {
            jsonObject = JSON(data: data)
        }
        #if DEBUG
            print(jsonObject.customMirror)
            print(error?.localizedDescription ?? "")
        #endif
        onComplition(jsonObject, false, error)
    }
        
    
    fileprivate func isReachable() -> Bool {
        return AFNetworkReachabilityManager.shared().isReachable  || AFNetworkReachabilityManager.shared().networkReachabilityStatus == AFNetworkReachabilityStatus.unknown
    }
    
}
