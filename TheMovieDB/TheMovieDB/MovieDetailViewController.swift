//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    
    let movieTitle: String
    
    init?(coder: NSCoder, movieTitle: String) {
        self.movieTitle = movieTitle
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        movieTitleLabel.text = movieTitle
    }
}
