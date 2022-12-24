//
//  RangeCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.12.2022.
//

import UIKit

final class RangeCell: UITableViewCell {
    static let identifier = "RangeCell"

    // Outlets
    @IBOutlet var fromTF: UITextField!
    @IBOutlet var toTF: UITextField!

    // Internal vars
    var fromInt: Int? {
        Int(fromTF.text!)
    }

    var toInt: Int? {
        Int(toTF.text!)
    }

    override func awakeFromNib() {
        fromTF.delegate = self
        toTF.delegate = self
    }

    func configure(from: Int?, to: Int?) {
        if let from {
            fromTF.text = String(from)
        }

        if let to {
            toTF.text = String(to)
        }
    }
}

extension RangeCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
