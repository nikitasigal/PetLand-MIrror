//
//  MarketplaceRouter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import UIKit

final class MarketplaceRouter {
    weak var viewController: MarketplaceVC?
}

extension MarketplaceRouter: MarketplaceRoutingLogic {
    func routeToFilter() {
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "Filter") as? FiltersVC,
              let sheet = vc.sheetPresentationController
        else { return }
        sheet.detents = [.medium(), .large()]
        sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        sheet.prefersGrabberVisible = true

        vc.configure(for: viewController)
        viewController?.navigationController?.present(vc, animated: true)
    }

    func routeToCreatePet(callback: (() -> Void)?) {
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: CreateVC.identifier) as? CreateVC,
              let sheet = vc.sheetPresentationController
        else { return }
        sheet.prefersGrabberVisible = true
        
        vc.configure(callback: callback)
        viewController?.navigationController?.present(vc, animated: true)
    }

    func routeToDetail() {
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "Detail")
        else { return }

        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        let model = viewController?.data[selectedRow!]
        let image = viewController?.images[model?.imageID ?? ""]

        (vc as! DetailVC).configure(for: model!, withImage: image)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
