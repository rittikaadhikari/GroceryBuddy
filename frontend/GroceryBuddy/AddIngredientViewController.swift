//
//  AddIngredientViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Eureka

class AddIngredientViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add to Grocery List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onDone))
        
        form +++ Section("Section1")
            <<< TextRow("IngredientTag"){ row in
                row.title = "Ingredient Name"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Ingredient Category"
                $0.placeholder = "Set category here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date"
                $0.value = Date(timeIntervalSinceNow: 0)
        }
    }
    
    @objc func onDone() {
        let valuesDictionary = form.values()
        let ingredientName = valuesDictionary["IngredientTag"]
        if let ingredientName = ingredientName as! String? {
            print(ingredientName)
        }
    }
}
