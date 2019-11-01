//
//  TableViewCell.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var oldLabel:String
    let label:UITextField
     
    var listItems:ListItem? {
        didSet {
            label.text = listItems!.text
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // 1
        label = UITextField(frame: CGRect.null)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        oldLabel = label.text!
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 2
        label.delegate = self
        label.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        // 3
        addSubview(label)
    }
    
    let leftMarginForLabel: CGFloat = 75.0
     
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        oldLabel = label.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func putRequest(oldIngredient: String, newIngredient: String) {
        let url = "http://3.228.111.41/list"

        let parameters = [
            "username": "bobrosspaints",
            "old_ingredient": oldIngredient,
            "new_ingredient": newIngredient
        ]

        AF.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if listItems != nil {
            listItems?.text = textField.text!
        }
        putRequest(oldIngredient: self.oldLabel, newIngredient: listItems!.text)
        return true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
