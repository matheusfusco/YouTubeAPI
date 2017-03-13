//
//  VideoTableViewCell.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 13/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import SDWebImage
class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    var video = YoutubeVideoModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureVideoInfo(_ video : YoutubeVideoModel) {
        self.video = video
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
