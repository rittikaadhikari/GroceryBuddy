//
//  FridgeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func getRequest(completionHandler: @escaping ([String]?) -> ()) {
        let url = "http://3.228.111.41/list/bobrosspaints"
        
        AF.request(url, method: .get, encoding: URLEncoding.default).responseJSON { response in
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
                  return
                }
                print(userIngredients)
                completionHandler(userIngredients as? [String])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func listButtonAction(sender: UIButton!) {
        let ingredientsTable = IngredientTableViewController()
        getRequest { (result) in
            ingredientsTable.ingredients = result!
            self.navigationController?.pushViewController(ingredientsTable, animated: true)
        }
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        navigationController?.pushViewController(UITableViewController(), animated: true)
    }
}
