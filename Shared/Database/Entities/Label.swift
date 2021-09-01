//
//  Label.swift
//  Magic
//
//  Created by Alexander Skorulis on 1/9/21.
//

import CoreData
import Foundation

@objc(Label)
public class Label: NSManagedObject {

    @nonobjc class func fetch() -> NSFetchRequest<Label> {
        return NSFetchRequest<Label>(entityName: "Label")
    }

    @NSManaged public var name: String
    @NSManaged public var content: Set<ContentEntity>
    
}

extension Label: Identifiable {
    
    public var id: String { name }
    
}
