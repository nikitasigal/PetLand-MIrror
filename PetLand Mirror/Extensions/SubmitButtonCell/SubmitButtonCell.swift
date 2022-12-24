//
//  SubmitButtonCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//

import UIKit

protocol SubmitButtonCellDelegate: AnyObject {
    func submitButtonPressed()
}

class SubmitButtonCell: UITableViewCell {
    static let identifier = "SubmitButtonCell"

    @IBOutlet var submitButton: UIButton!

    private weak var delegate: SubmitButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String?, _ delegate: SubmitButtonCellDelegate) {
        submitButton.setTitle(title, for: .normal)
        self.delegate = delegate
    }

    @IBAction func onSubmitButtonPress() {
        delegate?.submitButtonPressed()
    }
}

extension SubmitButtonCell: ValidatedCell {
    var isValid: Bool {
        true
    }
}
