//
//  ContentEntity.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation
import CoreData

@objc(ContentEntity)
public class ContentEntity: NSManagedObject {

    @nonobjc class func fetch() -> NSFetchRequest<ContentEntity> {
        return NSFetchRequest<ContentEntity>(entityName: "ContentEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var created: Double
    
}

extension ContentEntity: Identifiable {
    
}
