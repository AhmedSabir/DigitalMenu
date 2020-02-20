//
//  Themes_new+CoreDataProperties.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 2/9/20.
//  Copyright © 2020 One World United. All rights reserved.
//
//

import Foundation
import CoreData


extension Themes_new {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Themes_new> {
        return NSFetchRequest<Themes_new>(entityName: "Themes_new")
    }

    @NSManaged public var back_Button_Background_Color: String?
    @NSManaged public var back_Button_Font_Color: String?
    @NSManaged public var brandID: Int32
    @NSManaged public var category_Background_Color: String?
    @NSManaged public var category_Button_Active_Img: String?
    @NSManaged public var category_Button_In_Active_Img: String?
    @NSManaged public var category_Font_Color: String?
    @NSManaged public var category_Font_Color_as_Heading: String?
    @NSManaged public var category_Screen_Wallpaper: String?
    @NSManaged public var feedback_Button_Background_Color: String?
    @NSManaged public var feedback_Button_Font_Color: String?
    @NSManaged public var home_Screen_Wallpaper: String?
    @NSManaged public var id: Int32
    @NSManaged public var item_Background_Color: String?
    @NSManaged public var item_Detail_Background_color: String?
    @NSManaged public var item_Detail_Ingredient_Font_Color: String?
    @NSManaged public var item_Detail_Item_Font_Color: String?
    @NSManaged public var item_Detail_Price_Font_Color: String?
    @NSManaged public var item_Detail_Screen_Wallpaper: String?
    @NSManaged public var item_Font_Color: String?
    @NSManaged public var item_Price_Font_Color: String?
    @NSManaged public var item_Screen_Wallpaper: String?
    @NSManaged public var items_buttons_image_fit: String?
    @NSManaged public var language_Button_Background_Color: String?
    @NSManaged public var language_Button_Font_Color: String?
    @NSManaged public var menu_Button_Background_Color: String?
    @NSManaged public var menu_Button_Font_Color: String?
    @NSManaged public var menu_Button_GIF: String?

}
