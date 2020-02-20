//
//  BrandViewController.swift
//  TMM-Advanced
//
//  Created by Fida Hussain Arjun on 2/5/20.
//  Copyright © 2020 Fida Hussain Arjun. All rights reserved.
//asdsad

import Foundation
import UIKit
import CoreData


class SettingViewController : UIViewController
{
    var mainScreen = UIView()
    var logoImage = UIImageView(image: UIImage(named: "logo"))
    var screenWidth = UIScreen.main.bounds.width
    var btnSetting = UIButton()
    var settings = SettingDataCore()
    var listBrands = [Brands]()
    let myCollectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
           let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
           layout.scrollDirection = .horizontal
           collection.backgroundColor = UIColor.gray
           collection.translatesAutoresizingMaskIntoConstraints = false
           collection.isScrollEnabled = true
           return collection
       }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        GetExistingData()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(BrandsCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        self.view.addSubview(myCollectionView)
        self.view.addSubview(mainScreen)
        self.view.addSubview(logoImage)
        self.view.addSubview(btnSetting)
        SetupView()
      
    }
    
    func GetExistingData(){
        self.settings=DBGet().getSettings()
        self.listBrands=DBGet().getBrands()
    }
    
    func SetupView(){
        mainScreen.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            mainScreen.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            mainScreen.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            mainScreen.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            mainScreen.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        mainScreen.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainScreen.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.topAnchor.constraint(equalTo: mainScreen.topAnchor).isActive = true
        logoImage.leadingAnchor.constraint(equalTo: mainScreen.leadingAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: screenWidth/4).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: screenWidth/6).isActive = true
        
        
        btnSetting.translatesAutoresizingMaskIntoConstraints = false
        btnSetting.topAnchor.constraint(equalTo: mainScreen.topAnchor,constant: 40).isActive = true
        btnSetting.trailingAnchor.constraint(equalTo: mainScreen.trailingAnchor,constant: -10).isActive = true
        btnSetting.widthAnchor.constraint(equalToConstant: screenWidth/10).isActive = true
        btnSetting.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnSetting.backgroundColor = Common().hexStringToUIColor(hex: "#9B4629")
        btnSetting.setTitle("Setting", for: .normal)
        btnSetting.setTitleColor(.white, for: .normal)
        btnSetting.layer.cornerRadius = 5
        btnSetting.addTarget(self, action: #selector(OnSettingClicked), for: .touchUpInside)
        
        
        
        
        myCollectionView.topAnchor.constraint(equalTo: logoImage.bottomAnchor,constant: 10).isActive = true
        myCollectionView.leadingAnchor.constraint(equalTo: mainScreen.leadingAnchor).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: mainScreen.trailingAnchor).isActive = true
        myCollectionView.heightAnchor.constraint(equalToConstant: screenWidth/10  ).isActive = true
        
    }
    @objc func OnSettingClicked()  {
        let alert = UIAlertController(title: "Login",
                                      message: "Insert Ip, Port and Password to Synchronise with your brand",
                                      preferredStyle: .alert)
        //self.lblDisplyPer.isHidden = true
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
            textField.text =  self.settings.ipAddress
            textField.placeholder = "Type IP adress"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.text =  "\(self.settings.port)"
            textField.keyboardType = .numberPad
            textField.placeholder = "Type your Port Number"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your password"
            textField.text =  self.settings.password
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
            
        }
        alert.addTextField { [weak self] textField -> Void in
            //TextField configuration
            textField.keyboardAppearance = .dark
            textField.keyboardType = .phonePad
            textField.placeholder = "Type second between 1 to 9"
            textField.text = "75"
            textField.textColor = UIColor.black
            //textField.text  = "3"
            textField.font = UIFont(name: "Calibri", size: 15)
            // textField.delegate = self
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Type your branchname"
            textField.text =  "kuwait"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
            
        }
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            
            
            
            self.settings.ipAddress = alert.textFields![0].text!
            let portstring = alert.textFields![1].text
            self.settings.port = Int32(portstring!)!
            self.settings.password = alert.textFields![2].text!
            self.settings.second = 7
            self.settings.branchName = "kuwait"
            UserDefaults.standard.set(alert.textFields![3].text!, forKey: "second")
            UserDefaults.standard.set(alert.textFields![4].text!, forKey: "branchName")
            UserDefaults.standard.synchronize()
            //settingString.Setting = "http://"+settingString.ip+":"+String(settingString.port)
            // self.settings.removeAll();
            
            DBSet().SaveSetting(settingsData: self.settings)
            
            self.getBrands(password: self.settings.password ?? "")
            self.viewWillAppear(true)
            
            
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
        })
        alert.addAction(loginAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    func getBrands(password:String ){
         
         API.callDictionaryAPI(webserviceFor: .brands, paramaters: ["password":password]) { (error, dataResponse) in
             if let data = dataResponse as? BrandThemeModel{
                 if (data.brand == nil){
                     //self.viewMainLayout.isHidden = true
                 ToastView.shared.long(self.view, txt_msg: "Invalid Password")
                 }
                 else{
                    
                    DBSet().SaveBrands(brandData: data.brand!)
                    self.listBrands = DBGet.gblBrandsArray
                    // self.viewMainLayout.isHidden = false
                    // self.listBrands.removeAll();
                     UserDefaults.standard.removeObject(forKey: "strTackingOrder")
                     UserDefaults.standard.synchronize()
                    
                 //    self.viewMainLayout.isHidden = false
                     let dispatchGroup = DispatchGroup()
                     dispatchGroup.notify(queue: .main) {
                         UIApplication.shared.endIgnoringInteractionEvents()
                         SkopelosClient.shared.read { context in
                          //   self.listBrands = Brands.SK_all(context)
                     //     self.getThemes(brandId: "\(self.listBrands[0].brandID)")
                         }
                     }
                 }
             }
                // case when data sync is failed
             else {
                 let name = UserDefaults.standard.string(forKey: "AppStatusCode")
                 print("statuscode : \(name)")
                 UIApplication.shared.endIgnoringInteractionEvents()
              //   self.imgBrendbg.isHidden = true
              //   self.viewTap.isHidden = true
                 if (name == "200"){
                     ToastView.shared.long(self.view, txt_msg: "Invalid Password")
                 }
                 else{
                     print("netStart",error as Any)
                     ToastView.shared.long(self.view, txt_msg: "Data Sync Failed please check net connection, Error in Details  \(String(describing: error))")
                 }
             }
         }
     }

    
    
    
//    func getBrands(password:String ){
//          let URL_HEROES = settingString.Setting+"/mobile/getbrands?password="+password
//          //creating a NSURL
//          let url = NSURL(string: URL_HEROES)
//          //fetching the data from the url
//          URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
//
//              DispatchQueue.main.async {
//                  if error != nil {
//
//                      ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
//                      self.viewMainLayout.isHidden  = true
//                      self.imgBrendbg.isHidden = true
//                      self.viewTap.isHidden = true
//                  }
//                  else
//                  {
//                      self.listBrands.removeAll();
//                      UserDefaults.standard.removeObject(forKey: "strTackingOrder")
//                      UserDefaults.standard.synchronize()
//
//                      SkopelosClient.shared.writeSync { context in
//                          let brands = Brands.SK_all(context)
//                          brands.forEach { setting in
//                              setting.SK_remove(context)
//                          }
//                      }
//
//                      if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
//                          if jsonObj!.value(forKey: "brand")! as? Int32 == 0
//                          {
//                              ToastView.shared.long(self.view, txt_msg: "Invalid Password")
//                              self.viewMainLayout.isHidden = true
//                          }
//                          else
//                          {
//                              self.viewMainLayout.isHidden = false
//                              let dispatchGroup = DispatchGroup()
//                              if let heroeArray = jsonObj!.value(forKey: "brand") as? NSArray {
//
//                                  for heroe in heroeArray
//                                  {
//                                      //converting the element to a dictionary
//                                      if let heroeDict = heroe as? NSDictionary {
//
//                                          //getting the name from the dictionary
//                                          let brandID  = heroeDict.value(forKey: "brandID")
//                                          let brandSeq = heroeDict.value(forKey: "brandSeq")
//                                          let themeID = heroeDict.value(forKey: "themeID")
//                                          let mandarin = heroeDict.value(forKey: "mandarin")
//                                          let russian = heroeDict.value(forKey: "russian")
//                                          let brandName = heroeDict.value(forKey: "brandName")
//                                          let brandNameAr = heroeDict.value(forKey: "brandNameAr")
//                                          let brandLogo = heroeDict.value(forKey: "brandLogo")
//                                          var feedback = Int32()
//                                          if heroeDict.value(forKey: "feedback") != nil ||  heroeDict.value(forKey: "feedback")as? Int32  != 0
//                                          {
//                                              feedback = heroeDict.value(forKey: "feedback") as? Int32 ?? 0
//                                          }
//                                          else
//                                          {
//                                              feedback = 0
//                                          }
//                                          UserDefaults.standard.set(feedback, forKey:"feedback")
//                                          UserDefaults.standard.synchronize()
//                                          var fb = String()
//                                          var insta = String()
//                                          var currency = String()
//                                          var telephone = String()
//                                          var orderTaking = Int32()
//                                          if (heroeDict.value(forKey: "facebook") != nil)  || heroeDict.value(forKey: "facebook")  is String
//                                          {
//                                              fb = heroeDict.value(forKey: "facebook") as! String
//                                          }
//                                          else
//                                          {
//                                              fb = ""
//                                          }
//                                          if (heroeDict.value(forKey: "instagram") != nil)  || heroeDict.value(forKey: "instagram")  is String
//                                          {
//                                              insta = heroeDict.value(forKey: "instagram") as! String
//                                          }
//                                          else
//                                          {
//                                              insta = ""
//                                          }
//                                          if (heroeDict.value(forKey: "currency") != nil)  || heroeDict.value(forKey: "currency")  is String
//                                          {
//                                              currency = heroeDict.value(forKey: "currency") as! String
//                                          }
//                                          else
//                                          {
//                                              currency = "KD"
//                                          }
//                                          if (heroeDict.value(forKey: "Telephone") != nil)  || heroeDict.value(forKey: "Telephone")  is String
//                                          {
//                                              telephone = heroeDict.value(forKey: "Telephone") as! String
//                                          }
//                                          else
//                                          {
//                                              telephone = ""
//                                          }
//
//                                          if (heroeDict.value(forKey: "orderTaking") != nil)
//
//                                          {
//                                              orderTaking = heroeDict.value(forKey: "orderTaking") as! Int32
//                                          }
//                                          else
//                                          {
//                                              orderTaking = 0
//
//                                          }
//                                          //adding the name to the list
//
//                                          SkopelosClient.shared.writeSync { context in
//                                              let BrandDataInsert = Brands.SK_create(context)
//                                              BrandDataInsert.brandID = brandID as! Int32
//                                              BrandDataInsert.brandSeq = brandSeq as! Int32
//                                              BrandDataInsert.themeID = themeID as! Int32
//                                              BrandDataInsert.russian = russian as! Int32
//                                              BrandDataInsert.mandarin = mandarin as! Int32
//                                              BrandDataInsert.brandName = brandName as? String
//                                              BrandDataInsert.brandNameAra = brandNameAr as? String
//                                              BrandDataInsert.brandLogo = brandLogo as? String
//                                              BrandDataInsert.feedback = feedback
//                                              BrandDataInsert.facebook = fb
//                                              BrandDataInsert.instagram = insta
//                                              BrandDataInsert.telephone = telephone
//                                              BrandDataInsert.currency = currency
//                                              BrandDataInsert.orderTaking = orderTaking
//                                              if orderTaking == 1
//                                              {
//                                                  //self.strTackingOrder = "yes"
//                                                  DispatchQueue.main.async {
//                                                      self.lbltackingOrder.isHidden = false
//                                                      self.btncheck.isHidden = false
//                                                  }
//                                              }
//                                              else
//                                              {
//                                                  //self.strTackingOrder = ""
//                                                  DispatchQueue.main.async {
//                                                      self.lbltackingOrder.isHidden = true
//                                                      self.btncheck.isHidden = true
//                                                  }
//                                              }
//                                              UserDefaults.standard.set(currency, forKey: "cur")
//                                              UserDefaults.standard.synchronize()
//
//                                              dispatchGroup.enter()
//                                              ImageLoader_SDWebImage.downloadImage(BrandDataInsert.brandLogo) { (_, _) in
//                                                  dispatchGroup.leave()
//                                              }
//                                          }
//                                      }
//                                  }
//                              }
//
//                              dispatchGroup.notify(queue: .main) {
//                                  UIApplication.shared.endIgnoringInteractionEvents()
//                                  SkopelosClient.shared.read { context in
//                                      self.listBrands = Brands.SK_all(context)
//                                  }
//                                  self.getThemes();
//                              }
//                          }
//                      } else {
//                          ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
//                          self.viewMainLayout.isHidden  = true
//                          self.imgBrendbg.isHidden = true
//                          self.viewTap.isHidden = true
//                      }
//                  }
//              }
//
//          }).resume()
//      }
    
    
    

}
//--MARK
extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! BrandsCollectionViewCell
        cell.backgroundColor  = .white
        cell.layer.cornerRadius = 5
        cell.layer.shadowOpacity = 3
        cell.createCell(data: self.listBrands[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print ("UIcollection width : \(self.myCollectionView.frame.size.width)")
        
       return CGSize(width:(self.myCollectionView.frame.size.width - 10)/3 , height: 500)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
//    }
    
    
}
       
       
