//
//  PostsTableViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Prabh on 2022-05-19.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import UIKit
import SDWebImage

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var ivAvatarImageView: UIImageView!
    @IBOutlet weak var lUsernameLabel: UILabel!
    @IBOutlet weak var lSubTitleLabel: UILabel!
    @IBOutlet weak var lDescriptionTitleLabel: UILabel!

    /// returning cell nib name
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
          
    /// returning cell identifier 
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /// Configure custom tableview cell with data
    func configureCell(name: String, thumbnail: String, title: String, body: String) {
        let url = URL(string: thumbnail)
        ivAvatarImageView.sd_setImage(with: url)
        lUsernameLabel.text = name
        lSubTitleLabel.text = title
        lDescriptionTitleLabel.text = body
    }
}
