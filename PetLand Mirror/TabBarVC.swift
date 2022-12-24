//
//  TabBarVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

import UIKit

final class TabBarVC: UITabBarController {
    static let identifier = "Navigation.TabBar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.clipsToBounds = true
        tabBar.layer.borderWidth = 0
    }
}
