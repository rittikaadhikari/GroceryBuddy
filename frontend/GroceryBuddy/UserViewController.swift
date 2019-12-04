//
//  FridgeViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController {
    
    var username:String = ""
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 50))
        label.text = "Grocery Buddy"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        return label
    }()
    
    lazy var itemsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 170, width: 220, height: 50))
        button.setTitle("View Grocery List", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(listButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var fridgeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 240, width: 220, height: 50))
        button.setTitle("View Fridge", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(fridgeButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var scheduleButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 310, width: 220, height: 50))
        button.setTitle("View Potential Schedules", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(scheduleButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(itemsButton)
        self.view.addSubview(fridgeButton)
        self.view.addSubview(scheduleButton)
        
        let groceryImage = UIImageView(frame: CGRect(x: 180, y: 500, width: 50, height: 200))
        groceryImage.image = UIImage(named: "GroceryBag")
        groceryImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(groceryImage)
    }
    
    func getRequest(completionHandler: @escaping ([String]?) -> ()) {
        let url = "http://3.228.111.41/list/" + username
        
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
    
    func getRequestFridge(completionHandler: @escaping ([String]?) -> ()) {
        let url = "http://3.228.111.41/fridge/" + username
        
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
                guard let result = json["result"] as? [String: Any], let userIngredients = result["result"] as? [String] else {
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
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        
        let ingredientsTable = IngredientTableViewController()
        ingredientsTable.username = username
        getRequest { (result) in
            ingredientsTable.ingredients = result!
            ingredientsTable.isFridge = false
            self.navigationController?.pushViewController(ingredientsTable, animated: true)
        }
    }
    
    @objc func fridgeButtonAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        
        let ingredientsTable = IngredientTableViewController()
        ingredientsTable.username = username
        getRequestFridge { (result) in
            ingredientsTable.ingredients = result!
            ingredientsTable.isFridge = true
            self.navigationController?.pushViewController(ingredientsTable, animated: true)
        }
    }
    
    @objc func scheduleButtonAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        
        let scheduleView = SetupScheduleViewController()
        scheduleView.username = username
        self.navigationController?.pushViewController(scheduleView, animated: true)
    }
}
