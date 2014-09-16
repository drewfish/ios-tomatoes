//
//  MoviesModel.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/11/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import Foundation


class MoviesModel {
    private let API_KEY = "27przyjyzk4ev7qu784ztd4x"
    private let URLS_LIST_MOVIES = [
        "dvds":     "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json",
        "movies":   "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json"
    ]
    private let URL_SEARCH_MOVIES = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?page_limit=15&page=1"


    func listMovies(type: String, done: (NSError?, NSArray?) -> Void) {
        var url = URLS_LIST_MOVIES[type]
        if url == nil {
            var error = NSError.errorWithDomain("MoviesModel.listMovies", code: 1, userInfo: [
                "reason": "unknown movie type"
            ])
            done(error, nil)
            return
        }

        url = url! + "?apikey=" + API_KEY
        runTomatoQuery(url!, done: {
            (error: NSError?, data: NSDictionary?) in
            done(error, data?["movies"] as? NSArray ?? nil)
        })
    }


    func seachMovies(search: String, done: (NSError?, NSArray?) -> Void) {
        var url = URL_SEARCH_MOVIES
        url += "&q=\(search)"
        url = url + "&apikey=" + API_KEY
        runTomatoQuery(url, done: {
            (error: NSError?, data: NSDictionary?) in
            done(error, data?["movies"] as? NSArray ?? nil)
        })
    }


    private func runTomatoQuery(url: String, done: (NSError?, NSDictionary?) -> Void) {
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error != nil {
                done(error, nil)
                return
            }
            var errorValue: NSError? = nil
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? [String: AnyObject]
            if errorValue != nil {
                done(errorValue, nil)
                return
            }
            done(nil, json)
        })
    }

}

