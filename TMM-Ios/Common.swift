//
//  ImageLoader_SDWebImage.swift
//  TMM-Ios
//
//  Created by Aakash Srivastav on 05/12/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import Foundation

struct settingString {
    static var Setting = String()
    static var ip = String()
    static var port = Int32()
    static var password = String()
    static var second = Float()
    static var branchName = String()
    static var TackingOrder = String()
}
//enum webserviceType {
//    case brands
//    case items
//    case categories
//    case feedback
//}
final class Common {
    
    static func openURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func openFacebookURL(for string: String) {
        let url = URL(string: String(format: "https://www.facebook.com/%@", string))!
        if UIApplication.shared.canOpenURL(url) {
            openURL(url)
        } else {
            let url = URL(string: String(format:"fb://profile/%@",string))!
            openURL(url)
        }
    }
    
    static func openInstagramURL(for string: String) {
        let url = URL(string: String(format: "instagram://user?username=%@", string))!
        if UIApplication.shared.canOpenURL(url) {
            openURL(url)
        } else {
            let url = URL(string: String(format:"http://instagram.com/%@",string))!
            openURL(url)
        }
    }
    
    static func openCallURL(for string: String) {
        let url = URL(string: String(format: "tel://%@", string))!
        if UIApplication.shared.canOpenURL(url) {
            openURL(url)
        }
    }
    
//    func callBrandApi (for password: String){
//        var GetBrandsURL = "http://"+settingString.ip+":"+settingString.port+"/mobile/getBrands?password="+password
//        return GetBrandsURL
////        var GetItemsURL = "http://37.34.173.73:705/mobile/item?brandID=1"
////        var GetCategoriesURL = "37.34.173.73:705/mobile/Category?brandID=1"
////        var GetFeedbackURL = "37.34.173.73:705/mobile/GetFeedback?brandID=1"
//    }
    
    


    
    
}
