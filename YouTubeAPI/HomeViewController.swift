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
    var videos = [VideoModel]()
    var playlists = [PlaylistModel]()
    var videosOnPlaylist = [VideoModel]()
    var ytManager = YouTubeManager()
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
        
        ytManager.fetchAllPlaylists(pageToken: "") { (playlistsResult) in
            self.playlists = playlistsResult
            
            self.ytManager.fetchAllVideosOnChannel(pageToken: "", completion: { (videosResult) in
                self.videos = videosResult
                self.videosTableView.reloadData()
                self.waitingView.isHidden = true
            })
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
            self.videosOnPlaylist.removeAll()
            
            ytManager.fetchAllVideosOnPlaylist(playlistID: selectedCell.playlist.playlistID!, pageToken: "", completion: { (videosResult) in
                //print("Playlist videos: \(videosResult)")
                for video in videosResult {
                    if video.videoID != nil {
                        self.videosOnPlaylist.append(video)
                    }
                }
                
                self.playlistOrVideoSegmentedControl.selectedSegmentIndex = 1
                self.waitingView.isHidden = true
                
                self.videosTableView.reloadData()
            })
        }
        else {
            let selectedCell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
            selectedCell.playerView.playVideo()
            print("Selected Video: \(selectedCell.video.videoID)")
        }
    }
}

//MARK: - TableView Datasource Methods
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! PlaylistTableViewCell
            playlistCell.configurePlaylistInfo(playlists[indexPath.row])
            return playlistCell
        }
        else {
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
            if searchingPlaylist {
                //print("videoID: \(videosOnPlaylist[indexPath.row].videoID)")
                videoCell.configureVideoInfo(videosOnPlaylist[indexPath.row])
            }
            else {
                videoCell.configureVideoInfo(videos[indexPath.row])
            }
            return videoCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            return playlists.count
        }
        else {
            if searchingPlaylist {
                return videosOnPlaylist.count
            }
            else{
                return videos.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == (totalRows - 1) {
            print("lastCell")
            if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
                if (self.playlists[indexPath.row].pageToken?.characters.count)! > 0 {
                    //print("---> token: \(self.playlists[indexPath.row].pageToken)")
                    ytManager.fetchAllPlaylists(pageToken: self.playlists[indexPath.row].pageToken!) { (playlistsResult) in
                        for playlist in playlistsResult {
                            if playlist.playlistID != nil {
                                self.playlists.append(playlist)
                            }
                        }
                        self.videosTableView.reloadData()
                    }
                }
            }
            else {
                if searchingPlaylist {
                    if (self.videosOnPlaylist[indexPath.row].pageToken?.characters.count)! > 0 {
                        //print("---> token: \(self.videosOnPlaylist[indexPath.row].pageToken)")
                        ytManager.fetchAllVideosOnPlaylist(playlistID: self.videosOnPlaylist[indexPath.row].playlistID!, pageToken: self.videosOnPlaylist[indexPath.row].pageToken!, completion: { (videosResult) in
                            for video in videosResult {
                                if video.videoID != nil {
                                    self.videosOnPlaylist.append(video)
                                }
                            }
                            self.videosTableView.reloadData()
                        })
                    }
                }
                else {
                    if (self.videos[indexPath.row].pageToken?.characters.count)! > 0 {
                        ytManager.fetchAllVideosOnChannel(pageToken: self.videos[indexPath.row].pageToken!, completion: { (videosResult) in
                            for video in videosResult {
                                if video.videoID != nil {
                                    self.videos.append(video)
                                }
                            }
                            self.videosTableView.reloadData()
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
