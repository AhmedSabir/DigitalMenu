//
//  SlideShow+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/16/18.
//  Copyright © 2018 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension SlideShow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SlideShow> {
        return NSFetchRequest<SlideShow>(entityName: "SlideShow")
    }

    @NSManaged public var imageName: String?

}
