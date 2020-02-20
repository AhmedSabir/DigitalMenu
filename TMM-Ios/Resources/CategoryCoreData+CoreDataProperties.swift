//
//  CategoryCoreData+CoreDataProperties.swift
//  
//
//  Created by Hightech IT Solution Pvt Ltd on 21/08/19.
//
//

import Foundation
import CoreData


extension CategoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCoreData> {
        return NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
    }

    @NSManaged public var catID: Int32
    @NSManaged public var catNameAra: String?
    @NSManaged public var catNameEng: String?
    @NSManaged public var catNameMan: String?
    @NSManaged public var catNameRus: String?
    @NSManaged public var catSequence: Int32
    @NSManaged public var categoryNameBangladeshi: String?
    @NSManaged public var categoryNameChinese: String?
    @NSManaged public var categoryNameFrench: String?
    @NSManaged public var categoryNameGermany: String?
    @NSManaged public var categoryNameHindi: String?
    @NSManaged public var categoryNameIraninan: String?
    @NSManaged public var categoryNameItalian: String?
    @NSManaged public var categoryNameKorean: String?
    @NSManaged public var categoryNamePhilippines: String?
    @NSManaged public var categoryNameSpain: String?
    @NSManaged public var categoryNameSrilanka: String?
    @NSManaged public var categoryNameTurkish: String?
    @NSManaged public var categoryNameUrdu: String?

}
