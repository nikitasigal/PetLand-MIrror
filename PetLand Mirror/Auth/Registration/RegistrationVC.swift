//
//  RegistrationVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 26.11.2022.
//

import UIKit

final class RegistrationVC: UIViewController {
    static let identifier = "Auth.Registration"
    
    // MARK: Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Internal vars
    private let authManager: AuthManagerProtocol = AuthManager.shared
    private var textFieldCells: [[ValidatedTextFieldCell]]!
    private var submitCell: SubmitButtonCell!
    private var cells: [[ValidatedCell]]!

    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()

//        statusLabel.isHidden = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: ValidatedTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: ValidatedTextFieldCell.identifier)
        tableView.register(UINib(nibName: SubmitButtonCell.identifier, bundle: nil), forCellReuseIdentifier: SubmitButtonCell.identifier)

        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        // dismiss keyboard on drag
        scrollView.keyboardDismissMode = .onDrag
        
        cells = createCells()
    }
}


// MARK: UI Configuration
extension RegistrationVC {
    private func createCells() -> [[ValidatedCell]] {
        let setup: [[(String, ValidatedTextFieldCell.CellType)]] = [
            [("First name", .firstName),
             ("Last name", .lastName),
             ("Email", .email)],
            [("Password", .newPassword),
             ("Confirm password", .confirmPassword)],
        ]

        textFieldCells = setup.map { section in
            section.map { placeholder, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as! ValidatedTextFieldCell
                cell.configure(placeholder: placeholder, type: type)
                return cell
            }
        }
        
        submitCell = tableView.dequeueReusableCell(withIdentifier: SubmitButtonCell.identifier) as? SubmitButtonCell
        submitCell.configure(title: "Create Account", self)
        
        return textFieldCells + [[submitCell]]
    }

    private var isValid: Bool {
        cells.reduce(true) { result, section in
            result && section.reduce(true) { subresult, cell in
                subresult && cell.isValid
            }
        }
    }
}


// MARK: TableView Logic
extension RegistrationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells[section].count
    }

    func numberOfSections(in _: UITableView) -> Int {
        cells.count
    }
}

extension RegistrationVC: SubmitButtonCellDelegate {
    func submitButtonPressed() {
        guard isValid else {
            let ac = UIAlertController(title: "Please fill all fields",
                                       message: nil,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        authManager.register(email: textFieldCells[0][2].text!,
                             password: textFieldCells[1][0].text!,
                             firstName: textFieldCells[0][0].text!,
                             lastName: textFieldCells[0][1].text!) { success in
            guard success else {
                let ac = UIAlertController(title: "Something went wrong...",
                                           message: "Try again",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                return
            }
            
            let vc = UIStoryboard(name: "Navigation", bundle: nil)
                .instantiateViewController(withIdentifier: "TabBar")
            self.present(vc, animated: true)
        }
    }
}
