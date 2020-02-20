//
//  Brands+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Cisner iMac on 30/01/19.
//  Copyright © 2019 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension Brands {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Brands> {
        return NSFetchRequest<Brands>(entityName: "Brands")
    }

    @NSManaged public var brandID: Int32
    @NSManaged public var brandLogo: String?
    @NSManaged public var brandName: String?
    @NSManaged public var brandNameAra: String?
    @NSManaged public var brandSeq: Int32
    @NSManaged public var currency: String?
    @NSManaged public var facebook: String?
    @NSManaged public var feedback: Int32
    @NSManaged public var instagram: String?
    @NSManaged public var mandarin: Int32
    @NSManaged public var russian: Int32
    @NSManaged public var telephone: String?
    @NSManaged public var themeID: Int32
    @NSManaged public var orderTaking: Int32

}
