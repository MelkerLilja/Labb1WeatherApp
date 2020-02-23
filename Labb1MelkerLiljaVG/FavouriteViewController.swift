//
//  FavouritesViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-21.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var headLabel: UILabel!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func compareButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "favSegue", sender: self)
    }
    
    let cellReuseIdentifier = "favCell"
    var favCities: [String] = []
    var favCitiesTemp: [String] = []
    var noFavourites: [String] = []
    var isChecked: [String] = []
    
    var favCity1: String = ""
    var favCity2: String = ""
    var favTemp1: Double = 0
    var favTemp2: Double = 0
    
    var isFavourite: Bool {
        if favCities.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isChecked.removeAll()
        compareButton.isHidden = true
        
        favCities = UserDefaults.standard.stringArray(forKey: "fav") ?? [String]()
        favCitiesTemp = UserDefaults.standard.stringArray(forKey: "favTemp") ?? [String]()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        headLabel.lineBreakMode = .byWordWrapping
        headLabel.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favCities = UserDefaults.standard.stringArray(forKey: "fav") ?? [String]()
        favCitiesTemp = UserDefaults.standard.stringArray(forKey: "favTemp") ?? [String]()
        isChecked.removeAll()
        tableView.reloadData()
        compareButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CompareViewController
        {
            let vc = segue.destination as? CompareViewController
            vc?.favCity1 = self.favCity1
            vc?.favCity2 = self.favCity2
            vc?.favTemp1 = self.favTemp1
            vc?.favTemp2 = self.favTemp2
        }
   }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavourite {
            return favCities.count
        }
        return noFavourites.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        cell.tintColor = .orange
        cell.selectionStyle = .none
        
        if isFavourite {
            cell.textLabel?.text = favCities[indexPath.row]
            if favCitiesTemp[indexPath.row].contains("°C"){
                cell.detailTextLabel?.text = favCitiesTemp[indexPath.row]
            } else {
                cell.detailTextLabel?.text = "\(favCitiesTemp[indexPath.row])°C"
            }
            
        } else {
            cell.textLabel?.text = noFavourites[indexPath.row]
        }
        
        return cell
 
     }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                isChecked.removeAll { $0 == favCities[indexPath.row]}
                compareButton.isHidden = true
                if favCity1.isEqual(favCities[indexPath.row]) && favTemp1 == favCitiesTemp[indexPath.row].toDouble() {
                    favCity1 = ""
                    favTemp1 = 0
                } else if favCity2.isEqual(favCities[indexPath.row]) && favTemp2 == favCitiesTemp[indexPath.row].toDouble() {
                    favCity2 = ""
                    favTemp2 = 0
                }
                
            } else {
                if isChecked.count < 2 {
                    cell.accessoryType = .checkmark
                    isChecked.append(favCities[indexPath.row])
                    
                    if favCity1.isEmpty {
                        favCity1 = favCities[indexPath.row]
                        favTemp1 = favCitiesTemp[indexPath.row].toDouble() ?? 0
                    } else if favCity2.isEmpty {
                        favCity2 = favCities[indexPath.row]
                        favTemp2 = favCitiesTemp[indexPath.row].toDouble() ?? 0
                    }
                    
                    if isChecked.count == 2 {
                        compareButton.isHidden = false
                    }
                } else {
                    cell.accessoryType = .none
                }
            }
        }
    }
}

extension String {
    func toDouble() -> Double? {
        let temp = self.replace(string: "°C", replacement: "")
        return NumberFormatter().number(from: temp)?.doubleValue
    }
}

