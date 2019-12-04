//
//  SearchIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import SDWebImage

class SearchIngredientViewController: UIViewController {
    
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
}

extension SearchIngredientViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.75, height: collectionView.frame.width/2.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
        //return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        title.textColor = UIColor.black
        title.text = "T"
        title.textAlignment = .center
        cell.contentView.addSubview(title)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 8
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: cell.bounds.size.width, height: 100))
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.sd_setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f1/2ChocolateChipCookies.jpg"))
        cell.contentView.addSubview(imageView)
        
        
        return cell
    }
    
}

 
