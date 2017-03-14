//
//  PlaylistModel.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 14/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaylistModel: NSObject {
    var playlistID : String?
    var title : String?
    var descr : String?
    var thumbnail : String?
    
    override init () {
        playlistID = ""
        title = ""
        descr = ""
        thumbnail = ""
    }
    
    required init(dataJSON: JSON) {
        playlistID = (dataJSON["id"].string)!
        title = (dataJSON["snippet"]["title"].string)!
        descr = (dataJSON["snippet"]["description"].string)!
        thumbnail = (dataJSON["snippet"]["thumbnails"]["high"]["url"].string)!
    }
}
