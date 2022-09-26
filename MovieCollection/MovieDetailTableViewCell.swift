//
//  MovieDetailTableViewCell.swift
//  MovieCollection
//
//  Created by shiva ram on 26/09/22.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemRelease: UILabel!
    @IBOutlet weak var itemDirector: UILabel!
    @IBOutlet weak var itemPlot: UILabel!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
