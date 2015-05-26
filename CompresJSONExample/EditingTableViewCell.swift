//
//  EditingTableViewCell.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 24/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

let kPadding: CGFloat = 10

class EditingTableViewCell: UITableViewCell {

    let label = UILabel()
    let textField = UITextField()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(label)
        
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(textField)
        textField.textAlignment = NSTextAlignment.Right
        
        setupLabelConstraints()
        setupTextFieldConstraints()
    }

    // MARK: - Constraints
    
    func setupLabelConstraints() {
        
        label.addTopConstraint(toView: contentView, relation: .Equal, constant: 0)
        label.addLeftConstraint(toView: contentView, relation: .Equal, constant: kPadding)
        label.addBottomConstraint(toView: contentView, relation: .Equal, constant: 0)
        label.addWidthConstraint(relation: .Equal, constant: 160)
    }
    
    func setupTextFieldConstraints() {
        
        textField.addTopConstraint(toView: contentView, relation: .Equal, constant: 0)
        textField.addLeftConstraint(toView: label, attribute: NSLayoutAttribute.Right, relation: .Equal, constant: 0)
        textField.addRightConstraint(toView: contentView, relation: .Equal, constant: -kPadding)
        textField.addBottomConstraint(toView: contentView, relation: .Equal, constant: 0)
    }

}
