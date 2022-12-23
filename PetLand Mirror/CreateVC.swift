//
//  CreateVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

class CreateVC: UIViewController {
    static let identifier = "Create"
    
    @IBOutlet var tableView: UITableView!
    
    var imagePickerCell: ImagePickerCell!
    var nameCell: ValidatedTextFieldCell!
    var priceCell: ValidatedTextFieldCell!
    var speciesCell: SelectAnimalCell!
    var breedCell: ValidatedTextFieldCell!
    var descriptionCell: DescriptionCell!
    var submitCell: SubmitButtonCell!
    
    var cells: [[ValidatedCell]] = []
    
    private var interactor: CreateBusinessLogic?
    private var callback: (() -> Void)?
    
    // MARK: Setuo
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let presenter = CreatePresenter()
        let interactor = CreateInteractor()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func configure(callback: (() -> Void)?) {
        self.callback = callback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: ValidatedTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: ValidatedTextFieldCell.identifier)
        
        cells = createCells()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: UI Configuration

extension CreateVC {
    func createCells() -> [[ValidatedCell]] {
        imagePickerCell = tableView.dequeueReusableCell(withIdentifier: ImagePickerCell.identifier) as? ImagePickerCell
        imagePickerCell.configure(delegate: self)
        
        nameCell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as? ValidatedTextFieldCell
        nameCell.configure(placeholder: "Name", type: .text)
        
        priceCell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as? ValidatedTextFieldCell
        priceCell.configure(placeholder: "Price", type: .integer)
        
        speciesCell = tableView.dequeueReusableCell(withIdentifier: SelectAnimalCell.identifier) as? SelectAnimalCell
        
        breedCell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as? ValidatedTextFieldCell
        breedCell.configure(placeholder: "Breed", type: .text)
        
        descriptionCell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier) as? DescriptionCell
        descriptionCell.configure { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
        
        submitCell = tableView.dequeueReusableCell(withIdentifier: SubmitButtonCell.identifier) as? SubmitButtonCell
        submitCell.configure(self)
            
        return [[imagePickerCell],
                [nameCell, priceCell],
                [speciesCell, breedCell],
                [descriptionCell],
                [submitCell]]
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if tableView.frame.origin.y == 0 {
                tableView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        tableView.frame.origin.y = 0
    }
}

// MARK: TableView Logic

extension CreateVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ["Image", "General", "Species", "Description", nil][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Image Picker Logic

extension CreateVC: ImagePickerCellDelegate {
    func presentImagePicker(_ imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
}

extension CreateVC: SubmitButtonCellDelegate {
    func submitButtonPressed() {
        guard cells.reduce(true, { acc, section in
            acc && section.reduce(true) { subacc, cell in
                subacc && cell.isValid
            }
        }) else { return }
        
        let model = Pet(name: nameCell.text!,
                        species: speciesCell.animal,
                        breed: breedCell.text!,
                        description: descriptionCell.text!,
                        price: Int(priceCell.text!)!)
    
        interactor?.addPet(model, withImage: imagePickerCell.image!)
    }
}

// MARK: Display Logic

extension CreateVC: CreateDisplayLogic {
    func displayError(_ error: Error) {
        let ac = UIAlertController(title: "Something went wrong...",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func displayCompletion() {
        callback?()
        dismiss(animated: true)
    }
}
