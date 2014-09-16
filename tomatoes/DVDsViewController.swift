//
//  DVDsViewController.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/15/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: NSArray?
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    func loadDVDs(sender: AnyObject) {
        refreshControl.endRefreshing()
        // clear list
        movies = []
        tableView!.reloadData()
        // show loading indicator
        MMProgressHUD.showWithStatus("Loading...")
        moviesModel.listMovies("dvds", doneLoad)
    }

    func doneLoad(error: NSError?, data: NSArray?) {
        MMProgressHUD.dismiss()
        if let gotError = error {
//TODO
//            noticeLabel.text = "Network Error"
//            noticeLabel.hidden = false
            return
        }
        if data != nil {
            self.movies = data
            self.tableView!.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string:"pull to refresh")
        refreshControl.addTarget(self, action: "loadDVDs:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        loadDVDs(self)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movie = movies?[indexPath.row] as NSDictionary
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        cell.movieID            = (movie["id"] as String).toInt()
        cell.titleView.text     = movie["title"] as? String ?? "..."
        cell.synopsisView.text  = movie["synopsis"] as? String ?? "..."
        var thumbURL = (movie["posters"] as [String: String])["thumbnail"]
        cell.posterView.setImageWithURL(NSURL(string: thumbURL!))
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
        var cell = sender as MovieCell
        var movieDetail = segue?.destinationViewController as MovieDetailViewController
        movieDetail.movieID = cell.movieID
    }
}
