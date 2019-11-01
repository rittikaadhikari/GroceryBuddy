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
    label.text = "My Fridge"
    label.textAlignment = .center
    return label
  }()
  
  lazy var itemsButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 200, width: view.frame.size.width, height: 50))
    button.setTitle("View Fridge Items", for: .normal)
    button.addTarget(self, action: #selector(listButtonAction), for: .touchUpInside)
    
    return button
  }()
  
  lazy var addItemButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 300, width: view.frame.size.width, height: 50))
    button.setTitle("Add New Item", for: .normal)
    button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .orange
    self.view.addSubview(titleLabel)
    self.view.addSubview(itemsButton)
    self.view.addSubview(addItemButton)
  }
  
  @objc func listButtonAction(sender: UIButton!) {
    navigationController?.pushViewController(UITableViewController(), animated: true)
  }
  
  @objc func addButtonAction(sender: UIButton!) {
    navigationController?.pushViewController(UITableViewController(), animated: true)
  }
}
