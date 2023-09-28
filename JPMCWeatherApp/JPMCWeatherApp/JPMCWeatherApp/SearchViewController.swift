//
//  SearchViewController.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/28/23.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var networkManager: NetworkManager = .shared
    
    var tabledata = [String: [String]]()
    
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = .black
            controller.searchBar.barTintColor = .white
            controller.searchBar.backgroundColor = .clear
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        if let data = Util.readCitiesData() {
            self.tabledata = data
        }
        self.tableView.reloadData()
    }
}

//MARK: - TABLE VIEW
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.resultSearchController.isActive {
            return 1// self.filteredTableData.count
        }
        return self.tabledata.keys.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }
        let lazyMapCollection = self.tabledata.keys.sorted()
        let stringArray = Array(lazyMapCollection)
        let a = stringArray[section]
        if let cities = self.tabledata[a] {
            return cities.count
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var section = indexPath.section
        var row = indexPath.row
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:"addCategoryCell")
        cell.selectionStyle =  .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        if self.resultSearchController.isActive {
            cell.textLabel?.text = filteredTableData[indexPath.row]
        } else {
            let lazyMapCollection = self.tabledata.keys.sorted()
            let stringArray = Array(lazyMapCollection)
            let a = stringArray[section]
            if let cities = self.tabledata[a] {
                cell.textLabel?.text = cities[row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let lazyMapCollection = self.tabledata.keys.sorted()
        let stringArray = Array(lazyMapCollection)
        let a = stringArray[section]
        return a
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.resultSearchController.isActive {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cityName = ""
        if self.resultSearchController.isActive {
            cityName = self.filteredTableData[indexPath.row]
            self.dismiss(animated: true)
        } else {
            let lazyMapCollection = self.tabledata.keys.sorted()
            let stringArray = Array(lazyMapCollection)
            let a = stringArray[indexPath.section]
            if let cities = self.tabledata[a] {
                cityName = cities[indexPath.row]
            }
        }
        MainViewModel.shared.setCityToSearch(cityName)
        self.dismiss(animated: true)
    }
}

//MARK: - UPDATE RESULT
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text ?? "")
        let cities = self.tabledata.map { $0.1 }.flatMap({$0})
        let array = (cities as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        filteredTableData = Array(Set(filteredTableData))
        self.tableView.reloadData()
    }
}
