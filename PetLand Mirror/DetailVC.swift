//
//  DetailVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import UIKit

final class DetailVC: UIViewController {
    static let identifier = "Marketplace.Detail"
    
    // MARK: Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var frameView: UIView!

    @IBOutlet var petDescription: UITextView!
    @IBOutlet var petPrice: UILabel!
    @IBOutlet var petSpecies: UILabel!
    @IBOutlet var petName: UILabel!
    @IBOutlet var petImage: UIImageView!

    // MARK: Internal vars
    var dataModel: Pet!
    var dataImage: UIImage!

    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        frameView.layer.cornerRadius = 10
        petImage.layer.cornerRadius = 10

        petDescription.textContainerInset = .zero
        petDescription.textContainer.lineFragmentPadding = 0

        petImage.image = dataImage
        petName.text = dataModel.name
        petSpecies.text = dataModel.breed
        petDescription.text = dataModel.description
        petPrice.text = formatCurrencyRU(input: dataModel.price)
    }
    
    func configure(for data: Pet, withImage image: UIImage?) {
        dataModel = data
        dataImage = image ?? UIImage(systemName: "nosign")
    }
}
