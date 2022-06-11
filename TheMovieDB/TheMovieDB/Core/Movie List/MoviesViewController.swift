//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 9/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: - Variables -
    
    var movies: [Movie] = []
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        movieSearchBar.delegate = self
        
        loadMovies()
    }
    
    // MARK: - UI Methods -
    
    private func loadMovies() {
        let searchText = movieSearchBar.text ?? ""
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            MovieAPICaller.shared.fetchMovies(withQuery: searchText) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(_):
                        self.showAlert(withTitle: "Error", message: "Couldn't fetch any movies for that title.")
                    case .success(let movies):
                        self.movies = movies
                        self.moviesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Supporting Methods -
    
    private func showAlert(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }
    
    // MARK: - Navigation -
    
    @IBSegueAction func seeMovieDetail(_ coder: NSCoder) -> MovieDetailViewController? {
        if let selectedIndexPath = moviesTableView.indexPathForSelectedRow {
            let movie = movies[selectedIndexPath.row]
            moviesTableView.deselectRow(at: selectedIndexPath, animated: true)
            return MovieDetailViewController(coder: coder, movie: movie)
        }
        
        return nil
    }
}

// MARK: - TableView data source -

extension MoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movieForCell = movies[indexPath.row]
        cell.configure(with: movieForCell)
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - SearchBar delegate -

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadMovies()
        view.endEditing(true)
    }
}
