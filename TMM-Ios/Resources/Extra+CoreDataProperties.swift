//
//  Extra+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Cisner iMac on 19/02/19.
//  Copyright © 2019 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension Extra {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Extra> {
        return NSFetchRequest<Extra>(entityName: "Extra")
    }

    @NSManaged public var extraID: Int32
    @NSManaged public var extraName: String?
    @NSManaged public var extraNameArabic: String?
    @NSManaged public var imageName: String?
    @NSManaged public var itemID: Int32
    @NSManaged public var price: String?
    @NSManaged public var brandId: Int32

}
