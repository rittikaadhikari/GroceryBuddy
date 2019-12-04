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
    
    var username:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search By Category"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(onSearch))
        
        form +++ Section("Ingredient Category")
            <<< ActionSheetRow<String>("IngredientTag"){ row in
                row.title = "Select a Category"
                row.selectorTitle = "Select a Category"
                row.options = ["Meat", "Vegetables", "Fruit", "Dairy", "Cheese", "Seafood"]
        }
    }
    
    @objc func onSearch() {
        let valuesDictionary = form.values()
        let ingredientCat = valuesDictionary["IngredientTag"]
        if let ingredientCat = ingredientCat as! String? {
            print(ingredientCat)
        }
    }
}
