//
//  ViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-06.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    // These strings will be the data for the table view cells
    var cities: [String] = cityListJson()
    var filteredCities: [String] = []
    var notSearching: [String] = []
    let cellReuseIdentifier = "myCell"
    var searchedCity = ""

    @IBOutlet var tableView: UITableView!
    
    var isSearching: Bool {
        if filteredCities.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self

        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search for a city here"
        
        navigationItem.searchController = searchController
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        filteredCities = cities.filter( { $0.lowercased().contains(searchText.lowercased()) } )
        
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredCities.count
        }
        return notSearching.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell( withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if isSearching {
            cell.textLabel?.text = filteredCities[indexPath.row]
        } else {
            cell.textLabel?.text = notSearching[indexPath.row]
        }
        
        
        return cell
     }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchedCity = filteredCities[indexPath.row]
        
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "detailSegue" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? DetailViewController {
                targetController.titleText = searchedCity
            }
        }
 
    }
}

func cityListJson() -> [String] {
    
    let fileName: String = "citylist"
    
    do {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data.init(contentsOf: file)
            let decoder = JSONDecoder()
            let cityList: [String] = try decoder.decode([String].self, from: data)
            return cityList
        }
    } catch {
        print("Json error")
    }
    return [String]()
}
