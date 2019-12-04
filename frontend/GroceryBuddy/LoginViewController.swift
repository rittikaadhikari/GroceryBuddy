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

class LoginViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Login"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onLogin))
        
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
    
    func getRequest(username: String, completionHandler: @escaping (Bool?) -> ()) {
        let url = "http://3.228.111.41/users/" + username
        
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
                if response.response?.statusCode == 404 {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    @objc func onLogin() {
        let validationErrors = form.validate()
        if validationErrors.isEmpty {
            let valuesDictionary = form.values()
            let username = valuesDictionary["UsernameTag"]
            if let username = username as! String? {
                print("logging in")
                getRequest(username: username) { (result) in
                    if result! == true {
                        print("logged in ", username)
                        let homeViewController = HomeViewController()
                        homeViewController.username = username
                        self.navigationController?.setViewControllers([homeViewController], animated: true)
                    } else {
                        let alert = UIAlertController(title: username + " not found", message: "Please register before logging in", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Missing username/password", message: "Please enter account information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
