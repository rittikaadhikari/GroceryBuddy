//
//  HomeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 11/26/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UITabBarController {

    var username:String = ""
    var viewsSet:Bool = false
    
    func getRequest(completionHandler: @escaping ((names: [String]?, imageLinks: [String]?)) -> ()) {
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
    
    func createViews() {
        let userController = UserViewController()
        userController.username = username

        let navigationController2 = UINavigationController()
        let addController = AddIngredientViewController()
        addController.username = username
        addController.isFridge = false
        navigationController2.pushViewController(addController, animated: false)

        let navigationController3 = UINavigationController()
        let searchController = SearchIngredientViewController()
        getRequest { (result) in
            searchController.recipeNames = result.names!
            searchController.recipeImages = result.imageLinks!
            print(result.names!)
            print(result.imageLinks!)
        }
        navigationController3.pushViewController(searchController, animated: false)

        self.viewControllers = [userController, navigationController2, navigationController3]

        let userItem = UITabBarItem()
        userItem.image = UIImage(named: "Profile")
        userItem.title = "User"
        userController.tabBarItem = userItem

        let plusItem = UITabBarItem()
        plusItem.image = UIImage(named: "Plus")
        plusItem.title = "Add Ingredient"
        navigationController2.tabBarItem = plusItem

        let searchItem = UITabBarItem()
        searchItem.image = UIImage(named: "Search")
        searchItem.title = "Browse Recipes"
        navigationController3.tabBarItem = searchItem
        
        viewsSet = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !username.isEmpty && !viewsSet {
            createViews()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !username.isEmpty && !viewsSet {
            createViews()
        }
    }
}
