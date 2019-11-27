//
//  HomeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 11/26/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let fridgeController = FridgeViewController()

        let navigationController2 = UINavigationController()
        let addController = AddIngredientViewController()
        navigationController2.pushViewController(addController, animated: false)

        let navigationController3 = UINavigationController()
        let searchController = SearchIngredientViewController()
        navigationController3.pushViewController(searchController, animated: false)

        self.viewControllers = [fridgeController, navigationController2, navigationController3]

        let userItem = UITabBarItem()
        userItem.image = UIImage(named: "Profile")
        userItem.title = "User"
        fridgeController.tabBarItem = userItem

        let plusItem = UITabBarItem()
        plusItem.image = UIImage(named: "Plus")
        plusItem.title = "Add Ingredients"
        navigationController2.tabBarItem = plusItem

        let searchItem = UITabBarItem()
        searchItem.image = UIImage(named: "Search")
        searchItem.title = "Search Ingredients"
        navigationController3.tabBarItem = searchItem
    }
}
