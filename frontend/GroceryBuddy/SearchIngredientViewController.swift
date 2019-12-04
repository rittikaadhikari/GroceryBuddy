//
//  SearchIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class SearchIngredientViewController: UIViewController {
    
    var username:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Browse Recipes"
        self.view.backgroundColor = .white
    }
}
