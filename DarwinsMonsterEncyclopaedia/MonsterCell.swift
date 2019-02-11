//
//  MonsterCell.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import UIKit

class MonsterCell: UITableViewCell {

    @IBOutlet weak var imageThumb: UIImageView!
    
    @IBOutlet weak var monsterLbl: UILabel!
    
    @IBOutlet weak var speciesLbl: UILabel!
    
    @IBOutlet weak var ageLbl: UILabel!

    @IBOutlet weak var attackpowerLbl: UILabel!
    
    @IBOutlet weak var healthLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    @IBOutlet weak var attackValue: UILabel!
    
    func configureCell(monster: Monster) {
        
        monsterLbl.text = monster.monsterName
        speciesLbl.text = monster.species
        ageLbl.text = "Age: \(monster.age)"
        attackpowerLbl.text = "Attack Power: \(monster.attackPower)"
        healthLbl.text = "Health: \(monster.health)"
        descriptionLbl.text = monster.desc
        attackValue.text = "Attack Value: \(calculateAttackValue(power: monster.attackPower, health: monster.health))"
        imageThumb.image = monster.toImage?.image as? UIImage
        
    }
    
    func calculateAttackValue(power: Int32, health: Int32) -> Double {
        
        let attackValue = Double((power + health)/2 + power)
        
        return attackValue
    
    }
}
