//
//  Webservices.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 1/27/20.
//  Copyright © 2020 One World United. All rights reserved.
//
import Foundation
//Common.init()

var webUrl =  DBGet.gblSettings.ipAddress
var port =  DBGet.gblSettings.port


var GetBrandsURL = "http://\(webUrl!):\(port)/mobile/getbrands"
var GetItemsURL = "http://\(webUrl!):\(port)/mobile/item"
var GetCategoriesURL = "http://\(webUrl!):\(port)/mobile/Category"
var GetFeedbackURL = "http://\(webUrl!):\(port)/mobile/GetFeedback"

//?brandID=1

enum webserviceType {
    case brands
    case items
    case categories
    case feedback
    case themes
}

