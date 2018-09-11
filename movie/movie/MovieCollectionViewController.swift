//
//  MovieCollectionViewController.swift
//  movie
//
//  Created by May Shi on 9/4/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieCell"
private let refreshControl = UIRefreshControl()

class MovieCollectionViewController: UICollectionViewController {
    
    var tmdb:TMDBMovie!
    var networkManager:NetworkManager!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.clearsSelectionOnViewWillAppear = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.setItemWidth(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addRefreshControl()

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdb.movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        clearSubview(subviews: cell.contentView.subviews) // clear subviews
        
        let movie = tmdb.movies[indexPath.item]
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.25, green:0.5, blue:1, alpha:0.1)
        } else {
            cell.backgroundColor = UIColor.white
        }

        // add poster
        let poster:UIImageView = getImage(posterPath: movie.poster_path)
        cell.contentView.addSubview(poster)
        
        // add label
        let detail:UILabel = createDetail(index: indexPath.item, title: movie.title, rating: movie.vote_average, releaseDate: movie.release_date)
        cell.contentView.addSubview(detail)
        cell.contentView.tag = indexPath.item
        
        let gesture = MyTapGesture.init(target: self, action: #selector(self.displayDetailPage))
        gesture.index = indexPath.item
        cell.contentView.addGestureRecognizer(gesture)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // check to see if it is the last row
        if indexPath.row == tmdb.movies.count - 1 && networkManager.isConnected() {
            tmdb.getNextPage(completion: updateLayout)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateLayout()
    }
    
    func updateLayout() {
        super.viewDidLayoutSubviews()
        self.collectionViewLayout.invalidateLayout()
        self.collectionView!.reloadData()
    }

    func clearSubview(subviews: [UIView]) {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    func createDetail(index: Int, title: String, rating: Float, releaseDate: String) -> UILabel {
        let label:UILabel = UILabel(frame: CGRect(x:10, y: 110, width: getWidth() - 20, height:20))
        label.text = title + " " + releaseDate + " (" + String(rating) + ")"
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "System", size: 17.0)
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func getImage(posterPath: String) -> UIImageView {
        let imageUrlString = "https://image.tmdb.org/t/p/w154" + posterPath
        let imageUrl:URL = URL(string: imageUrlString)!
        let imageView = UIImageView(frame: CGRect(x:0, y:8, width:getWidth(), height:100))
        
        if let imageData:NSData = NSData(contentsOf: imageUrl) {
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    imageView.image = image
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
        }
        return imageView
    }
    
    func addRefreshControl() {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.25, green:0.72, blue:1, alpha:1.0)]
        
        if #available(iOS 10.0, *) {
            collectionView!.refreshControl = refreshControl
        } else {
            collectionView!.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshPage(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:1, alpha:0.4)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Movies ...", attributes: attributes)
    }
    
    func refreshCompleted() {
        self.updateLayout()
        DispatchQueue.main.async {
            self.collectionView!.refreshControl?.endRefreshing()
        }
    }
    
    @objc func setItemWidth(_ sender: Any) {
        layout.itemSize = CGSize(width: getWidth(), height: 130)
    }
    
    @objc func refreshPage(_ sender: Any) {
        if networkManager.isConnected() {
            tmdb.refreshPage(completion: refreshCompleted)
        } else {
            self.performSegue(withIdentifier: "movieToConnectivity", sender: self)
        }
    }
    
    @objc func displayDetailPage(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.performSegue(withIdentifier: "movieToDetail", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectivityVC = segue.destination as? ConnectivityViewController {
            connectivityVC.networkManager = self.networkManager
        }
        
        if let detailVC = segue.destination as? DetailViewController {
            // detailVC.movie = tmdb.movies[sender.contentView.tag]
        }
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var index: Int = 0
}
