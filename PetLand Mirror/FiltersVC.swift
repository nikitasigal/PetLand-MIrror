//
//  FiltersVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

class FiltersVC: UIViewController {
    static let identifier = "Marketplace.Filters"

    // MARK: Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: External vars

    weak var marketplaceVC: MarketplaceVC!

    // MARK: Internal vars

    var checkboxCells: [CheckboxCell] = []
    var rangeCell: RangeCell!
    var favouritesToggleCell: FavouritesToggleCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureCells()
    }

    override func viewWillDisappear(_ animated: Bool) {
        for cell in checkboxCells {
            if cell.isIncluded {
                marketplaceVC.inclusionFilter.insert(cell.species)
            } else {
                marketplaceVC.inclusionFilter.remove(cell.species)
            }
        }

        marketplaceVC.onlyFavouritesFilter = favouritesToggleCell.toggle.isOn
        marketplaceVC.priceRangeFilter = (rangeCell.fromInt, rangeCell.toInt)

        super.viewWillDisappear(animated)
    }

    func configure(for vc: MarketplaceVC?) {
        marketplaceVC = vc
    }
}

// MARK: UI Configuration

extension FiltersVC {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    func configureCells() {
        checkboxCells = Pet.Species.allCases.map { species -> CheckboxCell in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: CheckboxCell.identifier) as! CheckboxCell
            cell.configure(for: species, isIncluded: marketplaceVC.inclusionFilter.contains(species))
            return cell
        }

        rangeCell = tableView.dequeueReusableCell(withIdentifier: RangeCell.identifier) as? RangeCell
        let (from, to) = marketplaceVC.priceRangeFilter
        rangeCell.configure(from: from, to: to)

        favouritesToggleCell = tableView.dequeueReusableCell(withIdentifier: FavouritesToggleCell.identifier) as? FavouritesToggleCell
        favouritesToggleCell.toggle.isOn = marketplaceVC.onlyFavouritesFilter
    }
}

// MARK: TableView Logic

extension FiltersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        ["Animals", "Price", "Favourites"].count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        [Pet.Species.allCases.count, 1, 1][section]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ["Animals", "Price", "Favourites"][section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        [checkboxCells[indexPath.row],
         rangeCell,
         favouritesToggleCell][indexPath.section]
    }
}
