//
//  ConnectivityViewController.swift
//  movie
//
//  Created by May Shi on 9/10/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class ConnectivityViewController: UIViewController {

    var networkManager: NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        if let url = URL(string:"App-Prefs:root=WIFI") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
