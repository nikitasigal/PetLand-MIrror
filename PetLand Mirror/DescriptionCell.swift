//
//  DescriptionCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 20.12.2022.
//

import UIKit

final class DescriptionCell: UITableViewCell {
    static let identifier = "DescriptionCell"
    
    @IBOutlet weak var textView: UITextView!
    
    private var reloader: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        textView.delegate = self
    }
    
    func configure(for reloader: @escaping () -> Void) {
        self.reloader = reloader
    }
}

extension DescriptionCell {
    var text: String? {
        textView.text
    }
}

extension DescriptionCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reloader?()
    }
}

extension DescriptionCell: ValidatedCell {
    var isValid: Bool {
        textView.hasText
    }
}
