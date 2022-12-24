//
//  Login.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.11.2022.
//

import FirebaseAuth
import UIKit

final class LoginVC: UIViewController {
    static let identifier = "Auth.Login"
    
    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Internal vars
    
    private var textFieldCells: [[ValidatedTextFieldCell]]!
    private var submitCell: SubmitButtonCell!
    private var cells: [[ValidatedCell]]!
    
    // MARK: VIP
    
    private var interactor: LoginBusinessLogic!
    
    // MARK: Setup
    
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
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureKeyboard()
    }
}

// MARK: Keyboard Configuration

extension LoginVC {
    func configureKeyboard() {
        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // dismiss keyboard on drag
        tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: TableView Configuration

extension LoginVC {
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: ValidatedTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: ValidatedTextFieldCell.identifier)
        tableView.register(UINib(nibName: SubmitButtonCell.identifier, bundle: nil), forCellReuseIdentifier: SubmitButtonCell.identifier)
        
        cells = createCells()
    }
    
    private func createCells() -> [[ValidatedCell]] {
        let setup: [[(String, ValidatedTextFieldCell.CellType)]] = [
            [("Email", .email),
             ("Password", .newPassword)]
        ]
        
        textFieldCells = setup.map { section in
            section.map { placeholder, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as! ValidatedTextFieldCell
                cell.configure(placeholder: placeholder, type: type)
                return cell
            }
        }
        
        submitCell = tableView.dequeueReusableCell(withIdentifier: SubmitButtonCell.identifier) as? SubmitButtonCell
        submitCell.configure(title: "Login", self)
        
        return textFieldCells + [[submitCell]]
    }
}

// MARK: TableView Logic

extension LoginVC: UITableViewDataSource, UITableViewDelegate {
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

// MARK: Submit Logic

extension LoginVC: SubmitButtonCellDelegate {
    func submitButtonPressed() {
        let isValid = cells.reduce(true) { result, section in
            result && section.reduce(true) { subresult, cell in
                subresult && cell.isValid
            }
        }
        
        guard isValid else {
            let ac = UIAlertController(title: "Please fill all fields",
                                       message: nil,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        interactor.login(email: textFieldCells[0][0].text!,
                         password: textFieldCells[0][1].text!)
    }
}

// MARK: Display Logic

extension LoginVC: LoginDisplayLogic {
    func displayError(_ error: Error) {
        let ac = UIAlertController(title: "Something went wrong...",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func displayCompletion() {
        let vc = UIStoryboard(name: "Navigation", bundle: nil)
            .instantiateViewController(withIdentifier: TabBarVC.identifier)
        present(vc, animated: true)
    }
}
