//
//  MovieDetailViewController.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/14/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieID: Int!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var synopsisView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "..."
        MMProgressHUD.showWithStatus("Loading...")
        moviesModel.getMovie(movieID, {
            (error: NSError?, data: NSDictionary?) in
            // TODO -- don't dismiss the spinner until image loads
            MMProgressHUD.dismiss()
            if let gotError = error {
                self.navigationItem.title = "error loading movie"
                return
            }
            if data != nil {
                var title = data!["title"] as String
                self.navigationItem.title = title
                self.titleLabel.text = title
                var ratings = data!["ratings"] as NSDictionary
                var criticsScore = ratings["critics_score"] as? Int ?? 0
                var audienceScore = ratings["audience_score"] as? Int ?? 0
                self.scoreLabel.text = "Critics Score: \(criticsScore), Audience Score: \(audienceScore)"
                self.synopsisView.text = data!["synopsis"] as? String
                // for some reason the UITextView isn't using its text color
                self.synopsisView.textColor = self.titleLabel.textColor
                var posterURL = (data!["posters"] as NSDictionary)["detailed"] as String
                // http://developer.rottentomatoes.com/forum/read/184481
                // This is definitely hacky
                posterURL = posterURL.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_det.jpg")
                self.posterView.setImageWithURL(NSURL(string: posterURL))
            }
        })
    }
}
