//
//  HomeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 11/26/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    var username:String = ""
    var viewsSet:Bool = false
    
    func createViews() {
        let userController = UserViewController()
        userController.username = username

        let navigationController2 = UINavigationController()
        let addController = AddIngredientViewController()
        addController.username = username
        addController.isFridge = false
        navigationController2.pushViewController(addController, animated: false)
        
        let navigationController4 = UINavigationController()
        let addControllerFridge = AddIngredientViewController()
        addControllerFridge.username = username
        addControllerFridge.isFridge = true
        navigationController4.pushViewController(addControllerFridge, animated: false)

        let navigationController3 = UINavigationController()
        let searchController = SearchIngredientViewController()
        searchController.username = username
        navigationController3.pushViewController(searchController, animated: false)

        self.viewControllers = [userController, navigationController2, navigationController4, navigationController3]

        let userItem = UITabBarItem()
        userItem.image = UIImage(named: "Profile")
        userItem.title = "User"
        userController.tabBarItem = userItem

        let plusItem = UITabBarItem()
        plusItem.image = UIImage(named: "Plus")
        plusItem.title = "Add to Grocery List"
        navigationController2.tabBarItem = plusItem
        
        let plusItem2 = UITabBarItem()
        plusItem2.image = UIImage(named: "Plus")
        plusItem2.title = "Add to Fridge"
        navigationController4.tabBarItem = plusItem2

        let searchItem = UITabBarItem()
        searchItem.image = UIImage(named: "Search")
        searchItem.title = "Search Ingredients"
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
