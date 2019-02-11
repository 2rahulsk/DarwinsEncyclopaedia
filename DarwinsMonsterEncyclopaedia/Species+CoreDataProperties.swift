//
//  Species+CoreDataProperties.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import Foundation
import CoreData


extension Species {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Species> {
        return NSFetchRequest<Species>(entityName: "Species")
    }

    @NSManaged public var speciesName: String?
    @NSManaged public var speciesType: String?
    @NSManaged public var toMonster: NSSet?

}

// MARK: Generated accessors for toMonster
extension Species {

    @objc(addToMonsterObject:)
    @NSManaged public func addToToMonster(_ value: Monster)

    @objc(removeToMonsterObject:)
    @NSManaged public func removeFromToMonster(_ value: Monster)

    @objc(addToMonster:)
    @NSManaged public func addToToMonster(_ values: NSSet)

    @objc(removeToMonster:)
    @NSManaged public func removeFromToMonster(_ values: NSSet)

}
