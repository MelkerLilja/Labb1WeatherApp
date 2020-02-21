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
    

    
    // Init för en searchController
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // It is possible to do the following three things in the Interface Builder
        // rather than in code if you prefer.
        // Delegate för tableView, dataSource, searchResult
        
        searchController.searchResultsUpdater = self
        
        // behöver sätta denna till false för att den fördunkar när man söker så man inte kan
        // klicka på en cell. ETT MÅSTE!
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search for a city here"
        
        // Vår navigationcontroller har ett item för searchController, därför hittar vi den där
        // Detta är för att searchbaren ska synas.
        
        navigationItem.searchController = searchController
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
 
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        print("Search text: \(searchText)")
        // $0 är att den tar in varje ord i vår array
        // Filter är en loop. Så den går genom varje element i vår array
        filteredCities = cities.filter( { $0.lowercased().contains(searchText.lowercased()) } )
        
        tableView.reloadData()
    }
    
}

// Extension är en utbyggnad av något. I det här fallet en utbyggnad utav ViewController
// Där vi bryter ut delegate och dataSource. Extensions kan ta in protokoll som den måste följa
// Delegate är ett objekt, ett protokoll är ett typ av en funktion som ett objekt kan utföra. Delegate är objektet som kommer utföra jobbet.

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredCities.count
        }
        return notSearching.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
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
        
        print("You tapped cell number \(indexPath.row).")
        
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


/*

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.city.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        struct staticVariable { static var tableIdentifier = "TableIdentifier" }
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(
            withIdentifier: staticVariable.tableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: staticVariable.tableIdentifier)
        }
        
        cell?.textLabel?.text = self.city[indexPath.row]
        
        cell?.detailTextLabel?.text = self.num[indexPath.row]

        return cell!
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexCity = city[indexPath.row]
        
        print("You tapped cell number \(indexPath.row).")
        
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? DetailViewController {
                targetController.titleText = self.indexCity
            }
        }
    }

    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // remove the item from the data model
            city.remove(at: indexPath.row)

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    

}

*/
