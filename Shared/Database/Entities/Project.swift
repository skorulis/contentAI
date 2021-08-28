//
//  Project.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import CoreData
import Foundation

@objc(Project)
public class Project: NSManagedObject {

    @nonobjc class func fetch() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var source: String
    
}

extension Project: Identifiable {
    
}
