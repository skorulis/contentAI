//
//  Project.swift
//  Magic
//
//  Created by Alexander Skorulis on 3/9/21.
//

import CoreData
import Foundation

@objc(Project)
public class Project: NSManagedObject {

    @nonobjc class func fetch() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String
    @NSManaged public var inputs: Set<ContentSource>
    
}

extension Project: Identifiable {
    
    public var id: String { name }
    
}