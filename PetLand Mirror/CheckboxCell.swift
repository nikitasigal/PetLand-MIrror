//
//  CheckboxCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 13.12.2022.
//

import UIKit

final class CheckboxCell: UITableViewCell {
    // Outlets
    @IBOutlet var checkboxButton: UIButton!
    
    // Internal vars
    var isExcluded = false
    var animal: Pet.Species!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateImage()
    }

    @IBAction func onCheckboxButtonPress() {
        isExcluded.toggle()
        updateImage()
    }

    private func updateImage() {
        checkboxButton.setImage(
            UIImage(systemName:
                isExcluded
                    ? "square"
                    : "checkmark.square.fill")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(
                    isExcluded
                        ? .systemFill
                        : .systemBlue),
            for: .normal)
    }

    func configure(for animal: Pet.Species, isExcluded: Bool) {
        self.animal = animal
        self.isExcluded = isExcluded
        checkboxButton.setTitle(animal.rawValue.uppercasedFirst(), for: .normal)
        updateImage()
    }
}
