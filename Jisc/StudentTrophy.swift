//
//  StudentTrophy.swift
//  Jisc
//
//  Created by Therapy Box on 1/6/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import Foundation
import CoreData

let studentTrophyEntityName = "StudentTrophy"

class StudentTrophy: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
	
	func setInformation(_ ID:String, trophyTotal:Int, studentID:String) {
		id = ID
		total = trophyTotal as NSNumber
		let fetchRequest:NSFetchRequest<Trophy> = NSFetchRequest(entityName: trophyEntityName)
		fetchRequest.predicate = NSPredicate(format: "id == %@", ID)
		var trophyWithID:Trophy?
		do {
			try trophyWithID = managedContext.fetch(fetchRequest).first
		} catch let error as NSError {
			print("StudentTrophy creation: trophy with id: \(ID) was not found.\nError: \(error.localizedDescription)\n\n")
		}
		if (trophyWithID != nil) {
			trophy = trophyWithID!
		}
		let fetchRequest2:NSFetchRequest<Student> = NSFetchRequest(entityName: studentEntityName)
		fetchRequest2.predicate = NSPredicate(format: "id == %@", studentID)
		var student:Student?
		do {
			try student = managedContext.fetch(fetchRequest2).first
		} catch let error as NSError {
			print("StudentTrophy creation: student with id: \(studentID) was not found.\nError: \(error.localizedDescription)\n\n")
		}
		if (student != nil) {
			owner = student!
		}
	}
	
	class func insertInManagedObjectContext(_ context:NSManagedObjectContext, ID:String, trophyTotal:Int, studentID:String) -> StudentTrophy {
		let fetchRequest:NSFetchRequest<StudentTrophy> = NSFetchRequest(entityName: studentTrophyEntityName)
		fetchRequest.predicate = NSPredicate(format: "id == %@ AND total == %d AND owner.id == %@", ID, trophyTotal, studentID)
		var studentTrophy:StudentTrophy?
		do {
			try studentTrophy = managedContext.fetch(fetchRequest).first
			if (studentTrophy == nil) {
				studentTrophy = StudentTrophy.newStudentTrophy(ID, trophyTotal: trophyTotal, studentID: studentID)
			} else {
				studentTrophy!.setInformation(ID, trophyTotal: trophyTotal, studentID: studentID)
			}
		} catch {
			studentTrophy = StudentTrophy.newStudentTrophy(ID, trophyTotal: trophyTotal, studentID: studentID)
		}
		return studentTrophy!
	}
	
	fileprivate class func newStudentTrophy(_ ID:String, trophyTotal:Int, studentID:String) -> StudentTrophy {
		let entity = NSEntityDescription.entity(forEntityName: studentTrophyEntityName, in:managedContext)
		let studentTrophy:StudentTrophy = NSManagedObject(entity: entity!, insertInto: managedContext) as! StudentTrophy
		studentTrophy.setInformation(ID, trophyTotal: trophyTotal, studentID: studentID)
		return studentTrophy
	}

}
