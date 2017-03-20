//
//  Enums.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 17/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import Foundation

enum videoType {
    case videoOnChannel
    case videoOnPlaylist
    case playlistOnChannel
    case none
}

enum parameter {
    case allVideos
    case allPlaylists
    case allVideosOnPlaylist
}

enum API : String {
    case allVideos = "https://www.googleapis.com/youtube/v3/search"
    case allPlaylists = "https://www.googleapis.com/youtube/v3/playlists"
    case allVideosOnPlaylist = "https://www.googleapis.com/youtube/v3/playlistItems"
}

enum videoKind : String {
    case allVideos = "youtube#searchListResponse"
    case allPlaylists = "youtube#playlistListResponse"
    case allVideosOnPlaylist = "youtube#playlistItemListResponse"
}
