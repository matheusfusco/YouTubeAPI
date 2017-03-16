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
    //MARK: - API URLs
    static let searchAllVideosURL = "https://www.googleapis.com/youtube/v3/search"
    static let searchPlayListsURL = "https://www.googleapis.com/youtube/v3/playlists"
    static let searchPlayListsVideosURL = "https://www.googleapis.com/youtube/v3/playlistItems"
    
    //MARK: - YouTube Keys
    static let API_KEY = "AIzaSyCgrzeJDjlOyzgCy20FattbrKbcE8vMOSU" // Youtube API Key - Generated on 'Google Developer Console'
    static let CHANNEL_ID = "UCbNWIQcHEj6Y1g467UyPpBQ" //Pernambucanas - https://www.youtube.com/user/casaspernambucanas/videos
    
    //MARK: - Variables
    let manager = APIManager()
    var videos = [VideoModel]()
    var playlists = [PlaylistModel]()
    
    
    //MARK: - Custom Methods
    func fetchAllVideosOnChannel (pageToken: String, completion: @escaping([VideoModel]) -> Void) {
        
        var parameters = ["key": YouTubeManager.API_KEY,
                          "channelId": YouTubeManager.CHANNEL_ID,
                          "part": "snippet",
                          "order": "date",
                          "maxResults": "15"]
        if pageToken.characters.count > 0 {
            parameters.updateValue(pageToken, forKey: "pageToken")
        }
        
        self.videos.removeAll()
        
        manager.getFrom(YouTubeManager.searchAllVideosURL, parameters: parameters) { (result) in
            
            if (result as? Data) != nil {
                print("--> is Data type")
                let json = JSON(data: result as! Data)
                let kind = (json["kind"].string)!
                var pageToken : String = ""
                if json["nextPageToken"].string != nil {
                    pageToken = (json["nextPageToken"].string)!
                }
                let videosArray = json["items"].arrayValue
                
                for video in videosArray {
                    let model = VideoModel(dataJSON: video, kind: kind, pageToken: pageToken)
                    //print("--> Video:\(model.title)")
                    self.videos.append(model)
                }
                completion(self.videos)
            }
            else {
                print("--> Some error occurred!")
                completion(self.videos)
            }
            
            
            
        }
    }
    
    func fetchAllPlaylists (pageToken: String, completion: @escaping([PlaylistModel]) -> Void) {
        
        var parameters = ["key" : YouTubeManager.API_KEY,
                          "channelId" : YouTubeManager.CHANNEL_ID,
                          "part" : "snippet",
                          "maxResults": "5"]
        if pageToken.characters.count > 0 {
            parameters.updateValue(pageToken, forKey: "pageToken")
        }
        
        self.playlists.removeAll()
        
        manager.getFrom(YouTubeManager.searchPlayListsURL, parameters: parameters) { (result) in
            if (result as? Data) != nil {
                print("--> is Data type")
                let json = JSON(data: result as! Data)
                let playlistsArray = json["items"].arrayValue
                
                var pageToken : String = ""
                if json["nextPageToken"].string != nil {
                    pageToken = (json["nextPageToken"].string)!
                }
                
                for playlist in playlistsArray {
                    let model = PlaylistModel(dataJSON: playlist, pageToken: pageToken)
                    //print("---> Playlist: \(model.title)")
                    self.playlists.append(model)
                }
                completion(self.playlists)
            }
            else {
                print("--> Some error occurred!")
                completion(self.playlists)
            }
            
        }
    }
    
    func fetchAllVideosOnPlaylist (playlistID: String, pageToken: String, completion: @escaping([VideoModel]) -> Void) {
        var parameters = ["key" : YouTubeManager.API_KEY,
                          "playlistId" : playlistID,
                          "part" : "snippet",
                          "maxResults": "5"]
        if pageToken.characters.count > 0 {
            parameters.updateValue(pageToken, forKey: "pageToken")
        }
        
        self.videos.removeAll()
        
        manager.getFrom(YouTubeManager.searchPlayListsVideosURL, parameters: parameters) { (result) in
            
            if (result as? Data) != nil {
                print("--> is Data type")
                let json = JSON(data: result as! Data)
                let kind = (json["kind"].string)!
                //let pageToken = (json["nextPageToken"].string)!
                var pageToken : String = ""
                if json["nextPageToken"].string != nil {
                    pageToken = (json["nextPageToken"].string)!
                }
                let videosArray = json["items"].arrayValue
                
                for video in videosArray {
                    let model = VideoModel(dataJSON: video, kind: kind, pageToken: pageToken)
                    //print("---> Video in Playlist: \(model.title)")
                    self.videos.append(model)
                }
                completion(self.videos)
            }
            else {
                print("--> Some error occurred!")
                completion(self.videos)
            }
        }
    }
}
