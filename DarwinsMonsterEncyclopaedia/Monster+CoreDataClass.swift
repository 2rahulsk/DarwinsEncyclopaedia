//
//  Monster+CoreDataClass.swift
//  DarwinsMonsterEncyclopaedia
//
//  Created by Rahul Krishnan on 7/4/17.
//  Copyright © 2017 Rahul Krishnan. All rights reserved.
//

import Foundation
import CoreData


public class Monster: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }

}
