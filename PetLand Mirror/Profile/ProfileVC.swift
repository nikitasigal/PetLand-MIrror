//
//  ProfileVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 15.12.2022.
//

import UIKit

final class ProfileVC: UIViewController {
    @IBOutlet var label: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Signed in as \(authManager.currentUserID ?? "")"
    }
    
    
    @IBAction func onLogoutButtonPress() {
        AuthManager.shared.logout()
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: LoginVC.identifier)
        
        present(vc, animated: true)
    }
}
