//
//  DBSet.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 2/9/20.
//  Copyright © 2020 One World United. All rights reserved.
//

import Foundation
class DBSet {
    
    
    func SaveSetting (settingsData : SettingDataCore)
    {

        SkopelosClient.shared.writeSync { context in
            let brands = SettingDataCore.SK_all(context)
            brands.forEach { setting in
                setting.SK_remove(context)
            }
            
            
            let Setting = SettingDataCore.SK_create(context)
            Setting.ipAddress = settingsData.ipAddress
            Setting.password = settingsData.password
            Setting.port = settingsData.port
            Setting.second = settingsData.second
            Setting.branchName = settingsData.branchName
            
            DBGet.gblSettings.ipAddress=settingsData.ipAddress
            DBGet.gblSettings.port = settingsData.port
            DBGet.gblSettings.password = settingsData.password
            DBGet.gblSettings.second=settingsData.second
            DBGet.gblSettings.branchName=settingsData.branchName
        }
    }

    
    
    func SaveBrands (brandData : [Brand]){
        
        SkopelosClient.shared.writeSync { context in
            let brands = Brands.SK_all(context)
            brands.forEach { setting in
                setting.SK_remove(context)
            }
        }
        let dispatchGroup = DispatchGroup()
        for each in brandData {
            SkopelosClient.shared.writeSync { context in
                let brand = Brands.SK_create(context)
                brand.brandID =  Int32(each.brandID!)
                brand.brandLogo = each.brandLogo
                brand.brandName = each.brandName
                brand.brandNameAra = each.brandNameAr
                brand.brandSeq = Int32(each.brandSeq!)
                brand.currency = each.currency
                brand.facebook = each.facebook
                brand.feedback = each.feedback == true ? 1 : 0
                brand.instagram = each.instagram
                brand.mandarin = Int32(each.mandarin!)
                brand.russian = Int32(each.russian!)
                brand.telephone = each.Telephone
                brand.themeID = Int32(each.themeID!)
                brand.orderTaking = each.orderTaking == true ? 1 : 0
                UserDefaults.standard.set(brand.currency, forKey: "cur")
                UserDefaults.standard.synchronize()
                DBGet.gblBrandsArray.append(brand)
                dispatchGroup.enter()
                ImageLoader_SDWebImage.downloadImage(brand.brandLogo) { (_, _) in
                    dispatchGroup.leave()
                }
            }
        }
        
        
        
    }
    
    
    //    func SaveLayout (layoutID: Int)
    //       {
    //
    //           SkopelosClient.shared.writeSync { context in
    //               self.listLayoutType.removeAll();
    //               let settings = LayoutType.SK_all(context)
    //               settings.forEach { setting in
    //                   setting.SK_remove(context)
    //               }
    //               let Setting = LayoutType.SK_create(context)
    //            Setting.layoutId = Int16(layoutID)
    //            Setting.password = settingString.password
    //            Setting.themeID =  Int16(Brandhelper.themeID)
    //            Setting.feedbackID = Int16(Brandhelper.feedBack)
    //            Setting.brandID = Int16(Brandhelper.brandID)
    //               self.listLayoutType.append(Setting)
    //           }
    //       }
    
    
    
}
