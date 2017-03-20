//
//  ViewController.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 10/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//http://www.appcoda.com/youtube-api-ios-tutorial/

import UIKit
import youtube_ios_player_helper
import SwiftyJSON

class HomeViewController: UIViewController {
    //MARK: - Variables
    //var videos = [YouTubeModel]()
    //var playlists = [YouTubeModel]()
    //var videosOnPlaylist = [YouTubeModel]()
    
    var ytManager = YouTubeManager()
    var videosOnChannel = YouTube()
    var playlistsOnChannel = YouTube()
    var videosOnPlaylist = YouTube()
    
    var searchingPlaylist : Bool = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var playlistOrVideoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var waitingView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchingPlaylist = false

        ytManager.fetchYouTubeData(urlAPI: .allPlaylists, videoType: .playlistOnChannel, parameters: .allPlaylists, pageToken: "", playlist: "") { (result) in
            if let modelResult = result as? YouTube {
                self.playlistsOnChannel = modelResult
                
                self.ytManager.fetchYouTubeData(urlAPI: .allVideos, videoType: .videoOnChannel, parameters: .allVideos, pageToken: "", playlist: "", completion: { (result2) in
                    if let modelResult2 = result2 as? YouTube {
                        self.videosOnChannel = modelResult2
                        self.videosTableView.reloadData()
                        self.waitingView.isHidden = true
                    }
                })
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            print("load playlists")
            searchingPlaylist = false
        }
        else {
            print("load videos")
        }
        self.videosTableView.reloadData()
    }
    
    //MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - TableView Delegate Methods
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if playlistOrVideoSegmentedControl .selectedSegmentIndex == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath) as! PlaylistTableViewCell
            //print("Selected Playlist: \(selectedCell.playlistTitleLabel.text)")
            
            self.searchingPlaylist = true
            self.waitingView.isHidden = false
            self.videosOnPlaylist.items?.removeAll()
            
            ytManager.fetchYouTubeData(urlAPI: .allVideosOnPlaylist, videoType: .videoOnPlaylist, parameters: .allVideosOnPlaylist, pageToken: "", playlist: selectedCell.playlist.playlistID!, completion: { (result) in
                if let modelResult = result as? YouTube {
                    self.videosOnPlaylist = modelResult
//                    for video in modelResult.items! {
//                        if video.videoID != nil {
//                            self.videosOnPlaylist.items?.append(video)
//                        }
//                    }
                }
                self.playlistOrVideoSegmentedControl.selectedSegmentIndex = 1
                self.waitingView.isHidden = true
                self.videosTableView.reloadData()
            })
        }
        else {
            let selectedCell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
            //selectedCell.playerView.playVideo()
            selectedCell.ytIndicatorView.startAnimating()
            selectedCell.playerView.load(withVideoId: selectedCell.video.videoID!)
            print("Selected Video: \(selectedCell.video.videoID)")
        }
    }
}

//MARK: - TableView Datasource Methods
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! PlaylistTableViewCell
            playlistCell.configurePlaylistInfo((playlistsOnChannel.items?[indexPath.row])!)
            return playlistCell
        }
        else {
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
            if searchingPlaylist {
                videoCell.configureVideoInfo((videosOnPlaylist.items?[indexPath.row])!)
            }
            else {
                videoCell.configureVideoInfo((videosOnChannel.items?[indexPath.row])!)
            }
            return videoCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            return playlistsOnChannel.items!.count
        }
        else {
            if searchingPlaylist {
                return videosOnPlaylist.items!.count
            }
            else{
                
                return videosOnChannel.items!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == (totalRows - 1) {
            //print("lastCell")
            if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
                if (self.playlistsOnChannel.nextPageToken != "") {
                    ytManager.fetchYouTubeData(urlAPI: .allPlaylists, videoType: .playlistOnChannel, parameters: .allPlaylists, pageToken: self.playlistsOnChannel.nextPageToken!, playlist: "", completion: { (playlistResult) in
                        if let result = playlistResult as? YouTube {
                            self.playlistsOnChannel.nextPageToken =  result.nextPageToken
                            
                            for playlist in result.items! {
                                self.playlistsOnChannel.items?.append(playlist)
                            }
                            self.videosTableView.reloadData()
                        }
                    })
                }
            }
            else {
                if searchingPlaylist {
                    if (self.videosOnPlaylist.nextPageToken != "") {
                        ytManager.fetchYouTubeData(urlAPI: .allVideosOnPlaylist, videoType: .videoOnPlaylist, parameters: .allVideosOnPlaylist, pageToken: self.videosOnPlaylist.nextPageToken!, playlist: (self.videosOnPlaylist.items?[indexPath.row].playlistID!)!, completion: { (videosOnPlaylistResult) in
                            if let result = videosOnPlaylistResult as? YouTube {
                                self.videosOnPlaylist.nextPageToken = result.nextPageToken
                                
                                for video in result.items! {
                                    if video.videoID != nil {
                                        self.videosOnPlaylist.items?.append(video)
                                    }
                                }
                                self.videosTableView.reloadData()
                            }
                        })
                    }
                }
                else {
                    if (self.videosOnChannel.nextPageToken != "") {
                        ytManager.fetchYouTubeData(urlAPI: .allVideos, videoType: .videoOnChannel, parameters: .allVideos, pageToken: self.videosOnChannel.nextPageToken!, playlist: "", completion: { (videosResult) in
                            if let result = videosResult as? YouTube {
                                self.videosOnChannel.nextPageToken = result.nextPageToken
                                
                                for video in result.items! {
                                    if video.videoID != nil {
                                        self.videosOnChannel.items?.append(video)
                                    }
                                }
                                self.videosTableView.reloadData()
                            }
                        })
                    }
                }
            }
        }
    }
}

//MARK: - Textfield Delegate Methods
extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
