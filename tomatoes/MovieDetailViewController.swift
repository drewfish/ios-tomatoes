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

    override func viewDidLoad() {
        super.viewDidLoad()
        println("-- viewDidLoad() --movieID \(movieID)")
    }


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
