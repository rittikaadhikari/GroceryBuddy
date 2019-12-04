//
//  SetupScheduleViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 12/3/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class SetupScheduleViewController: FormViewController {

    var username:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Setup Schedule Preferences"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onSetup))
        
        form +++ Section("Preferences")
            <<< IntRow("WeekTag"){ row in
                row.title = "Week"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
            <<< IntRow("TimeTag"){ row in
                row.title = "Time Available"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
            <<< IntRow("NumMealsTag"){ row in
                row.title = "Number of Meals"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
    }
    
    func postRequest(week: Int, time_avail: Int, num_meals: Int) {
        let url = "http://3.228.111.41/schedule"

        let parameters = [
            "username": username,
            "week": week,
            "time_available": time_avail,
            "num_meals": num_meals
            ] as [String : Any]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRequest(week: Int, completionHandler: @escaping ([String]?) -> ()) {
        let url = "http://3.228.111.41/schedule"
        
        let parameters = [
            "username": username,
            "week": week
            ] as [String : Any]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                guard let json = response.value as? [String: Any] else {
                  print("didn't get object as JSON from API")
                  if let error = response.error {
                    print("Error: \(error)")
                  }
                  return
                }
                print(json)
                guard let result = json["result"] as? [String: Any], let userIngredients = result["user_ingredients"] as? [String] else {
                  print("Could not get user ingredients from JSON")
                  completionHandler([] as? [String])
                  return
                }
                print(userIngredients)
                completionHandler(userIngredients as? [String])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func onSetup() {
        let validationErrors = form.validate()
        if validationErrors.isEmpty {
            let valuesDictionary = form.values()
            let week = valuesDictionary["WeekTag"]
            let time_avail = valuesDictionary["TimeTag"]
            let num_meals = valuesDictionary["NumMealsTag"]
            if let week = week as! Int?,
                let time_avail = time_avail as! Int?,
                let num_meals = num_meals as! Int? {
                postRequest(week: week, time_avail: time_avail, num_meals: num_meals)
                
                let ingredientsTable = SearchIngredientViewController()
//                getRequest(week: week, completionHandler: { (result) in
//                    ingredientsTable.recipes = result!
//                    self.navigationController?.pushViewController(ingredientsTable, animated: true)
//                })
            }
        } else {
            let alert = UIAlertController(title: "Missing items", message: "Please enter preference information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
