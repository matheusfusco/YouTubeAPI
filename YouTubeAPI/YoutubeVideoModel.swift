//
//  YoutubeVideoModel.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 13/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import Foundation
import SwiftyJSON

class YoutubeVideoModel : NSObject {
    var videoID : String
    var title : String?
    var descr: String?
    var thumbnail : String?
    
    override init() {
        videoID = ""
        title = ""
        descr = ""
        thumbnail = ""
    }
    
    required init(dataJSON: JSON) {
        videoID = (dataJSON["id"]["videoId"].string)!
        title = (dataJSON["snippet"]["title"].string)!
        descr = (dataJSON["snippet"]["description"].string)!
        thumbnail = (dataJSON["snippet"]["thumbnails"]["high"]["url"].string)!
    }
}
