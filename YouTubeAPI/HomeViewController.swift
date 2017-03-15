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
        
        ytManager.fetchAllPlaylists { (playlistsResult) in
            self.playlists = playlistsResult
            
            self.ytManager.fetchAllVideosOnChannel { (videosResult) in
                self.videos = videosResult
                self.videosTableView.reloadData()
                self.waitingView.isHidden = true
            }
        }
        
        
        
    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        switch playlistOrVideoSegmentedControl.selectedSegmentIndex {
        case 0: //Playlists
            print("load playlists")
            searchingPlaylist = false
            break
            
        case 1: //Videos
            print("load videos")
            break
            
        default:
            break
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
        
        if playlistOrVideoSegmentedControl
            .selectedSegmentIndex == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath) as! PlaylistTableViewCell
            //print("Selected Playlist: \(selectedCell.playlistTitleLabel.text)")
            
            searchingPlaylist = true
            self.waitingView.isHidden = false
            self.videosOnPlaylist.removeAll()
            ytManager.fetchAllVideosOnPlaylist(playlistID: selectedCell.playlist.playlistID!, completion: { (videosResult) in
                //print("Playlist videos: \(videosResult)")
                self.videosOnPlaylist = videosResult
                self.playlistOrVideoSegmentedControl.selectedSegmentIndex = 1
                self.videosTableView.reloadData()
                self.waitingView.isHidden = true
            })
        }
        else if playlistOrVideoSegmentedControl.selectedSegmentIndex == 1 {
            let selectedCell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
            selectedCell.playerView.playVideo()
            print("Selected Video: \(selectedCell.video.videoID)")
        }
    }
}

//MARK: - TableView Datasource Methods
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch playlistOrVideoSegmentedControl.selectedSegmentIndex {
        case 0: //Playlists
            let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! PlaylistTableViewCell
            playlistCell.configurePlaylistInfo(playlists[indexPath.row])
            return playlistCell
            
        case 1: //Videos
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
            if searchingPlaylist {
                print("videoID: \(videosOnPlaylist[indexPath.row].videoID)")
                videoCell.configureVideoInfo(videosOnPlaylist[indexPath.row])
            }
            else {
                videoCell.configureVideoInfo(videos[indexPath.row])
            }
            return videoCell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch playlistOrVideoSegmentedControl.selectedSegmentIndex {
        case 0: //Playlists
            return playlists.count
            
        case 1: //Videos
            if searchingPlaylist {
                return videosOnPlaylist.count
            }
            else{
                return videos.count
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

//MARK: - Textfield Delegate Methods
extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
