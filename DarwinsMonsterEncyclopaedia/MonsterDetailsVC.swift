//
//  MonsterDetailsVCViewController.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import UIKit
import CoreData

class MonsterDetailsVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var speciesPicker: UIPickerView!
    
    @IBOutlet weak var monsterName: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var health: UITextField!
    
    @IBOutlet weak var attackPower: UITextField!
    
    @IBOutlet weak var monsterDesc: UITextField!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    var speciesList = [Species]()
    
    var monsters = [Monster]()
    
    var monsterToEdit :Monster?
    
    var imagepicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        speciesPicker.dataSource = self
        speciesPicker.delegate = self
        
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
        monsters = getMonsters()
        // check done so thet the speciesPicker values are not having duplicate values
        if monsters.count > 0 {
            
            getSpecies()
            
        } else {
            
            loadSpecies()
            getSpecies()
        }
        
        if monsterToEdit != nil {
            
            showDetails()
        }
    }

   
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let species = speciesList[row]
        
        return species.speciesName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speciesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //
    }
    
    func getSpecies() {
        
        let fetchRequest : NSFetchRequest<Species> = Species.fetchRequest()
        
        do {
            
            self.speciesList = try context.fetch(fetchRequest)
            self.speciesPicker.reloadAllComponents()
            
        } catch {
            //handle error
        }
        
    }
    
    func getMonsters() -> [Monster] {
        
        var list = [Monster]()
        let fetchRequest : NSFetchRequest<Monster> = Monster.fetchRequest()
        
        do {
            
            list = try context.fetch(fetchRequest)
            //self.speciesPicker.reloadAllComponents()
        
        } catch {
            //handle error
        }
        return list
    }
    

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
        
        if (validateMonster() == true) {
            
            var monster : Monster!
            
            let pic = Image(context: context)
            pic.image = thumbImage.image
            
            //monster = new Monster()
            
            if monsterToEdit == nil {
                monster = Monster(context: context)
            } else {
                
                monster = monsterToEdit
            }
            
            monster.toImage = pic
            monster.monsterName = monsterName.text
            
            if let monsterAge = age.text {
                
                monster.age = Int16((monsterAge as NSString).integerValue)
                //print("age\(monster.age)")
            }
            
            if let monsterHealth = health.text {
                
                monster.health = (monsterHealth as NSString).intValue
            }
            
            if let monsterPower = attackPower.text {
                
                monster.attackPower = (monsterPower as NSString).intValue
            }
            
            
            // monster.health = Int(health.text!)
            // monster.attackPower = Int(attackPower.text!)
            monster.desc = monsterDesc.text
            
            monster.toSpecies = speciesList[speciesPicker.selectedRow(inComponent: 0)]

            
            ad.saveContext()
            
            navigationController?.popViewController(animated: true)
            
        }
        
       
        
    }
    
    func showDetails() {
        
        if let monster = monsterToEdit {
            
            monsterDesc.text = monster.desc
            monsterName.text = monster.monsterName
            age.text = "\(monster.age)"
            health.text = "\(monster.health)"
            attackPower.text = "\(monster.attackPower)"
            
            thumbImage.image = monster.toImage?.image as? UIImage
            
            if let species = monster.toSpecies {
                var index = 0
                repeat {
                    let s = speciesList[index]
                    if s.speciesName == species.speciesName {
                        
                        speciesPicker.selectRow(index, inComponent: 0, animated: false)
                        break
                        
                    }
                    index += 1
                } while(index < speciesList.count)
            }
        }
        
        
    }
    
    func loadSpecies() {
        let m1 = Species(context: context)
        m1.speciesName = "Grass"
        m1.speciesType = "G"
        
        let m2 = Species(context: context)
        m2.speciesName = "Electric"
        m2.speciesType = "E"
        
        let m3 = Species(context: context)
        m3.speciesName = "Water"
        m3.speciesType = "W"
        
        let m4 = Species(context: context)
        m4.speciesName = "Fire"
        m4.speciesType = "F"
        
        let m5 = Species(context: context)
        m5.speciesName = "Poison"
        m5.speciesType = "P"
        
        ad.saveContext()
    }
   
    
    @IBAction func deleteMonster(_ sender: UIBarButtonItem) {
    
        if monsterToEdit != nil {
            context.delete(monsterToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func validateMonster() -> Bool {
        
        var val = true
        let trimmedString = monsterName.text?.trimmingCharacters(in: .whitespaces)
        if (trimmedString?.isEmpty)! {
            monsterName.attributedPlaceholder = NSAttributedString(string: "Please enter a valid name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
        } else if (age.text?.isEmpty)!{
            age.attributedPlaceholder = NSAttributedString(string: "Please enter a valid age for monster", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
            
        }else if (Int16((age.text! as NSString).integerValue) < 0 || Int16((age.text! as NSString).integerValue) > 100) {
            //age.text = "Please enter a valid age from 0 to 100";
            //age.textColor = UIColor.red
            age.attributedPlaceholder = NSAttributedString(string: "Please enter a valid age from 0 to 100", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
        }else if (health.text?.isEmpty)!{
            health.attributedPlaceholder = NSAttributedString(string: "Please enter a valid health value", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
        }else if (Int32((health.text! as NSString).integerValue) < 0) {
                health.attributedPlaceholder = NSAttributedString(string: "Please enter a valid health value", attributes: [NSForegroundColorAttributeName: UIColor.red])
            //health.text = "Please enter a valid health value";
            //health.textColor = UIColor.red
                val = false
            }
        else if (attackPower.text?.isEmpty)!{
            attackPower.attributedPlaceholder = NSAttributedString(string: "Please enter a valid attack power value", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
        }else if (Int32((attackPower.text! as NSString).integerValue) < 0) {
            attackPower.attributedPlaceholder = NSAttributedString(string: "Please enter a valid attack power value", attributes: [NSForegroundColorAttributeName: UIColor.red])
            //attackPower.text = "Please enter a valid attack power value";
            //attackPower.textColor = UIColor.red
            val = false
        }
        else if (monsterDesc.text?.isEmpty)!{
            monsterDesc.attributedPlaceholder = NSAttributedString(string: "Please enter a valid description", attributes: [NSForegroundColorAttributeName: UIColor.red])
            val = false
        }
        
        
        return val
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    

}
