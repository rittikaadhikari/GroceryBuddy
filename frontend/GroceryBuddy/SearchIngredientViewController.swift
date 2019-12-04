//
//  SearchIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class SearchIngredientViewController: UIViewController {
    
    var recipeNames = [String]()
    var recipeImages = [String]()
    var recipeSteps = [String]()
    var justBrowsing:Bool = true
    var week:Int = 1
    var username:String = ""
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top:10, left: 32, bottom: 10, right: 32)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Browse Recipes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(onRefresh))

        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        self.view.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive=true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive=true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant: 0).isActive=true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive=true
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    func getRequestBrowsing(completionHandler: @escaping ((names: [String]?, imageLinks: [String]?)) -> ()) {
        let url = "http://3.228.111.41/recipes"
        
        AF.request(url, method: .get, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.value)
                var names = [String]()
                var imageLinks = [String]()
                if let result = json["result"].dictionary, let recipes_main = result["result"]?.array {
                    for item in recipes_main {
                        if let name = item["recipe"]["title"].string, let imageLink = item["recipe"]["image"].string {
                            names.append(name)
                            imageLinks.append(imageLink)
                        }
                    }
                }
                completionHandler((names as? [String], imageLinks as? [String]))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRequestSchedule(week: Int, completionHandler: @escaping ((names: [String]?, imageLinks: [String]?)) -> ()) {
        let url = "http://3.228.111.41/refreshschedule"
        
        AF.request(url, method: .get, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.value)
                var names = [String]()
                var imageLinks = [String]()
                if let result = json["result"].dictionary, let recipes_main = result["result"]?.array {
                    for item in recipes_main {
                        if let name = item["recipe"]["title"].string, let imageLink = item["recipe"]["image"].string {
                            names.append(name)
                            imageLinks.append(imageLink)
                        }
                    }
                }
                completionHandler((names as? [String], imageLinks as? [String]))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func onRefresh() {
        if justBrowsing {
            getRequestBrowsing { (result) in
                self.recipeNames = result.names!
                self.recipeImages = result.imageLinks!
                self.collectionView.reloadData()
            }
        } else {
            getRequestSchedule(week: week) { (result) in
                self.recipeNames = result.names!
                self.recipeImages = result.imageLinks!
                self.collectionView.reloadData()
            }
        }
    }
}

extension SearchIngredientViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.75, height: collectionView.frame.width/2.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 15, width: cell.bounds.size.width, height: 20))
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        title.textColor = UIColor.black
        title.text = recipeNames[indexPath.row]
        title.textAlignment = .center
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        
        for v in cell.subviews {
            if v.isKind(of: UILabel.self) {
                v.removeFromSuperview()
            } else if v.isKind(of: UIImageView.self) {
                v.removeFromSuperview()
            }
        }
        cell.addSubview(title)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 8
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: cell.bounds.size.width, height: 100))
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.sd_setImage(with: URL(string: recipeImages[indexPath.row]))
        cell.addSubview(imageView)
        
        return cell
    }
    
}

 
