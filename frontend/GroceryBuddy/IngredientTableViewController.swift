//
//  IngredientTableViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Alamofire

class IngredientTableViewController: UITableViewController {
    
    var ingredients = [String]()
    var listItems = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationItem.title = "Grocery List"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        for ingredient in ingredients {
            listItems.append(ListItem(text: ingredient))
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell

        let item = listItems[indexPath.row]
        cell.listItems = item
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func deleteRequest(ingredientName: String) {
        let url = "http://3.228.111.41/list?username=bobrosspaints&ingredient=" + ingredientName
        
        AF.request(url, method: .delete, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let ingredient = ingredients[indexPath.row]
            listItems.remove(at: indexPath.row)
            ingredients.remove(at: indexPath.row)
            deleteRequest(ingredientName: ingredient)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
