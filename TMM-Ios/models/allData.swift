//
//  settingData.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 7/3/18.
//  Copyright © 2018 One World United. All rights reserved.
//
class settingData {
    
    var ip: String?
    var port: Int
    var password: String?
    
    init(ip: String?, port: Int, password: String?){
        self.ip = ip
        self.port = port
        self.password = password
    }
}

class CategoryViewData{
    
    var CategoryID: Int32
        var CategoryName: String?
        var CategoryAra: String?
    init(CategoryID:  Int32, CategoryName: String?,CategoryAra: String? ){
                self.CategoryID = CategoryID
                 self.CategoryName = CategoryName
                 self.CategoryAra = CategoryAra
     
            }
}
