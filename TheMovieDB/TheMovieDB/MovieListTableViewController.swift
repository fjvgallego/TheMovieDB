//
//  MovieListTableViewController.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    let movies = ["Movie 1", "Movie 2", "Movie 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Navigation -
    
    @IBSegueAction func seeMovieDetail(_ coder: NSCoder) -> UIViewController? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let movieTitle = movies[selectedIndexPath.row]
            return MovieDetailViewController(coder: coder, movieTitle: movieTitle)
        }
        
        return nil
    }

    // MARK: - Table view data source -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row]
        cell.detailTextLabel?.text = "2022"
        return cell
    }
}
