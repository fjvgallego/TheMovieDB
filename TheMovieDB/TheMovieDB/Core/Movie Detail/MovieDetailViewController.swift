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
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
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
    
    // MARK: - UI Methods -
    
    private func setUpUI() {
        loadMovieImage()

        imageActivityIndicator.hidesWhenStopped = true
        
        movieTitleLabel.text = movie.title
        voteAverageLabel.text = "\(movie.voteAverage)"
        
        movieOverviewLabel.text = movie.overview
    }
    
    private func manageImageActivityIndicator(isHidden: Bool) {
        imageActivityIndicator.isHidden = isHidden
        if isHidden {
            imageActivityIndicator.stopAnimating()
        } else {
            imageActivityIndicator.startAnimating()
        }
    }
    
    private func loadMovieImage() {
        // Check if the movie owns a poster path.
        if let posterPath = movie.posterPath {
            
            // While the image is trying to be fetched, show a loading indicator.
            manageImageActivityIndicator(isHidden: false)
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                // Start fetching the image.
                ImageAPICaller.shared.fetchImage(withPath: posterPath) { result in
                    DispatchQueue.main.async {
                        var image: UIImage?
                        
                        switch result {
                        case .failure(_): image = nil
                        case .success(let imageData):
                            image = UIImage(data: imageData)
                        }
                        
                        // If the image can be loaded, show it. Otherwise, show a placeholder (from assets).
                        if let image = image {
                            self.movieImage.image = image
                        } else {
                            self.movieImage.image = UIImage(named: Constants.kDefaultMovieImageName)
                        }
                        
                        // Hide the loading indicator, since the image is already loaded.
                        self.manageImageActivityIndicator(isHidden: true)
                    }
                }
            }
        } else {
            // If the image doesn't own a poster path, show a placeholder (from assets).
            movieImage.image = UIImage(named: Constants.kDefaultMovieImageName)
        }
    }
}
