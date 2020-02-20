//
//  BrandsAndThemes.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 2/19/20.
//  Copyright © 2020 One World United. All rights reserved.
//

import Foundation

struct BrandThemeModel : Codable {
    var theme : [Theme]?
    var brand : [Brand]?
}

struct Theme : Codable {
    var separatorLine : String?
    var leftArrow : String?
    var leftBottom : String?
    var leftTop : String?
    var rightArrow : String?
    var rightBottom : String?
    var rightTop : String?
    var brandID : Int?
    var themeName : String?
    var themeID : Int?
    var categoryActive : String?
    var categoryInActive : String?
    var setting : String?
    var englishButton : String?
    var arabicButton : String?
    var mandarinButton : String?
    var russianButton : String?
    var closeButton : String?
    var homeScreen : String?
    var popUpBackground : String?
    var FontColor : String?
    var FontColorItemName : String?
    var FontColorIngName : String?
    var FontColorPrice : String?
    var itemBackgroundColor : String?
    var BrandName : String?

}
struct Brand : Codable {
    var brandSeq : Int?
    var brandName : String?
    var brandNameAr : String?
    var brandID : Int?
    var russian : Int?
    var mandarin : Int?
    var themeID : Int?
    var brandLogo : String?
    var feedback : Bool?
    var currency : String?
    var Telephone : String?
    var facebook : String?
    var instagram : String?
    var orderTaking : Bool?
    var IsOtherLanguages : Int?

}
