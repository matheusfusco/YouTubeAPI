//
//  ViewController.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 10/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//http://www.appcoda.com/youtube-api-ios-tutorial/

import UIKit
import youtube_ios_player_helper

class HomeViewController: UIViewController {
    //MARK: - Variables
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var channelOrVideoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var waitingView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "")
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

//MARK: - Textfield Delegate Methods
extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
