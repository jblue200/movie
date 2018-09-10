//
//  ConnectivityViewController.swift
//  movie
//
//  Created by May Shi on 9/10/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class ConnectivityViewController: UIViewController {

    var tmdb:TMDBMovie = TMDBMovie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("showing connectivity view controller")
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let scheme:String = UIApplicationOpenSettingsURLString
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }

}
