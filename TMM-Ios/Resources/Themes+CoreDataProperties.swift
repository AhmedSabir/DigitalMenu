//
//  Themes+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Mitesh on 9/20/19.
//  Copyright © 2019 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension Themes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Themes> {
        return NSFetchRequest<Themes>(entityName: "Themes")
    }

    @NSManaged public var arabicButton: String?
    @NSManaged public var background: String?
    @NSManaged public var categoryActive: String?
    @NSManaged public var categoryInactive: String?
    @NSManaged public var englishButton: String?
    @NSManaged public var fontColor: String?
    @NSManaged public var fontColorIngName: String?
    @NSManaged public var fontColorItemName: String?
    @NSManaged public var fontColorPrice: String?
    @NSManaged public var itemBackgroundColor: String?
    @NSManaged public var leftArrow: String?
    @NSManaged public var popupBackground: String?
    @NSManaged public var promotion: String?
    @NSManaged public var rightTop: String?
    @NSManaged public var separatorLine: String?
    @NSManaged public var setting: String?
    @NSManaged public var themeID: Int32
    @NSManaged public var themeName: String?
    @NSManaged public var attribute: NSObject?
    @NSManaged public var homeScreen: String?

}
