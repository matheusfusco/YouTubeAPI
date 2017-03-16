//
//  VideoTableViewCell.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 13/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var ytIndicatorView: UIActivityIndicatorView!
    
    var video = VideoModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureVideoInfo(_ video : VideoModel) {
        self.video = video
        
        playerView.delegate = self
        
        if let videoID = self.video.videoID {
            playerView.load(withVideoId: videoID)
        }
        
        if let videoTitle = self.video.title {
            titleLabel.text = videoTitle
        }
        
        if let videoDescription = self.video.descr {
            descriptionLabel.text = videoDescription
        }
        
        if let videoThumbnail = self.video.thumbnail {
            thumbnailImgView.sd_setImage(with: URL(string : videoThumbnail))
        }
    }

}

//MARK: - YTPlayerView Delegate Methods
extension VideoTableViewCell : YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
            
        case .buffering:
            print("buffering")
            self.ytIndicatorView.startAnimating()
            break
            
        case .ended:
            print("ended")
            break
            
        case .paused:
            print("paused")
            self.ytIndicatorView.stopAnimating()
            break
            
        case .playing:
            print("playing")
            self.ytIndicatorView.stopAnimating()
            break
            
        case .queued:
            print("queued")
            break
            
        case .unknown:
            print("unkown")
            break
            
        case .unstarted:
            print("unstarted")
            break
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.ytIndicatorView.stopAnimating()
    }
}
