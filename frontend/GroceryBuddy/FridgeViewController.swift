//
//  FridgeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class FridgeViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 50))
        label.text = "Grocery Buddy"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        return label
    }()
    
    lazy var itemsButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.frame = CGRect(x: 0, y: 170, width: view.frame.size.width, height: 50)
        button.setTitle("View Grocery List", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.addTarget(self, action: #selector(listButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addItemButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.frame = CGRect(x: 0, y: 300, width: view.frame.size.width, height: 50)
        button.setTitle("Add New Item", for: .normal)
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(itemsButton)
        //    self.view.addSubview(addItemButton)
    }
    
    @objc func listButtonAction(sender: UIButton!) {
        let ingredientsTable = IngredientTableViewController()
        ingredientsTable.ingredients = ["Bacon", "Eggs"]
        navigationController?.pushViewController(ingredientsTable, animated: true)
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        navigationController?.pushViewController(UITableViewController(), animated: true)
    }
}
