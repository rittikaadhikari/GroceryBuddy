//
//  RegisterViewController.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 11/26/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class RegisterViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Register"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onRegister))
        
        form +++ Section("Name")
            <<< NameRow("FirstNameTag"){ row in
                row.title = "First Name"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
            <<< NameRow("LastNameTag"){ row in
                row.title = "Last Name"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
        form +++ Section("Account")
            <<< AccountRow("UsernameTag"){ row in
                row.title = "Username"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
            <<< PasswordRow("PasswordTag"){ row in
                row.title = "Password"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                    row.placeholder = "Required"
                }
            }
    }
    
    func postRequest(firstName: String, lastName: String, username: String, password: String) {
        let url = "http://3.228.111.41/users"

        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "password": password
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func onRegister() {
        let validationErrors = form.validate()
        if validationErrors.isEmpty {
            let valuesDictionary = form.values()
            let firstName = valuesDictionary["FirstNameTag"]
            let lastName = valuesDictionary["LastNameTag"]
            let username = valuesDictionary["UsernameTag"]
            let password = valuesDictionary["PasswordTag"]
            if let firstName = firstName as! String?,
                let lastName = lastName as! String?,
                let username = username as! String?,
                let password = password as! String? {
                print("registering")
                postRequest(firstName: firstName, lastName: lastName, username: username, password: password)
                let homeViewController = HomeViewController()
                homeViewController.username = username
                navigationController?.setViewControllers([homeViewController], animated: true)
            }
        }
    }
}
