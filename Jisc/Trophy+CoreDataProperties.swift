//
//  Trophy+CoreDataProperties.swift
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

extension Trophy {
	
	@NSManaged var activityName: String
	@NSManaged var count: String
	@NSManaged var id: String
	@NSManaged var name: String
	@NSManaged var statement: String
	@NSManaged var type: String
	@NSManaged var studentTrophies: NSSet
	
}
