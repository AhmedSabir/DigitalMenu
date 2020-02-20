//
//  dataRead.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 7/3/18.
//  Copyright © 2018 One World United. All rights reserved.
//
import SQLite3
class dataRead : DataHelper {
    
    struct settingString {
        static var Setting = String()
          static var ip = String()
          static var port = Int32()
          static var password = String()
        
    }
    struct Brandhelper {
      
        static var brandID = Int32()
      
        
    }
    func readValues(db:OpaquePointer) {
        
          var settings = [settingData]()
        settings.removeAll()
        let queryString = "SELECT * FROM tblSetting"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        print("select executed");
        while(sqlite3_step(stmt) == SQLITE_ROW){
             settingString.ip = String(cString: sqlite3_column_text(stmt, 0))
            settingString.password = String(cString: sqlite3_column_text(stmt, 2))
             settingString.port = sqlite3_column_int(stmt, 1)
            settingString.Setting = "http://"+settingString.ip+":"+String(settingString.port)
            
          // settings.append(Hero(id: Int(id), name: String(describing: name), powerRanking: Int(powerrank)))
            settings.append(settingData(ip: String(describing: settingString.ip ) ,port: Int(settingString.port),password: String(describing:  settingString.password )))
        }
        
        //self.tableViewHeroes.reloadData()
    }
    
    //brandID , brandSeq , themeID , mandarin , russian ,brandName ,brandNameAra ,brandImage
    func getBrands() -> [brandData] {
        
        var brands = [brandData]()
        brands.removeAll()
        let queryString = "SELECT * FROM tblBrands"
        
        var stmt:OpaquePointer?
          var db:OpaquePointer?
        let connectDB = dataInsert()
        db = connectDB.connectDatabase()
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
         
        }
        print("select executed get Brands");
        while(sqlite3_step(stmt) == SQLITE_ROW){
         let brandID = sqlite3_column_int(stmt, 0)
         let brandSeq = sqlite3_column_int(stmt, 1)
             let themeID = sqlite3_column_int(stmt, 2)
             let mandarin = sqlite3_column_int(stmt, 3)
             let russian = sqlite3_column_int(stmt, 4)
            let brandName = String(cString: sqlite3_column_text(stmt, 5))
            let brandNameAra = String(cString: sqlite3_column_text(stmt, 6))
              let brandImage = String(cString: sqlite3_column_text(stmt, 7))
         
            brands.append(brandData(brandID: brandID, brandSeq: brandSeq, themeID: themeID, mandarin: mandarin, russian:russian, brandName: brandName, brandNameAra: brandNameAra, brandImage: brandImage))
        }
       return brands
        //self.tableViewHeroes.reloadData()
    }
}
