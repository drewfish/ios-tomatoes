//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/10/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import UIKit


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var moviesView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var noticeLabel: UILabel!
    var movies: NSArray?

    func startLoad() {
        // clear list
        movies = []
        moviesView.reloadData()
        // show loading indicator
        MMProgressHUD.showWithStatus("Loading...")
    }

    func doneLoad(error: NSError?, data: NSArray?) {
        MMProgressHUD.dismiss()
        if let gotError = error {
            noticeLabel.text = "Network Error"
            noticeLabel.hidden = false
            return
        }
        if data != nil {
            self.movies = data
            self.moviesView.reloadData()
        }
    }

    func listMovies() {
        startLoad()
        moviesModel.listMovies("movies", doneLoad)
    }

    func searchMovies(search: String) {
        startLoad()
        moviesModel.seachMovies(search, doneLoad)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesView.delegate = self
        moviesView.dataSource = self
        searchView.delegate = self
        listMovies()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movie = movies?[indexPath.row] as NSDictionary
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        cell.movieID = (movie["id"] as String).toInt()
        cell.titleView.text = movie["title"] as? String ?? "..."
        cell.synopsisView.text = movie["synopsis"] as? String ?? "..."
        var thumbURL = (movie["posters"] as [String: String])["thumbnail"]
        cell.posterView.setImageWithURL(NSURL(string: thumbURL!))
        return cell
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchMovies(searchBar.text)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        listMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
        var cell = sender as MovieCell
        var movieDetail = segue?.destinationViewController as MovieDetailViewController
        movieDetail.movieID = cell.movieID
    }

}
