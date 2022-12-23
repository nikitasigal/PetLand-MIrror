//
//  SelectImageCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 20.12.2022.
//

import UIKit

protocol ImagePickerCellDelegate {
    func presentImagePicker(_ imagePicker: UIImagePickerController)
}

final class ImagePickerCell: UITableViewCell {
    static let identifier = "ImagePickerCell"
    
    @IBOutlet weak var selectButton: UIButton!
    
    private var delegate: ImagePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectButton.imageView?.contentMode = .scaleAspectFill        
    }
    
    @IBAction func onSelectImageButtonPress() {
        print("Pressed")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        delegate?.presentImagePicker(imagePicker)
    }
}

extension ImagePickerCell {
    func configure(delegate: ImagePickerCellDelegate) {
        self.delegate = delegate
    }
    
    var image: UIImage? {
        selectButton.currentImage
    }
}

extension ImagePickerCell: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        selectButton.setImage(image, for: .normal)
    }
}

extension ImagePickerCell: ValidatedCell {
    var isValid: Bool {
        selectButton.currentImage != nil
    }
}
