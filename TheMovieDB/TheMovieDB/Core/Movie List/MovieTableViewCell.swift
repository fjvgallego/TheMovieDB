//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 10/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var cellBaseView: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var movieVoteAverageView: UIView!
    @IBOutlet weak var movieVoteSymbol: UIImageView!
    @IBOutlet weak var movieVoteAverageLabel: UILabel!
    
    // MARK: - Cell life cycle -

    override func layoutSubviews() {
        setCellBaseShape()
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Methods -
    
    /// Sets up the cell UI style.
    private func setCellBaseShape() {
        cellBaseView.layer.masksToBounds = false
        cellBaseView.clipsToBounds = false
        
        cellBaseView.layer.cornerRadius = 15
        cellBaseView.layer.shadowColor = UIColor.gray.cgColor
        cellBaseView.layer.shadowOpacity = 0.7
        cellBaseView.layer.shadowOffset = CGSize(width: 3, height: 2)
        cellBaseView.layer.shadowRadius = 5
    }
    
    /// Updates the whole cell UI.
    /// movie: the movie to represent in the cell.
    func configure(with movie: Movie) {
        // Movie image.
        if let imagePath = movie.posterPath {
            updateUI(forImagePath: imagePath)
        } else {
            movieImageView.image = UIImage(named: Constants.kDefaultMovieImageName)
        }
        
        // Movie info.
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        movieVoteAverageLabel.text = "\(movie.voteAverage)"
        
        // Movie vote average.
        updateMovieVoteView(forVoteAvg: movie.voteAverage)
    }
    
    /// Fetch the movie image in background and update it in view.
    /// imagePath: the movie image path to request that image.
    private func updateUI(forImagePath imagePath: String) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            ImageAPICaller.shared.fetchImage(withPath: imagePath) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure:
                        self.movieImageView.image = UIImage(named: Constants.kDefaultMovieImageName)
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            self.movieImageView.image = image
                        } else {
                            self.movieImageView.image = UIImage(named: Constants.kDefaultMovieImageName)
                        }
                    }
                }
            }
        }
    }
    
    /// Update the movie rating given its vote average:
    /// voteAvg: the movie vote average.
    private func updateMovieVoteView(forVoteAvg voteAvg: Double) {
        // Vote quantity.
        movieVoteAverageLabel.textColor = .white
        
        // Vote symbol (star).
        movieVoteSymbol.tintColor = .white
        
        // Vote background view.
        movieVoteAverageView.layer.cornerRadius = 15
        movieVoteAverageView.backgroundColor = getColor(for: voteAvg)
    }
    
    /// Returns the appropriate color for a given vote average:
    /// voteAvg: the movie vote average.
    private func getColor(for voteAvg: Double) -> UIColor {
        switch voteAvg {
        case 0..<4: return .systemRed
        case 4..<6: return .systemOrange
        case 6...10: return .systemGreen
        default: return .systemBlue
        }
    }
}
