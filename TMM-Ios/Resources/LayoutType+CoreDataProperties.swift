//
//  LayoutType+CoreDataProperties.swift
//  
//
//  Created by Fida Hussain Arjun on 1/1/20.
//
//

import Foundation
import CoreData


extension LayoutType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LayoutType> {
        return NSFetchRequest<LayoutType>(entityName: "LayoutType")
    }

    @NSManaged public var layoutId: Int16
    @NSManaged public var password: String?
    @NSManaged public var themeID: Int16
    @NSManaged public var brandID: Int16
    @NSManaged public var feedbackID: Int16

}
