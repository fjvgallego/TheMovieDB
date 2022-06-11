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
    
    private func setCellBaseShape() {
        cellBaseView.layer.masksToBounds = false
        cellBaseView.clipsToBounds = false
        
        cellBaseView.layer.cornerRadius = 15
        cellBaseView.layer.shadowColor = UIColor.gray.cgColor
        cellBaseView.layer.shadowOpacity = 0.7
        cellBaseView.layer.shadowOffset = CGSize(width: 3, height: 2)
        cellBaseView.layer.shadowRadius = 5
    }
    
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
        
        // Movie vote average.
        updateUI(forVoteAvg: movie.voteAverage)
    }
    
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
    
    private func updateUI(forVoteAvg voteAvg: Double) {
        // Vote quantity.
        movieVoteAverageLabel.text = "\(voteAvg)"
        movieVoteAverageLabel.textColor = .white
        
        // Vote symbol (star).
        movieVoteSymbol.tintColor = .white
        
        // Vote background view.
        movieVoteAverageView.layer.cornerRadius = 15
        movieVoteAverageView.backgroundColor = getColor(for: voteAvg)
    }
    
    private func getColor(for voteAvg: Double) -> UIColor {
        switch voteAvg {
        case 0..<4: return .systemRed
        case 4..<6: return .systemOrange
        case 6...10: return .systemGreen
        default: return .systemBlue
        }
    }
}
