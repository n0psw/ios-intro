//
//  FavoriteCellTableViewCell.swift
//  assignment9
//
//  Created by Adilkhan on 18.11.2026.
//

import UIKit

class FavoriteCellTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet var starImageViews: [UIImageView]!
    func configure(with item: FavoriteItem) {
        itemImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        for (index, star) in starImageViews.enumerated() {
            if index < item.rating {
                star.image = UIImage(systemName: "star.fill")
            } else {
                star.image = UIImage(systemName: "star")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
