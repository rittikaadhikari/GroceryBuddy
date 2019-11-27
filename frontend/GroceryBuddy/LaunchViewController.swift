//
//  LaunchViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 11/26/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 50))
        label.text = "Grocery Buddy"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 350, width: view.frame.size.width / 1.5, height: 50))
        label.text = "By Rittika Adhikari, Utkarsh Awasthi, Andy Chai, and Shoji Moto"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var loginButton: UIButton = {
            let button = UIButton.init(type: .system)
            button.setTitle("Log In", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
            
            return button
        }()
    
    func setupButtons() {
        let redView = UIView()
        redView.backgroundColor = .red

        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [registerButton, loginButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20), stackView.leftAnchor.constraint(equalTo: view.leftAnchor), stackView.rightAnchor.constraint(equalTo: view.rightAnchor), stackView.heightAnchor.constraint(equalToConstant: 200)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(authorLabel)
        authorLabel.center.x = self.view.center.x
        
        setupButtons()
    }
    
    @objc func registerButtonAction(sender: UIButton!) {
//        print("register")
        navigationController?.pushViewController(UITableViewController(), animated: true)
    }
    
    @objc func loginButtonAction(sender: UIButton!) {
        print("login")
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }
}
