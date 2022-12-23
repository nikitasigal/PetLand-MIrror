//
//  FavouritesToggleCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 15.12.2022.
//

import UIKit

final class FavouritesToggleCell: UITableViewCell {
    @IBOutlet var toggle: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        toggle.isOn = false
    }
}
