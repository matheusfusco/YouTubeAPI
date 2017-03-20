//
//  PlaylistTableViewCell.swift
//  YouTubeAPI
//
//  Created by Matheus Pacheco Fusco on 14/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import SDWebImage

class PlaylistTableViewCell: UITableViewCell {

    //MARK: - Variables
    var playlist = YouTubeModel()
    
    //MARK: - IBOutlets
    @IBOutlet weak var playlistDescriptionLabel: UILabel!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePlaylistInfo(_ playlist : YouTubeModel) {
        self.playlist = playlist
        
        if let playlistTitle = self.playlist.title {
            playlistTitleLabel.text = playlistTitle
        }
        
        if let playlistDescription = self.playlist.descr {
            playlistDescriptionLabel.text = playlistDescription
        }
        
        if let playlistThumbnail = self.playlist.thumbnail {
            thumbnailImgView.sd_setImage(with: URL(string: playlistThumbnail))
        }
    }

}
