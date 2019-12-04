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
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 350, width: view.frame.size.width / 1.5, height: 50))
        label.text = "By Rittika Adhikari, Utkarsh Awasthi, Andy Chai, and Shoji Moto"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 250, width: 130, height: 50))
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 250, y: 250, width: 130, height: 50))
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    func setupButtons() {
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
        self.view.addSubview(registerButton)
        self.view.addSubview(loginButton)
        authorLabel.center.x = self.view.center.x
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LaunchBG")
        backgroundImage.alpha = 0.5
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
//        setupButtons()
    }
    
    @objc func registerButtonAction(sender: UIButton!) {
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
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func loginButtonAction(sender: UIButton!) {
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
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
