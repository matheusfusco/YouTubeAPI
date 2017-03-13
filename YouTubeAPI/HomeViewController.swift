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
    var videos = [YoutubeVideoModel]()
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var channelOrVideoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var waitingView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = APIManager()
        manager.getFrom(APIManager.youtubeAPI_URL, parameters: APIManager.youtubeParameters) { (result) in
            print("\(result)")
            
            let arrayVideos = JSON(data: result as! Data)["items"].arrayValue
            for video in arrayVideos {
                let model = YoutubeVideoModel(dataJSON: video)
                print("--> \(model.title)")
                self.videos.append(model)
            }
            self.videosTableView.reloadData()
        }
    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
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
    }
}

//MARK: - TableView Datasource Methods
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
        cell.configureVideoInfo(videos[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
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
