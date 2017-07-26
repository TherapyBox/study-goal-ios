//
//  StudentTrophy+CoreDataProperties.swift
//  Jisc
//
//  Created by Therapy Box on 1/6/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StudentTrophy {
	
	@NSManaged var id: String
	@NSManaged var total: NSNumber
	@NSManaged var trophy: Trophy
	@NSManaged var owner: Student
	
}
