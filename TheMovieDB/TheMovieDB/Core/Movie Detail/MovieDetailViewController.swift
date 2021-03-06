//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var adultContentLabel: UILabel!
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
    
    /// Initializes the starting state of the UI.
    private func setUpUI() {
        setHeaderViewBase()
        
        loadMovieImage()

        imageActivityIndicator.hidesWhenStopped = true
        
        movieTitleLabel.text = movie.title
        movieReleaseDateLabel.text = movie.releaseDate ?? "NaN"
        adultContentLabel.text = movie.adultContent ? "Yes" : "No"
        voteAverageLabel.text = "\(movie.voteAverage)"
        movieOverviewLabel.text = movie.overview
    }
    
    /// Sets up the header view style.
    private func setHeaderViewBase() {
        headerView.layer.masksToBounds = false
        headerView.clipsToBounds = false
        headerView.layer.shadowRadius = 2
        headerView.layer.shadowOpacity = 0.7
        headerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        headerView.layer.shadowColor = UIColor.gray.cgColor
    }
    
    /// Handles the activity indicator visibility and motion.
    /// isHidden: if true, stops the animation and hides the indicator. If false, starts the animation and shows up the indicator.
    private func manageImageActivityIndicator(isHidden: Bool) {
        imageActivityIndicator.isHidden = isHidden
        if isHidden {
            imageActivityIndicator.stopAnimating()
        } else {
            imageActivityIndicator.startAnimating()
        }
    }
    
    /// Fetches de movie image and updates it in the UI.
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
