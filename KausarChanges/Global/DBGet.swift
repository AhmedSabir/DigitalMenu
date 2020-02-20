//
//  Helper.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 2/4/20.
//  Copyright © 2020 One World United. All rights reserved.
//

import Foundation
import CoreData
//singleton pattern

class DBGet{
    private static var ItemsArray : [String] = []
    public static var gblSettings = SettingDataCore()
    public static var gblBrandsArray : [Brands]  = []
    private static var ThemesArray : [Themes_new] = []
    
    
    func getItems() ->  [String]{
        if(DBGet.ItemsArray.count == 0){//fetch from DB
            DBGet.ItemsArray.append("kausar")
            print("new items")
            return  DBGet.ItemsArray
        } else {
            print("exisiting items")
            return DBGet.ItemsArray
        }
    }
    
    func getBrands () -> [Brands]{
        if(DBGet.gblBrandsArray.count == 0){//fetch from DB
            
            UserDefaults.standard.removeObject(forKey: "lang")
                   UserDefaults.standard.set("eng", forKey: "lang")
                   UserDefaults.standard.synchronize()
                   
                   SkopelosClient.shared.read { context in
                       let BrandData = Brands.SK_all(context)
                       DBGet.gblBrandsArray = BrandData
                   }
            return  DBGet.gblBrandsArray
        } else {
            print("exisiting Brands")
            return DBGet.gblBrandsArray
        }
    }
    
    func getThemes () -> [Themes_new]{
        if(DBGet.ThemesArray.count == 0){//fetch from DB
            print("new items")
            return  DBGet.ThemesArray
        } else {
            print("exisiting items")
            return DBGet.ThemesArray
        }
    }
    
//    func getSettingss () -> SettingDataCore
//        {
//            var gblSettings = SettingDataCore()
//            
//            SkopelosClient.shared.read { context in
//                
//                
//                let SettingData = SettingDataCore.SK_all(context)
//                if SettingData.isEmpty {
//                    SkopelosClient.shared.writeAsync
//                                               {
//                                                   context in
//                                                   i.ipAddress = "192.168.1.7"
//                                           }
//                }
//                for i in SettingData
//                {
//                    
//                    if  i.ipAddress == nil
//                    {
//                       
//                    }
//                    //                    print(SettingData.count)
//                    
//                }
//                
//            }
//         
//                print("exisiting items")
//    //            return gblSettings
//    //        }
//               return gblSettings
//        }
    
    func getSettings () -> SettingDataCore{
        

        
        var settings = SettingDataCore()
      //fetch from SettingsArray
            SkopelosClient.shared.read { context in
                let SettingData = SettingDataCore.SK_all(context)
                //initializing the first launch of the app
                if(SettingData.isEmpty )
                {
                    SkopelosClient.shared.writeAsync
                        { context in
                    
                   let Setting = SettingDataCore.SK_create(context)
                          Setting.ipAddress = "192.178.168.52"
                          Setting.password = "test"
                          Setting.port = 80
                          Setting.second = 70
                          Setting.branchName = "Kuwait"
                    }
                    
                  //  DBGet.gblSettings = settings
//                    DBSet().SaveSetting(settingsData: DBGet.gblSettings)
                    UserDefaults.standard.set(String(format: "%.f", settingString.second), forKey: "second")
                    UserDefaults.standard.set(settingString.branchName, forKey: "branchName")
                    UserDefaults.standard.synchronize()
                }else{
                    DBGet.gblSettings = SettingData[0]
                    print ("port is \(DBGet.gblSettings.port)")
                    UserDefaults.standard.set(String(format: "%.f", DBGet.gblSettings.second), forKey: "second")
                    UserDefaults.standard.synchronize()
                }
                
            }
            return DBGet.gblSettings
         
    }
//    func getSettings () -> SettingDataCore
//    {
//        var gblSettings = SettingDataCore()
//
//        SkopelosClient.shared.read { context in
//            let SettingData = SettingDataCore.SK_all(context)
//             for i in SettingData
//             {
//                if  i.ipAddress == nil
//                {
//                SkopelosClient.shared.writeAsync { context in
//                SettingData[0].ipAddress = "192.168.1.7"
//                }
//                }
//                print(SettingData.count)
//
//            }
//
//        }
    
}
