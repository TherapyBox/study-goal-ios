//
//  Course.swift
//  Jisc
//
//  Created by Therapy Box on 8/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import Foundation
import CoreData

let courseEntityName = "Course"

class Course: NSManagedObject {

	func loadDictionary(_ dictionary:NSDictionary) {
		if let keys = dictionary.allKeys as? [String] {
			if keys.count > 0 {
				id = keys[0]
				if let string = dictionary[id] as? String {
					name = string
				}
			}
		}
		print("dictionary: \(dictionary)")
		print("id: \(id)")
		print("name: \(name)")
	}
	
	class func insertInManagedObjectContext(_ context:NSManagedObjectContext, dictionary:NSDictionary) -> Course {
		let fetchRequest:NSFetchRequest<Course> = NSFetchRequest(entityName: courseEntityName)
		var moduleId = ""
		if let keys = dictionary.allKeys as? [String] {
			if keys.count > 0 {
				moduleId = keys[0]
			}
		}
		fetchRequest.predicate = NSPredicate(format: "id == %@", moduleId)
		var course:Course?
		do {
			try course = managedContext.fetch(fetchRequest).first
			if (course == nil) {
				course = Course.newCourse(dictionary)
			} else {
				course!.loadDictionary(dictionary)
			}
		} catch {
			course = Course.newCourse(dictionary)
		}
		return course!
	}
	
	fileprivate class func newCourse(_ dictionary:NSDictionary) -> Course {
		let entity = NSEntityDescription.entity(forEntityName: courseEntityName, in:managedContext)
		let course:Course = NSManagedObject(entity: entity!, insertInto: managedContext) as! Course
		course.loadDictionary(dictionary)
		return course
	}
	
}
