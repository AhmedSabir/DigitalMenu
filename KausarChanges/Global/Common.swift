//
//  Common.swift
//  TMM-Advanced
//
//  Created by Fida Hussain Arjun on 2/5/20.
//  Copyright © 2020 Fida Hussain Arjun. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct settingString
{
    static var Setting = String()
    static var ip = String()
    static var port = Int32()
    static var password = String()
    static var second = Float()
    static var branchName = String()
    static var TackingOrder = String()
}


class Common{

    func hexStringToUIColor (hex:String) -> UIColor {
           var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
           
           if (cString.hasPrefix("#")) {
               cString.remove(at: cString.startIndex)
           }
           
           if ((cString.count) != 6) {
               return UIColor.gray
           }
           
           var rgbValue:UInt64 = 0
           Scanner(string: cString).scanHexInt64(&rgbValue)
           
           return UIColor(
               red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
               green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
               blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
               alpha: CGFloat(1.0)
           )
       }
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
  
    
}
