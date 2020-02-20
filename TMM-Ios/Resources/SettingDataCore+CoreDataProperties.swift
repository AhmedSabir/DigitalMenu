//
//  SettingDataCore+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 12/12/18.
//  Copyright © 2018 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingDataCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingDataCore> {
        return NSFetchRequest<SettingDataCore>(entityName: "SettingDataCore")
    }

    @NSManaged public var ipAddress: String?
    @NSManaged public var password: String?
    @NSManaged public var port: Int32
    @NSManaged public var second: Float
    @NSManaged public var branchName: String?
}
