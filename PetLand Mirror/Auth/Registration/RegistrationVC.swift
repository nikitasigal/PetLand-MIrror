//
//  RegistrationVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 26.11.2022.
//

import UIKit

final class RegistrationVC: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var statusLabel: UILabel!

    private let authManager: AuthManagerProtocol = AuthManager.shared
    private var cells: [[ValidatedTextFieldCell]]!

    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.isHidden = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: ValidatedTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: ValidatedTextFieldCell.identifier)


        // make table appear from the bottom
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        // dismiss keyboard on drag
        scrollView.keyboardDismissMode = .onDrag
        
        cells = initCells()
    }

    @IBAction func onCreateAccontButtonPress() {
        guard isValid else {
            statusLabel.text = "All field must be filled and valid"
            statusLabel.isHidden = false
            return
        }
        statusLabel.isHidden = true

        authManager.register(email: cells[1][0].text!,
                             password: cells[0][1].text!,
                             firstName: cells[1][2].text!,
                             lastName: cells[1][1].text!) { [weak self] success in
            guard success else {
                self?.statusLabel.text = "Something went wrong, try again"
                self?.statusLabel.isHidden = false
                return
            }
            
            let vc = UIStoryboard(name: "Navigation", bundle: nil)
                .instantiateViewController(withIdentifier: "TabBar")
            self?.present(vc, animated: true)
        }
    }
}

extension RegistrationVC {
    private func initCells() -> [[ValidatedTextFieldCell]] {
        let setup: [[(String, ValidatedTextFieldCell.CellType)]] = [
            [("First name", .firstName),
             ("Last name", .lastName),
             ("Email", .email)].reversed(),
            [("Password", .newPassword),
             ("Confirm password", .confirmPassword)].reversed(),
        ].reversed()

        return setup.map { section in
            section.map { placeholder, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as! ValidatedTextFieldCell
                cell.configure(placeholder: placeholder, type: type)
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
        }
    }

    private var isValid: Bool {
        cells.reduce(true) { result, section in
            result && section.reduce(true) { subresult, cell in
                subresult && cell.isValid
            }
        }
    }
}

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
