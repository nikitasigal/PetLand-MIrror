//
//  ProfileVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 15.12.2022.
//

import UIKit

final class ProfileVC: UIViewController {
    static let identifier = "Profile"
    
    // MARK: Outlets

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    
    // MARK: Internal vars

    private var currentUser: User? {
        didSet {
            nameLabel.text = (currentUser?.firstName ?? "") + " " + (currentUser?.lastName ?? "")
            emailLabel.text = currentUser?.email
            uuidLabel.text = currentUser?.uid
        }
    }
    
    // MARK: VIP

    private var interactor: ProfileBusinessLogic?
    
    // MARK: Setup

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let viewController = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureImage()
        configureLabels()
        
        interactor?.fetchCurrentUser()
    }
}

// MARK: UI Configuration

extension ProfileVC {
    func configureImage() {
        profileImage.layer.cornerRadius = profileImage.bounds.height / 4
        profileImage.clipsToBounds = true
    }
    
    func configureLabels() {
        nameLabel.text = nil
        emailLabel.text = nil
        uuidLabel.text = nil
    }
    
    func configureNavigationBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .done,
            target: self, action: #selector(logoutButtonTapped)
        )
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc
    func logoutButtonTapped() {
        let ac = UIAlertController(title: "Do you really want to log out?",
                                   message: nil,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.interactor?.logout()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

// MARK: Display Logic

extension ProfileVC: ProfileDisplayLogic {
    func displayLogout() {
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: LoginVC.identifier)
        present(vc, animated: true)
    }
    
    func displayImage(_ image: UIImage) {
        profileImage.image = image
    }
    
    func displayError(_ error: Error) {
        let ac = UIAlertController(title: "Something went wrong...",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func displayCurrentUser(_ user: User) {
        currentUser = user
    }
}
