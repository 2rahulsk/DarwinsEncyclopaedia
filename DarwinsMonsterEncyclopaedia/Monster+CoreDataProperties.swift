//
//  Monster+CoreDataProperties.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import Foundation
import CoreData


extension Monster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Monster> {
        return NSFetchRequest<Monster>(entityName: "Monster")
    }

    @NSManaged public var age: Int16
    @NSManaged public var attackPower: Int32
    @NSManaged public var health: Int32
    @NSManaged public var monsterName: String?
    @NSManaged public var species: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var toSpecies: Species?
    @NSManaged public var toImage: Image?

}
