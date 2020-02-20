//
//  ItemsCoreData+CoreDataProperties.swift
//  
//
//  Created by Hightech on 27/08/19.
//
//

import Foundation
import CoreData


extension ItemsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemsCoreData> {
        return NSFetchRequest<ItemsCoreData>(entityName: "ItemsCoreData")
    }

    @NSManaged public var brandID: Int32
    @NSManaged public var catID: Int32
    @NSManaged public var catName: String?
    @NSManaged public var catNameAra: String?
    @NSManaged public var catNameMan: String?
    @NSManaged public var catNameRus: String?
    @NSManaged public var catSeq: Int32
    @NSManaged public var imageGIF: NSData?
    @NSManaged public var imageName: String?
    @NSManaged public var ingredientAra: String?
    @NSManaged public var ingredientBangladeshi: String?
    @NSManaged public var ingredientChinese: String?
    @NSManaged public var ingredientEng: String?
    @NSManaged public var ingredientIranian: String?
    @NSManaged public var ingredientItalian: String?
    @NSManaged public var ingredientKorean: String?
    @NSManaged public var ingredientMan: String?
    @NSManaged public var ingredientPhilippines: String?
    @NSManaged public var ingredientRus: String?
    @NSManaged public var ingredientSpain: String?
    @NSManaged public var ingredientSrilanka: String?
    @NSManaged public var ingredientTurkish: String?
    @NSManaged public var ingredientUrdu: String?
    @NSManaged public var ingridentFrench: String?
    @NSManaged public var ingridentGermany: String?
    @NSManaged public var ingridentHindi: String?
    @NSManaged public var isCheck: Int32
    @NSManaged public var isFav: Int32
    @NSManaged public var isVideo: String?
    @NSManaged public var itemID: Int32
    @NSManaged public var itemName: String?
    @NSManaged public var itemNameAr: String?
    @NSManaged public var itemNamebangladeshi: String?
    @NSManaged public var itemNameChinese: String?
    @NSManaged public var itemNameFrench: String?
    @NSManaged public var itemNameGermany: String?
    @NSManaged public var itemNameHindi: String?
    @NSManaged public var itemNameIranian: String?
    @NSManaged public var itemNameItalian: String?
    @NSManaged public var itemNameKorean: String?
    @NSManaged public var itemNameMan: String?
    @NSManaged public var itemNamePhilippines: String?
    @NSManaged public var itemNameRus: String?
    @NSManaged public var itemNameSpain: String?
    @NSManaged public var itemNameSrilanka: String?
    @NSManaged public var itemNameTurkish: String?
    @NSManaged public var itemNameUrdu: String?
    @NSManaged public var itemSeq: Int32
    @NSManaged public var orderItemID: Int32
    @NSManaged public var price: String?
    @NSManaged public var qty: Int32
    @NSManaged public var video: String?
    @NSManaged public var isOtherLanguages: String?

}
