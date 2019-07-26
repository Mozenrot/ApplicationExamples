//
//  MovieDescriptionViewController.swift
//  MovieAppInManageTask
//
//  Created by LeoChernyak on 26/07/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit

class MovieDescriptionViewController: UIViewController {
    @IBOutlet weak var posterPlaceImage: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var movieDescription : String?
    var imageViewData : Data?
    var movieName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = movieName
        movieDescriptionLabel.text = movieDescription ?? "There is no discription"
        if let posterData = imageViewData {
             posterPlaceImage.image = UIImage(data: posterData)
        }

    }
}
