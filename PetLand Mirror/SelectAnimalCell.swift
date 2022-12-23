//
//  SelectAnimalCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 21.12.2022.
//

import UIKit

final class SelectAnimalCell: UITableViewCell {
    static let identifier = "SelectAnimalCell"
    
    @IBOutlet var selectAnimalButton: UIButton!
    
    var animal: Pet.Species = .allCases[0]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectAnimalButton.menu = createMenu()
    }
}

extension SelectAnimalCell {
    func createMenu() -> UIMenu {
        var options = [UIAction]()
        for animal in Pet.Species.allCases {
            options.append(UIAction(title: animal.rawValue.uppercasedFirst(),
                                    state: self.animal == animal ? .on : .off,
                                    handler: { [weak self] _ in
                                        self?.animal = animal
                                        self?.selectAnimalButton.menu = self?.createMenu()
                                    }))
        }
        return UIMenu(children: options)
    }
}
