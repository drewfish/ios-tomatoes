//
//  extensions.swift
//  tomatoes
//
//  Created by Andrew Folta on 9/11/14.
//  Copyright (c) 2014 Andrew Folta. All rights reserved.
//

import UIKit


extension UIView {

    // expose movies model to all views
    var moviesModel: MoviesModel {
        return (UIApplication.sharedApplication().delegate as AppDelegate).moviesModel
    }

}


extension UIViewController {

    // expose settings model to all view controllers
    var moviesModel: MoviesModel {
        return (UIApplication.sharedApplication().delegate as AppDelegate).moviesModel
    }

}

