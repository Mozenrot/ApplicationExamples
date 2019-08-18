//
//  MovieCell.swift
//  MovieAppInManageTask
//
//  Created by LeoChernyak on 26/07/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var movieYearLabel: UILabel!
    
    @IBOutlet weak var movieCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieNameLabel.preferredMaxLayoutWidth = movieNameLabel.intrinsicContentSize.width
        movieNameLabel.sizeToFit()
        // Initialization code
    }

    

}
