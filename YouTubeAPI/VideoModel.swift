//
//  YoutubeVideoModel.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 13/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoModel : NSObject {
    var videoID : String?
    var title : String?
    var descr: String?
    var thumbnail : String?
    var pageToken : String?
    var playlistID : String?
    
    override init() {
        videoID = ""
        title = ""
        descr = ""
        thumbnail = ""
        pageToken = ""
        playlistID = ""
    }
    
    required init(dataJSON: JSON, kind: String, pageToken: String) {
        
        if kind == "youtube#searchListResponse" {
            if dataJSON["id"]["videoId"].string != nil {
                videoID = (dataJSON["id"]["videoId"].string)!
            }
        }
        else if kind == "youtube#playlistItemListResponse" {
            if dataJSON["snippet"]["resourceId"]["videoId"].string != nil {
                videoID = (dataJSON["snippet"]["resourceId"]["videoId"].string)!
            }
            playlistID = (dataJSON["snippet"]["playlistId"].string)!
        }
        
        title = (dataJSON["snippet"]["title"].string)!
        descr = (dataJSON["snippet"]["description"].string)!
        self.pageToken = pageToken
        guard let thumb = dataJSON["snippet"]["thumbnails"]["high"]["url"].string else {
            print("---> sem thumbnail")
            return
        }
        thumbnail = thumb
    }
}
