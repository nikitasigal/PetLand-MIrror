//
//  FilterVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

class FiltersVC: UIViewController {
    // Outlets
    @IBOutlet var tableView: UITableView!

    // External vars
    weak var marketplaceVC: MarketplaceVC!
    var checkboxCells: [CheckboxCell] = []
    var rangeCell: RangeCell!
    var favouritesToggleCell: FavouritesToggleCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureCells()
    }

    override func viewWillDisappear(_ animated: Bool) {
        marketplaceVC.filters = Set(
            checkboxCells.compactMap { cell -> MarketplaceVC.Filter? in
                cell.isExcluded ? .exclude(cell.animal) : nil
            }
                + [.priceRange(from: rangeCell.fromInt, to: rangeCell.toInt)]
                + (favouritesToggleCell.toggle.isOn ? [.onlyFavourites] : [])
        )

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
        checkboxCells = Pet.Species.allCases.map { animal -> CheckboxCell in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CheckboxCell") as! CheckboxCell
            cell.configure(for: animal,
                           isExcluded: marketplaceVC.filters.contains(.exclude(animal)))
            return cell
        }

        rangeCell = tableView.dequeueReusableCell(withIdentifier: "RangeCell") as? RangeCell
        for f in marketplaceVC.filters {
            switch f {
                case .priceRange(let from, let to):
                    rangeCell.configure(from: from, to: to)
                default:
                    break
            }
        }

        favouritesToggleCell = tableView.dequeueReusableCell(withIdentifier: "FavouritesToggleCell") as? FavouritesToggleCell
        for f in marketplaceVC.filters {
            switch f {
                case .onlyFavourites:
                    favouritesToggleCell.toggle.isOn = true
                default:
                    break
            }
        }
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
