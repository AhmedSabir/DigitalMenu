//
//  FeedbackData+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 12/12/18.
//  Copyright © 2018 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension FeedbackData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedbackData> {
        return NSFetchRequest<FeedbackData>(entityName: "FeedbackData")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var mobie: String?
    @NSManaged public var que: String?
    @NSManaged public var resType: String?
    @NSManaged public var datetime: String?
    @NSManaged public var branchName: String?
    @NSManaged public var response: String?
    @NSManaged public var udid: String?

}
