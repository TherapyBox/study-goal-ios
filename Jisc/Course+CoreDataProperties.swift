//
//  Course+CoreDataProperties.swift
//  Jisc
//
//  Created by Therapy Box on 8/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Course {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var student: Student

}
