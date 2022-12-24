//
//  CheckboxCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 13.12.2022.
//

import UIKit

final class CheckboxCell: UITableViewCell {
    static let identifier = "CheckboxCell"
    
    // Outlets
    @IBOutlet var checkboxButton: UIButton!
    
    // Internal vars
    var isIncluded = true
    var species: Pet.Species!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateImage()
    }

    @IBAction func onCheckboxButtonPress() {
        isIncluded.toggle()
        updateImage()
    }

    private func updateImage() {
        checkboxButton.setImage(
            UIImage(systemName:
                isIncluded
                    ? "checkmark.square.fill"
                    : "square")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(
                    isIncluded
                        ? .systemBlue
                        : .systemFill),
            for: .normal)
    }

    func configure(for species: Pet.Species, isIncluded: Bool) {
        self.species = species
        self.isIncluded = isIncluded
        checkboxButton.setTitle(species.rawValue.uppercasedFirst(), for: .normal)
        updateImage()
    }
}
