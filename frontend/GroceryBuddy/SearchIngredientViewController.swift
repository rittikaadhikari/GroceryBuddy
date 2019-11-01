//
//  SearchIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Eureka

class SearchIngredientViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search Ingredients"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(onSearch))
        
        form +++ Section("Section1")
            <<< TextRow("IngredientTag"){ row in
                row.title = "Ingredient Name"
                row.placeholder = "Enter text here"
        }
    }
    
    @objc func onSearch() {
        let valuesDictionary = form.values()
        let ingredientName = valuesDictionary["IngredientTag"]
        if let ingredientName = ingredientName as! String? {
            print(ingredientName)
        }
    }
}
