//
//  MarketplaceMainVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.11.2022.
//

import UIKit

final class MarketplaceVC: UIViewController {
    static let identifier = "Marketplace.Main"

    // MARK: Outlets

    @IBOutlet var sortButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var tableView: UITableView!

    // MARK: External vars

    private var interactor: MarketplaceBusinessLogic?
    private(set) var router: MarketplaceRoutingLogic?

    // MARK: Internal vars

    var data: [Pet] = [] {
        didSet { filterData() }
    }

    var images: [String: UIImage] = [:] {
        didSet { tableView.reloadData() }
    }

    var favourites: Set<String> = [] {
        didSet { filterData() }
    }

    // MARK: Sorting

    enum SortOrder {
        case ascending, descending
    }

    var order: SortOrder = .ascending {
        didSet { filterData() }
    }

    // MARK: Filtering

    var inclusionFilter: Set<Pet.Species> = Set(Pet.Species.allCases) {
        didSet { filterData() }
    }

    var onlyFavouritesFilter: Bool = false {
        didSet { filterData() }
    }

    var priceRangeFilter: (Int?, Int?) {
        didSet { filterData() }
    }

    var containsTextFilter: String? {
        didSet { filterData() }
    }

    func filterData() {
        filteredData = data
            .filter { item in
                var result = true
                result = result && (inclusionFilter.contains(item.species))
                result = result && (!onlyFavouritesFilter || favourites.contains(item.uid!))

                let (from, to) = priceRangeFilter
                if let from {
                    result = result && (item.price >= from)
                }
                if let to {
                    result = result && (item.price <= to)
                }

                if let query = containsTextFilter {
                    result = result && (query.isEmpty
                        || item.name.lowercased().contains(query)
                        || item.species.rawValue.lowercased().contains(query)
                        || item.breed.lowercased().contains(query)
                        || item.description.lowercased().contains(query))
                }

                return result
            }
            .sorted { l, r in
                (order == .ascending && l.price < r.price) || (order == .descending && l.price > r.price)
            }
    }

    var filteredData: [Pet] = [] {
        didSet { tableView.reloadData() }
    }

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
        let presenter = MarketplacePresenter()
        let interactor = MarketplaceInteractor()
        let router = MarketplaceRouter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        router.viewController = viewController
        viewController.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI Configuration
        configureNavigationBar()
        configureSortButton()
        configureTableview()

        // Logic Setup
        interactor?.fetchCurrentUser()
        interactor?.fetchPets()
    }

    @IBAction func onFilterButtonTouched() {
        router?.routeToFilter()
    }
}

// MARK: UI Configuration

extension MarketplaceVC {
    private func configureTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func configureNavigationBar() {
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self, action: #selector(plusButtonTapped)
        )
        plusButton.tintColor = .label
        navigationItem.rightBarButtonItem = plusButton

        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureSortButton() {
        sortButton.menu = createMenu()
        sortButton.showsMenuAsPrimaryAction = true
    }

    func createMenu() -> UIMenu {
        UIMenu(children: [
            UIAction(title: "Less expensive",
                     image: UIImage(systemName: "arrow.down.forward"),
                     state: order == .ascending ? .on : .off,
                     handler: { [weak self] _ in
                         self?.order = .ascending
                         self?.sortButton.menu = self?.createMenu()
                     }),
            UIAction(title: "More expensive",
                     image: UIImage(systemName: "arrow.up.forward"),
                     state: order == .descending ? .on : .off,
                     handler: { [weak self] _ in
                         self?.order = .descending
                         self?.sortButton.menu = self?.createMenu()
                     }),
        ])
    }

    @objc
    func plusButtonTapped() {
        router?.routeToCreatePet { [weak self] in
            self?.interactor?.fetchPets()
        }
    }
}

// MARK: TableView Logic

extension MarketplaceVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = filteredData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketplaceCellVC.identifier, for: indexPath) as! MarketplaceCellVC
        cell.configure(for: model,
                       withImage: images[model.imageID],
                       isFavourite: favourites.contains(model.uid!),
                       delegate: self)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Display Logic

extension MarketplaceVC: MarketplaceDisplayLogic {
    func displayImage(_ image: UIImage, withID imageID: String) {
        images[imageID] = image
    }

    func displayError(_ error: Error) {
        let ac = UIAlertController(title: "Something went wrong...",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func displayPets(_ data: [Pet]) {
        self.data = data
    }

    func displayCurrentUser(_ data: User) {
        favourites = Set(data.favourites)
    }
}

// MARK: Cell Delegate Logic

extension MarketplaceVC: MarketplaceCellDelegate {
    func setFavourite(to isFavourite: Bool, for petID: String) {
        var newFavourites = favourites
        if isFavourite {
            newFavourites.insert(petID)
        } else {
            newFavourites.remove(petID)
        }
        interactor?.updateFavourites(to: newFavourites)
    }
}

// MARK: Search Logic

extension MarketplaceVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }

        containsTextFilter = searchQuery.lowercased()
    }
}
