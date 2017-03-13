//
//  APIManager.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 13/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    
    static let youtubeAPI_URL = "https://www.googleapis.com/youtube/v3/search"
    static let youtubeParameters = ["key": "AIzaSyCgrzeJDjlOyzgCy20FattbrKbcE8vMOSU", // Youtube API Key
                                    "channelId": "UCbNWIQcHEj6Y1g467UyPpBQ", //Pernambucanas - https://www.youtube.com/user/casaspernambucanas/videos
                                    "part": "snippet",
                                    "order": "date",
                                    "maxResults": "5"]
    
    public func getFrom(_ url: String, parameters: Dictionary<String, Any>, completion: @escaping(Any?) -> Void) {
        Alamofire.request(url, method: .get, parameters: parameters)
        .validate()
        .responseJSON { (response) in
            switch response.result {
            case .success:
                completion(response.data)
                break
                
            case .failure(let error):
                print(error)
                completion(error)
                break
            }
        }
    }
    
    public func postTo(_ url: String, parameters: Dictionary<String, Any>, completion: @escaping(Any?) -> Void) {
        Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    completion(response.result)
                    break
                    
                case .failure(let error):
                    print(error)
                    completion(error)
                    break
                }
        }
    }
}
