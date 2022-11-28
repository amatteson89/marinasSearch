//
//  ResultsTableViewController.swift
//  Marinas Search
//
//  Created by mattesona on 11/25/22.
//

import Foundation
import UIKit

/// View Controller to control the results view and handle the search results
class ResultsTableViewController: UITableViewController, UISearchBarDelegate {
    // MARK: Properties

    /// The location data array to hold all the search data
    var displayPointData: [LocationData] = []

    // MARK: Outlets

    @IBOutlet var searchBar: UISearchBar!

    // MARK: View Information

    /// Sets up the view controller after the view has loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        tableView.register(MainSearchCell.self, forCellReuseIdentifier: MainSearchCell.ID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
    }

    // MARK: Table View

    /// Get the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Get the count of the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayPointData.count
    }

    /// Load the cell information with the location data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchCell.ID, for: indexPath) as? MainSearchCell {
            if indexPath.row < displayPointData.count {
                cell.updateSearchCell(using: displayPointData[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }

    /// When selecting a cell push up a new view controller which contains more information
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoView = MoreInfoViewController(locationData: displayPointData[indexPath.row])
        infoView.title = displayPointData[indexPath.row].name
        infoView.view.backgroundColor = view.backgroundColor
        navigationController?.pushViewController(infoView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /// Configure the cell height. If there is an image in the location data, then make the cell bigger to fit the image
    ///
    ///     Note: I ultimately decided to draw this image in the information view controller, so in a
    ///     way this takes away from this view. But I figure I would leave it in since its working
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < displayPointData.count {
            if let count = displayPointData[indexPath.row].images.data?.count, count > 0 {
                return 400.0
            }
        }
        return 60.0
    }

    // MARK: Search Bar Config

    /// Update the stored point data based on the search
    ///
    ///     NOTE: This isn't super smart with dealing with spaces in a search. Definitely a future improvement
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            displayPointData = []
        }

        SearchHelper.shared.getPoints(searchText: searchText) { points, _ in
            if let points = points {
                self.displayPointData = points.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
