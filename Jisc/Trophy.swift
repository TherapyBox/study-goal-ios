//
//  Trophy.swift
//  Jisc
//
//  Created by Therapy Box on 1/6/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import Foundation
import CoreData

let trophyEntityName = "Trophy"

class Trophy: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

	func loadDictionary(_ dictionary:NSDictionary) {
		activityName = stringFromDictionary(dictionary, key: "activity_name")
		count = stringFromDictionary(dictionary, key: "count")
		id = stringFromDictionary(dictionary, key: "id")
		statement = stringFromDictionary(dictionary, key: "statement")
		name = stringFromDictionary(dictionary, key: "trophy_name")
		type = stringFromDictionary(dictionary, key: "type")
	}
	
	class func insertInManagedObjectContext(_ context:NSManagedObjectContext, dictionary:NSDictionary) -> Trophy {
		let fetchRequest:NSFetchRequest<Trophy> = NSFetchRequest(entityName: trophyEntityName)
		fetchRequest.predicate = NSPredicate(format: "id == %@", stringFromDictionary(dictionary, key: "id"))
		var trophy:Trophy?
		do {
			try trophy = managedContext.fetch(fetchRequest).first
			if (trophy == nil) {
				trophy = Trophy.newTrophy(dictionary)
			} else {
				trophy!.loadDictionary(dictionary)
			}
		} catch {
			trophy = Trophy.newTrophy(dictionary)
		}
		return trophy!
	}
	
	fileprivate class func newTrophy(_ dictionary:NSDictionary) -> Trophy {
		let entity = NSEntityDescription.entity(forEntityName: trophyEntityName, in:managedContext)
		let trophy:Trophy = NSManagedObject(entity: entity!, insertInto: managedContext) as! Trophy
		trophy.loadDictionary(dictionary)
		return trophy
	}
	
	func descriptionText() -> String {
//		let descriptionText = "\(count) of \(activityName) in \(days) days"
		let descriptionText = statement
		return descriptionText
	}
}
