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
    
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables -
    
    var results: [MoviesResult] = []
    var movies: [Movie] { getMoviesFromResults() }
    
    private var canLoadMoreMovies = false
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        movieSearchBar.delegate = self
        
        setUpUI()
    }
    
    // MARK: - UI Methods -
    
    /// Initializes the starting state of the UI.
    private func setUpUI() {
        moviesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Loading container view
        loadingActivityIndicator.hidesWhenStopped = true
        loadingContainerView.layer.cornerRadius = 10
        loadingContainerView.isHidden = true
        
        // No movies are shown at first (no query text entered), so the user can't load more movies.
        canLoadMoreMovies = false
    }
    
    /// Maps the results collection to get a whole list of requested movies.
    private func getMoviesFromResults() -> [Movie] {
        var movies = [Movie]()
        for result in results {
            movies += result.movies
        }
        return movies
    }
    
    /// Loads a list of movies in a given page.
    /// paginated: if true, a higher page is requested every time. If false, the first page is requested.
    private func loadMovies(paginated: Bool = false) {
        // When loading more movies, the user can't load any more until he sees the new fetched ones.
        canLoadMoreMovies = false
        
        if paginated == false {
            results = []
        }
        
        let searchText = movieSearchBar.text ?? ""
        self.manageLoadingContainerView(isLoading: true)
        
        // Get the current maximum requested page to request the movies from the next page.
        var page = Constants.kAPIMoviePagesRange.lowerBound
        if let currentMaxPage = getMaxPageFromResults() {
            page = currentMaxPage + 1
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            MovieAPICaller.shared.fetchMovies(withQuery: searchText, page: page) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self.handleMovieFetchError(error)
                    case .success(let newResult):
                        self.reloadTableViewData(with: newResult)
                    }

                    self.manageLoadingContainerView(isLoading: false)
                }
            }
        }
    }
    
    /// Reloads the table view data with some animation.
    /// newResult: the new movies to represent in the table view.
    private func reloadTableViewData(with newResult: MoviesResult) {
        let currentNumberOfRows = self.movies.count
        results.append(newResult)
        
        let newNumberOfRows = newResult.movies.count + currentNumberOfRows
        let indexPathRange = currentNumberOfRows...newNumberOfRows-1
        let indexPaths = indexPathRange.map { IndexPath(row: $0, section: 0) }
        
        moviesTableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    ///  Handles de loading view visibility:
    ///  isLoading: if true, the view is shown. If false, it's hidden.
    private func manageLoadingContainerView(isLoading: Bool) {
        // Hidden when not loading anything.
        loadingContainerView.isHidden = !isLoading
        if isLoading {
            loadingActivityIndicator.startAnimating()
        } else {
            loadingActivityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Supporting Methods -
    
    /// Show a custom alert, depending on the error:
    /// error: the error to represent in the alert.
    private func handleMovieFetchError(_ error: Error) {
        let alertTitle = "Error"
        var alertMessage = ""
        
        if let error = error as? APIFetchError {
            alertMessage = error.description
        } else {
            alertMessage = error.localizedDescription
        }
        
        showAlert(withTitle: alertTitle, message: alertMessage)
    }
    
    /// Show an alert:
    /// title: the alert title.
    /// message: the alert message.
    private func showAlert(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }
    
    /// Gets the maximum requested movies page.
    private func getMaxPageFromResults() -> Int? {
        var maxPage: Int?
        for result in results {
            maxPage = (maxPage == nil) ? result.page : max(result.page, maxPage!)
        }
        return maxPage
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

// MARK: - TableView delegate -

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        
        // If the user has scrolled to the bottom of the table view, let them load more movies (if available).
        if (distanceFromBottom <= scrollViewHeight) && movies.isEmpty == false {
            canLoadMoreMovies = true
        } else {
            canLoadMoreMovies = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // If the user has scrolled to the bottom of the page (canLoadMoreMovies becomes true whenever he does this), load more movies (paginated).
        // Then, automatically scroll some pixels so that the user can realize more movies have been loaded.
        if canLoadMoreMovies {
            loadMovies(paginated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                scrollView.contentOffset.y += 100
            }
        }
    }
}

// MARK: - SearchBar delegate -

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadMovies()
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if results.isEmpty == false {
            results.removeAll()
            moviesTableView.reloadData()
        }
    }
}
