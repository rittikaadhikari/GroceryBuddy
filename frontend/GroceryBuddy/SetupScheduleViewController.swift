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
import SwiftyJSON

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
    
    func postRequest(week: Int, time_avail: Int, num_meals: Int, completionHandler: @escaping (Int?) -> ()) {
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
                completionHandler(week)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRequest(week: Int, completionHandler: @escaping ((names: [String]?, imageLinks: [String]?, stepsList: [String]?, ingredientList: [String]?)) -> ()) {
        let url = "http://3.228.111.41/mealschedules?username=" + username + "&week=" + String(week)
        print(url)
        
        AF.request(url, method: .get, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.value)
                var names = [String]()
                var imageLinks = [String]()
                var stepsList = [String]()
                var ingredientList = [String]()
                if let result = json["result"].dictionary, let recipes_main = result["result"]?.array {
                    for item in recipes_main {
                        if let name = item["recipe"]["title"].string, let imageLink = item["recipe"]["image"].string, let steps = item["recipe"]["instructions"].string, let ingredient = item["recipe"]["ingredients"].array {
                            names.append(name)
                            imageLinks.append(imageLink)
                            stepsList.append(steps)
                            var ingredients = ""
                            for ingred in ingredient {
                                ingredients += ingred.string! + "\n"
                            }
                            ingredientList.append(ingredients)
                        }
                    }
                }
                completionHandler((names as? [String], imageLinks as? [String], stepsList as? [String], ingredientList as? [String]))
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
                postRequest(week: week, time_avail: time_avail, num_meals: num_meals) { (result) in
                    let searchController = SearchIngredientViewController()
                    self.getRequest(week: week) { (result) in
                        searchController.recipeNames = result.names!
                        searchController.recipeImages = result.imageLinks!
                        searchController.recipeSteps = result.stepsList!
                        searchController.recipeIngredients = result.ingredientList!
                        searchController.justBrowsing = false
                        searchController.week = week
                        searchController.username = self.username
                        self.navigationController?.pushViewController(searchController, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Missing items", message: "Please enter preference information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
