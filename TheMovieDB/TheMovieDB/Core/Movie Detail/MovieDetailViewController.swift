//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // MARK: - Variables -
    
    let movie: Movie
    
    // MARK: - Initializers -
    
    init?(coder: NSCoder, movie: Movie) {
        self.movie = movie
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    // MARK: - Supporting Methods -
    
    func setUpUI() {
        // TODO: Animate the activity indicator while the image is loading.
        imageActivityIndicator.startAnimating()
        imageActivityIndicator.hidesWhenStopped = true
        
        movieTitleLabel.text = movie.title
        voteAverageLabel.text = "\(movie.voteAverage)"
        
        movieDescriptionLabel.text = movie.description
    }
}
