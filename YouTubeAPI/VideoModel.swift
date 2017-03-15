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
    
    override init() {
        videoID = ""
        title = ""
        descr = ""
        thumbnail = ""
    }
    
    required init(dataJSON: JSON, kind: String) {
        
        if kind == "youtube#searchListResponse" {
            videoID = (dataJSON["id"]["videoId"].string)!
        }
        else if kind == "youtube#playlistItemListResponse" {
            videoID = (dataJSON["snippet"]["resourceId"]["videoId"].string)!
        }
        
        title = (dataJSON["snippet"]["title"].string)!
        descr = (dataJSON["snippet"]["description"].string)!
        guard let thumb = dataJSON["snippet"]["thumbnails"]["high"]["url"].string else {
            print("---> sem thumbnail")
            return
        }
        thumbnail = thumb
    }
}
