//
//  ValidatedCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//

import UIKit

protocol ValidatedCell: UITableViewCell {
    var isValid: Bool { get }
}
