//
//  YouTubeManager.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 14/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//
//https://www.youtube.com/user/casaspernambucanas/
//
//https://developers.google.com/youtube/v3/docs/playlists/list
//https://developers.google.com/youtube/v3/docs/playlistItems/list
//https://developers.google.com/youtube/v3/docs/search/list


import UIKit
import SwiftyJSON

class YouTubeManager: NSObject {
    //MARK: - YouTube API Keys
    let API_KEY = "AIzaSyCgrzeJDjlOyzgCy20FattbrKbcE8vMOSU" // Youtube API Key - Generated on 'Google Developer Console'
    let CHANNEL_ID = "UCbNWIQcHEj6Y1g467UyPpBQ" //Pernambucanas - https://www.youtube.com/user/casaspernambucanas/videos
    let MAX_RESULTS = "5"
    
    //MARK: - Variables
    let manager = APIManager()
    
    
    //MARK: - Custom Methods
    func fetchYouTubeData (urlAPI: API, videoType: videoType, parameters: parameter, pageToken: String, playlist: String, completion: @escaping(Any?) -> Void) {
        let params = transformToParameterFormat(param: parameters, playlistID: playlist, pageToken: pageToken)
        //self.models.removeAll()
        manager.getFrom(urlAPI.rawValue, parameters: params) { (result) in
            if let error = result as? Error {
                print("Error: \(error.localizedDescription)")
                completion(error)
            }
            else if (result as? Data) != nil {
                let json = JSON(data: result as! Data)
                let ytModel = YouTube(dataJSON: json)
                completion(ytModel)
            }
            else {
                print("Something else was returned: \(result.debugDescription)")
                completion(result)
            }
        }
    }
    
    private func transformToParameterFormat(param: parameter, playlistID : String, pageToken: String) -> Dictionary <String, Any> {
        var defaultParameters = ["key": API_KEY, "part": "snippet", "maxResults": MAX_RESULTS]
        if pageToken.characters.count > 0 {
            defaultParameters.updateValue(pageToken, forKey: "pageToken")
        }
        switch param {
            case .allVideos:
                defaultParameters.updateValue(CHANNEL_ID, forKey: "channelId")
                defaultParameters.updateValue("date", forKey: "order")
                return defaultParameters
            
            case .allPlaylists:
                defaultParameters.updateValue(CHANNEL_ID, forKey: "channelId")
                return defaultParameters
                
            case .allVideosOnPlaylist:
                if playlistID.characters.count > 0 {
                    defaultParameters.updateValue(playlistID, forKey: "playlistId")
                }
                return defaultParameters
        }
    }
}
