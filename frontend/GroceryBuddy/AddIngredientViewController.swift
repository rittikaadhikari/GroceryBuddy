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
    
    var username:String = ""
    var isFridge:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add to Grocery List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onDone))
        
        form +++ Section("Ingredient")
            <<< TextRow("IngredientTag"){ row in
                row.title = "Ingredient Name"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< ActionSheetRow<String>("IngredientCat"){ row in
                row.title = "Select a Category"
                row.selectorTitle = "Select a Category"
                row.options = ["Meat", "Vegetables", "Fruit", "Dairy", "Seafood", "Other"]
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< ActionSheetRow<String>("ListCat"){ row in
                row.title = "Add to Where?"
                row.selectorTitle = "Add to Where?"
                row.options = ["Grocery List", "Fridge"]
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            +++ Section("Metadata")
            <<< DateRow(){
                $0.title = "Date"
                $0.value = Date(timeIntervalSinceNow: 0)
        }
    }
    
    func postRequest(ingredientName: String) {
        var url = "http://3.228.111.41/list"
        if isFridge {
            url = "http://3.228.111.41/fridge"
        }

        let parameters = [
            "username": username,
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
        let validationErrors = form.validate()
        if validationErrors.isEmpty {
            let valuesDictionary = form.values()
            let ingredientName = valuesDictionary["IngredientTag"]
            let location = valuesDictionary["ListCat"]
            if let ingredientName = ingredientName as! String?,
                let location = location as! String? {
                if location == "Fridge" {
                    isFridge = true
                } else {
                    isFridge = false
                }
                postRequest(ingredientName: ingredientName)
            }
        } else {
            let alert = UIAlertController(title: "Missing ingredient information", message: "Please enter ingredient information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
