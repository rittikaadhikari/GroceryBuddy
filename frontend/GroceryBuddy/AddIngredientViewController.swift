//
//  AddIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class AddIngredientViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add to Grocery List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onDone))
        
        form +++ Section("Ingredient")
            <<< TextRow("IngredientTag"){ row in
                row.title = "Ingredient Name"
                row.placeholder = "Enter text here"
            }
            <<< ActionSheetRow<String>("IngredientCat"){ row in
                    row.title = "Select a Category"
                    row.selectorTitle = "Select a Category"
                    row.options = ["Meat", "Vegetables", "Fruit", "Dairy", "Cheese", "Seafood"]
            }
            +++ Section("Metadata")
            <<< DateRow(){
                $0.title = "Date"
                $0.value = Date(timeIntervalSinceNow: 0)
        }
    }
    
    func postRequest(ingredientName: String) {
        let url = "http://3.228.111.41/list"

        let parameters = [
            "username": "bobrosspaints",
            "ingredient": ingredientName
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func onDone() {
        let valuesDictionary = form.values()
        let ingredientName = valuesDictionary["IngredientTag"]
        if let ingredientName = ingredientName as! String? {
            print(ingredientName)
            postRequest(ingredientName: ingredientName)
        }
    }
}
