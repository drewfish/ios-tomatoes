//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/10/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import UIKit


class MoviesCellDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    let name: String                        // for debugging
    var movies: NSArray?                    // movies to show
    weak var loader: UIViewController?      // who can load more movies
    weak var cellSource: UITableView?       // who can generate cells
    weak var tableView: UITableView?        // who can display cells
    var refreshControl: UIRefreshControl

    init(name: String, loader: UIViewController, cellSource: UITableView, tableView: UITableView) {
        self.name = name
        self.movies = []
        self.loader = loader
        self.cellSource = cellSource
        self.tableView = tableView
        refreshControl = UIRefreshControl()

        super.init()

        self.tableView!.delegate = self
        self.tableView!.dataSource = self

        refreshControl.attributedTitle = NSAttributedString(string:"pull to refresh")
        // this "loader" approach is messy/hacky :(
        refreshControl.addTarget(loader, action: "loadData:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        // style search results table
        if tableView !== cellSource {
            tableView.rowHeight = cellSource.rowHeight
            tableView.backgroundColor = cellSource.backgroundColor
            tableView.separatorStyle = cellSource.separatorStyle
            tableView.separatorColor = cellSource.separatorColor
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movie = movies?[indexPath.row] as NSDictionary
        var cell = self.cellSource!.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        cell.movieID            = (movie["id"] as String).toInt()
        cell.titleView.text     = movie["title"] as? String ?? "..."
        cell.synopsisView.text  = movie["synopsis"] as? String ?? "..."
        var thumbURL = (movie["posters"] as [String: String])["thumbnail"]
        cell.posterView.setImageWithURL(NSURL(string: thumbURL!))
        return cell
    }
}


class MoviesViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    var searchTerm: String?
    var listMoviesDelegate: MoviesCellDelegate?
    var searchMoviesDelegate: MoviesCellDelegate?
    var currentMoviesDelegate: MoviesCellDelegate?

    @IBOutlet weak var moviesView: UITableView!
    @IBOutlet weak var noticeLabel: UILabel!

    func loadData(sender: AnyObject) {
        noticeLabel.hidden = true
        // clear list
        currentMoviesDelegate!.movies = []
        currentMoviesDelegate!.tableView!.reloadData()
        currentMoviesDelegate!.refreshControl.endRefreshing()
        // show loading indicator
        MMProgressHUD.showWithStatus("Loading...")

        if let gotSearchTerm = searchTerm {
            moviesModel.seachMovies(gotSearchTerm, doneLoad)
        }
        else {
            moviesModel.listMovies("movies", doneLoad)
        }
    }

    func doneLoad(error: NSError?, data: NSArray?) {
        MMProgressHUD.dismiss()
        if let gotError = error {
            noticeLabel.text = "Network Error"
            noticeLabel.hidden = false
            return
        }
        if data != nil {
            self.currentMoviesDelegate!.movies = data
            self.currentMoviesDelegate!.tableView!.reloadData()
        }
    }

    func listMovies() {
        searchTerm = nil
        loadData(self)
    }

    func searchMovies(search: String) {
        searchTerm = search
        loadData(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listMoviesDelegate = MoviesCellDelegate(name: "list", loader: self, cellSource: moviesView, tableView: moviesView)
        searchMoviesDelegate = MoviesCellDelegate(name: "search", loader: self, cellSource: moviesView, tableView: self.searchDisplayController!.searchResultsTableView)
        currentMoviesDelegate = listMoviesDelegate
        listMovies()
    }

    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {
        searchTerm = nil
        searchMoviesDelegate!.movies = []
        currentMoviesDelegate = searchMoviesDelegate
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchMovies(searchBar.text)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchTerm = nil
        currentMoviesDelegate = listMoviesDelegate
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
        var cell = sender as MovieCell
        var movieDetail = segue?.destinationViewController as MovieDetailViewController
        movieDetail.movieID = cell.movieID
    }
}
