//
//  SpeciesPickerCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 21.12.2022.
//

import UIKit

final class SpeciesPickerCell: UITableViewCell {
    static let identifier = "SpeciesPickerCell"
    
    @IBOutlet var selectSpeciesButton: UIButton!
    
    var species: Pet.Species = .allCases[0]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectSpeciesButton.menu = createMenu()
    }
}

extension SpeciesPickerCell {
    func createMenu() -> UIMenu {
        var options = [UIAction]()
        for species in Pet.Species.allCases {
            options.append(UIAction(title: species.rawValue.uppercasedFirst(),
                                    state: self.species == species ? .on : .off,
                                    handler: { [weak self] _ in
                                        self?.species = species
                                        self?.selectSpeciesButton.menu = self?.createMenu()
                                    }))
        }
        return UIMenu(children: options)
    }
}

extension SpeciesPickerCell: ValidatedCell {
    var isValid: Bool {
        true
    }
}
