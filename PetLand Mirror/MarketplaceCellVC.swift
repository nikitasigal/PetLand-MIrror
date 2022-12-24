//
//  MarketplaceCellVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import UIKit


protocol MarketplaceCellDelegate: AnyObject {
    func setFavourite(to isFavourite: Bool, for petID: String)
}

final class MarketplaceCellVC: UITableViewCell {
    static let identifier = "MarketplaceCell"
    
    // Outlets
    @IBOutlet var frameView: UIView!
    @IBOutlet var petName: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var petSpecies: UILabel!
    @IBOutlet var petDescription: UITextView!
    @IBOutlet var petPrice: UILabel!
    @IBOutlet var favouritesButton: UIButton!

    // External vars
    private weak var delegate: MarketplaceCellDelegate!

    // Internal vars
    private var petID: String!
    private var isFavourite: Bool!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Add rounded corners
        frameView.layer.cornerRadius = 10
        petImage.layer.cornerRadius = 10

        // Remove padding from petDescription
        petDescription.textContainerInset = .zero
        petDescription.textContainer.lineFragmentPadding = 0
    }
    
    @IBAction func onFavouritesButtonPress(_ sender: Any) {
        delegate.setFavourite(to: !isFavourite, for: petID)
    }
    
}

extension MarketplaceCellVC {
    func configure(for data: Pet,
                   withImage image: UIImage?,
                   isFavourite: Bool,
                   delegate: MarketplaceCellDelegate) {
        self.petID = data.uid
        self.delegate = delegate
        self.isFavourite = isFavourite
        
        favouritesButton.setImage(
            UIImage(systemName:
                        isFavourite
                    ? "heart.fill"
                    : "heart")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(
                    isFavourite
                    ? .systemRed
                    : .systemFill),
            for: .normal)

        petImage.image = image
        petName.text = data.name
        petSpecies.text = data.breed
        petDescription.text = data.description

        // Format price as currency
        petPrice.text = formatCurrencyRU(input: data.price)
    }
}
