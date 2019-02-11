//
//  ViewController.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var controller : NSFetchedResultsController<Monster>!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    //@IBOutlet weak var search: UISearchBar!
    
    var monsterList = [Monster]()
    
    var filteredList = [Monster]()
    
    var searchActive = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        monsterList = getMonsters()
        searchBar.delegate = self
        attemptFetch()
        
    }

  
    //Method to be implemented along with the protocols for table view which returns the number of sections present in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if let sections = controller.sections {
            
            return sections.count
        }
        else {
            return 0
        }
    }
    
    /*Method to be implemented along with the protocols for table view which returns the 
    number of rows present in each sectionHere, a check is made if the user is in search 
    mode or not, and the rows are updated based on that. */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        if searchActive {
            
            return filteredList.count
            
        } else {
            
            if let sections = controller.sections {
                
                let sectionInfo = sections[section]
                
                return sectionInfo.numberOfObjects
            }else {
                return 0
            }
        }
        
    }
    
    //This method updates the value of each of cell. A check is made if the user is in search mode
    // or not. If in search mode, filteredList is used for displaying the values.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterCell", for: indexPath) as! MonsterCell
        
        let monster : Monster
        //checks if in search mode
        if searchActive {
            //gets the each monster object in the filtered list
            monster = filteredList[indexPath.row]
            cell.configureCell(monster: monster)
        }
        else {
        
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        }
        
        return cell
    }
    
    // height of the row is made a fixed value.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 283
    }
    
    // This method configures the contents of the cell by calling the configureCell method in MonsterCell class
    //The actual monster values are used up in that method to display.
    func configureCell(cell : MonsterCell, indexPath : NSIndexPath){
        
        let monster = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(monster: monster)
    }
    
    //create a function to fetch data
    func attemptFetch() {
        
        
        //create a fetch request
        
        let fetchRequest : NSFetchRequest<Monster> = Monster.fetchRequest()
        
        // sort parameters are set as we are sorting based on date, name, health and attack Power values
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        let nameSort = NSSortDescriptor(key: "monsterName", ascending: true)
        
        let healthSort = NSSortDescriptor(key: "health", ascending: true)
        
        let attackSort = NSSortDescriptor(key: "attackPower", ascending: true)
        
        // Based on the selection of the segments the sort action is performed
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [nameSort]
            
        }else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [attackSort]
            
        } else if segment.selectedSegmentIndex == 3 {
            
            fetchRequest.sortDescriptors = [healthSort]
            
        }
        

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
        
        
    }
    
    //Everytime the controller is about to change its content, this method is called
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    //This  method is called after the controller had changed its content
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        monsterList = getMonsters()
    }
    
    // This method is called when a change in controller happens. Based on the type, the insert, update , delete or move operations 
    // are performed.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        case.delete:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                
                let cell = tableView.cellForRow(at: indexPath) as! MonsterCell
                
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                //tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        }
    }
    
    
    // method is called when a row is selected. Segue operation is performed after that
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let obj = controller.fetchedObjects , obj.count > 0 {
            let monster = obj[indexPath.row]
            //performing segue operation
            performSegue(withIdentifier: "MonsterDetailsVC", sender: monster)
        }
    }
    
    // segue operation is done based on if the user is in search mode or not.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchActive {
            
            let indexPath = self.tableView.indexPathForSelectedRow
            if indexPath != nil {
               //speciesDetailVC.species = self.speciesSearchResults?[indexPath!.row]
                if segue.identifier == "MonsterDetailsVC" {
                    if let destination = segue.destination as? MonsterDetailsVC {
                        
                        let monster = filteredList[(indexPath?.row)!]
                        destination.monsterToEdit = monster
                    }
                }
            }
        
        } else {
            
            if segue.identifier == "MonsterDetailsVC" {
                if let destination = segue.destination as? MonsterDetailsVC {
                    
                    if let monster = sender as? Monster {
                        destination.monsterToEdit = monster
                    }
                }
            }
        }
        
        
    }
    
    //generate test data used for testing the app before implementing the database.
    /*func generateTestData() {
        
        let m1 = Monster(context: context)
        m1.monsterName = "Bulbasaur"
        m1.age = 12
        m1.attackPower = 312
        m1.health = 1212
        m1.species = "Grass"
        m1.desc = "cute but dangerous"
        
        let m2 = Monster(context: context)
        m2.monsterName = "Charizard"
        m2.age = 15
        m2.attackPower = 3124
        m2.health = 12124
        m2.species = "Fire"
        m2.desc = "Dangerously effective"
    
        let m3 = Monster(context: context)
        m3.monsterName = "Pikachu"
        m3.age = 9
        m3.attackPower = 1124
        m3.health = 1344
        m3.species = "Lightning"
        m3.desc = "effective"
        
    }*/
    
    // returns the list of monsters present
    func getMonsters() -> [Monster] {
        
        var list = [Monster]()
        let fetchRequest : NSFetchRequest<Monster> = Monster.fetchRequest()
        
        do {
            
            list = try context.fetch(fetchRequest)
            
        } catch {
            //handle error
        }
        return list
    }

    
    // Everytime the segment changes its value, this method is called and the table contents are
    // reloaded after fetching the data.
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    //Search bar functionality is implemented here. A check is made if the user is 
    // in search mode or not and if the user is in search mode, a filteredList of monsters
    // is created  from the monster list present based on the input string in the searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            searchActive = false
            tableView.reloadData()
            
        } else {
            
            searchActive = true
            let lower = searchBar.text!.lowercased()
            // filter operation is done based on the input from search bar
            self.filteredList = self.monsterList.filter({( aSpecies: Monster) -> Bool in
        
            return (aSpecies.monsterName!.lowercased().range(of: lower.lowercased()) != nil)
            })
            tableView.reloadData()
        }
    }
   
    

}

