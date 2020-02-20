//
//  FiniHomeVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 7/30/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import Firebase
class FiniHomeVC: UIViewController , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    @IBOutlet weak var imgbrandLogo: UIImageView!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnPromotion: UIButton!
    @IBOutlet weak var imgTranspent: UIImageView!
    @IBOutlet var collPromotion:UICollectionView!
    @IBOutlet var btnClose:UIButton!
    @IBOutlet var Noimage:UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var viewPromotion: UIView!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet var imgLanguage:UIImageView!
    @IBOutlet var conimgLogoWidth:NSLayoutConstraint!

    var getPage:Int = 0
    var arrSlide = [SlideShow]()
    var timer = Timer()
    var strIsCome = String()
    var selectedIndex:Int = 0
    var strIsComefromView = String()
    var strSelLang = String()
    var strIsotherLang = String()
    
    var themeData = [Themes]()
    
    //FiniCatListVC
    var arrCategories = [CategoryCoreData]()
    var arrItems = [ItemsCoreData]()
    let dummyImageView = UIImageView()
    
    var arrMainFb = [FeedbackData]()
         var intFbRow : Int!
         var intTotalCount = NSInteger()
        var arrCountFb : NSMutableArray = []
       var floatProgress = Float()
       var progressBar = UIProgressView()
      var lblDisplyPer = UILabel()
    var  lblFBcount = UILabel()
    var viewTap = UIView()
    
    
    
    var listLayoutType = [LayoutType]()
    struct Language {
        static var language = "eng";
    }


    
    override func viewWillAppear(_ animated: Bool) {

          if UserDefaults.standard.value(forKey: "feedbackArry") != nil {
              
              let arr = NSMutableArray(array: UserDefaults.standard.value(forKey: "feedbackArry") as! Array)
              
              SkopelosClient.shared.read { context in
                  let Setting = FeedbackData.SK_all(context)
                  
                  let feedback:Int = UserDefaults.standard.value(forKey: "feedback") as? Int ?? 0
                  if  feedback == 0 {
                      //self.btnSyncFB.isHidden = true
                      self.lblFBcount.isHidden = true
                  } else {
                      if Setting.count == 0 {
                          //btnSyncFB.isHidden = true
                          self.lblFBcount.isHidden = true
                      } else {
                      //    self.btnSyncFB.isHidden = false
                        self.lblFBcount.isHidden = false
//                        self.lblFBcount.layer.cornerRadius = 15
//                        self.lblFBcount.layer.borderWidth = 1.0
//                        self.lblFBcount.layer.borderColor = UIColor.white.cgColor
//                        self.lblFBcount.layer.masksToBounds = true
                        self.lblFBcount.text = String(format: "%d", (Setting.count/arr.count))
                        if self.lblFBcount.text == "0" {
                            self.lblFBcount.isHidden = true
                        }
                      }
                  }
              }
          }
          else{
             // btnSyncFB.isHidden = true
              lblFBcount.isHidden = true
          }


      }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        initializeView()
       //Fabric.sharedSDK().debug=true
    }

    override func viewDidLayoutSubviews() {
        if getPage == 0
        {
            self.btnPre.isHidden = true
        }
        else
        {
            pageView.currentPage = getPage
            
        }
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           viewTap.isHidden  = true

       }
    
    func addviews(){
        self.view.addSubview(viewTap)
        viewTap.addSubview(lblDisplyPer)
        self.view.addSubview(lblFBcount)
        

        viewTap.translatesAutoresizingMaskIntoConstraints = false
        viewTap.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        viewTap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewTap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        viewTap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        viewTap.backgroundColor = UIColor(white : 1, alpha: 0.5)
        //viewTap.backgroundColor = UIColor()
        
        
        viewTap.isHidden  = true
        
        lblDisplyPer.translatesAutoresizingMaskIntoConstraints = false
        lblDisplyPer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lblDisplyPer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        //lblFBcount
        lblFBcount.translatesAutoresizingMaskIntoConstraints = false
        lblFBcount.topAnchor.constraint(equalTo: btnFeedback.bottomAnchor).isActive = true
        lblFBcount.trailingAnchor.constraint(equalTo: btnFeedback.trailingAnchor).isActive = true
        lblFBcount.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lblFBcount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //  lblFBcount.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        lblFBcount.backgroundColor = .orange
        lblFBcount.textAlignment = .center
        lblFBcount.layer.cornerRadius = 15
        lblFBcount.font.withSize(10)
        self.lblFBcount.layer.borderWidth = 1.5
        self.lblFBcount.layer.borderColor = UIColor.white.cgColor
        self.lblFBcount.layer.masksToBounds = true
    }
    
    
    func initializeView(){
        addviews()
        self.imgTranspent.isHidden = true
        self.viewPromotion.isHidden = true
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo()
        //   btnMenu.setTitleColor(UIColor.white, for: .normal)
        if BrandViewController.Brandhelper.feedBack == 0
        {
            self.btnFeedback.isHidden = true
        }
        else
        {
            self.btnFeedback.isHidden = false
            
        }
        
        if themeData[0].fontColor == nil
        {
            btnLanguage.titleLabel?.textColor = UIColor.black
            btnPromotion.titleLabel?.textColor = UIColor.black
            btnMenu.setTitleColor(UIColor.white, for: .normal)
            btnFeedback.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            //            btnLanguage.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnPromotion.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnMenu.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
            btnLanguage.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
            btnFeedback.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
        }
        if themeData[0].promotion == "0" || themeData[0].promotion == ""
        {
            btnPromotion.isHidden = true
        }
        else
        {
            btnPromotion.isHidden = false
            
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(btnMenuDoubleTap(_:)))
        gesture.numberOfTapsRequired = 3
        btnMenu.addGestureRecognizer(gesture)
        
        
        let gesturefeedback = UITapGestureRecognizer(target: self, action: #selector(btnFeedBackDoubleTap(_:)))
              gesturefeedback.numberOfTapsRequired = 3
              btnFeedback.addGestureRecognizer(gesturefeedback)
        
        
        if UserDefaults.standard.value(forKey: "IsOtherLanguages") as?  String == "1"
        {
            var getValue : String!
            btnLanguage.setTitle("", for: .normal)
            btnLanguage.setTitle("", for: .selected)
            btnLanguage.titleLabel?.text = ""
            imgLanguage.isHidden = false
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                self.btnMenu.setTitle("Menu", for: .normal)
                self.strSelLang = "eng"
            }
                
            else
            {
                getValue = UserDefaults.standard.value(forKey: "lang") as? String
                self.strSelLang  = getValue
                switch  getValue
                {
                case "eng": self.btnMenu.setTitle("Menu", for: .normal)
                case "ara": self.btnMenu.setTitle("القائمة", for: .normal)
                case "cha":self.btnMenu.setTitle("菜單", for: .normal)
                case "ira":self.btnMenu.setTitle("Clár", for: .normal)
                case "ita":self.btnMenu.setTitle("Menu", for: .normal)
                case "fra":self.btnMenu.setTitle("Menu", for: .normal)
                case "ger":self.btnMenu.setTitle("Speisekarte", for: .normal)
                case "ban": self.btnMenu.setTitle("মেনু", for: .normal)
                case "hin":self.btnMenu.setTitle("भोजनसूची", for: .normal)
                case "phil":self.btnMenu.setTitle("Menu", for: .normal)
                case "urd":self.btnMenu.setTitle("مینو", for: .normal)
                case "kor":self.btnMenu.setTitle("메뉴", for: .normal)
                case "spa":self.btnMenu.setTitle("Menú", for: .normal)
                case "sri":self.btnMenu.setTitle("මෙනු", for: .normal)
                case "tur":self.btnMenu.setTitle("Menü", for: .normal)
                default: print(self.strSelLang)
                    
                }
                
            }
            UserDefaults.standard.set(strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()
            
        }
        else
        {
            btnLanguage.setImage(nil, for: .normal)
            imgLanguage.isHidden = true
            let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as?  String
            if (CurrentLanguage == "eng")
            {
                btnLanguage.setTitle("عربى", for: .normal)
                self.btnMenu.setTitle("Menu", for: .normal)
                self.strSelLang = "eng"
            }
            else
            {
                btnLanguage.setTitle("ENG", for: .normal)
                self.btnMenu.setTitle("القائمة", for: .normal)
                self.strSelLang = "ara"
            }
            UserDefaults.standard.set(strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()
        }
        
        
        if (themeData[0].englishButton != nil)
        {
            imgMenu.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            btnPromotion.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            btnLanguage.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            btnFeedback.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
        }
        else
        {
            imgMenu.backgroundColor = UIColor.lightGray
            btnPromotion.backgroundColor = UIColor.lightGray
            btnLanguage.backgroundColor = UIColor.lightGray
            btnFeedback.backgroundColor = UIColor.lightGray
        }
        btnPromotion.setTitle("Promotion", for: .normal)
        self.getImage()
        
        // DispatchQueue.global(qos: .background).async {
        self.GetCategory()
        // }
        imgMenu.layer.cornerRadius = self.imgMenu.frame.size.width / 2
        imgMenu.layer.borderWidth = 0
        imgMenu.layer.borderColor = UIColor.clear.cgColor
        let somegif = UIImage.gifImageWithName("sparkle_8")
        imgMenu.image = somegif
      //  imgMenu.contentMode = .scaleAspectFit
        // btnMenu.setTitleColor(.white, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(cacheImages),
                                               name: NSNotification.Name("applicationDidBecomeActive"),
                                               object: nil)
    }
 

    @objc private func cacheImages() {
        for item in arrItems {
        //    DispatchQueue.main.async {
                ImageLoader_SDWebImage.setImage(item.imageName, into: self.dummyImageView)
          //  }
        }
    }

    //GetData
    func GetCategory() {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID != %i", 0)
            let categories = CategoryCoreData.SK_all(context, predicate: predicate, sortTerm: "catSequence", ascending: true)
            self.arrCategories = categories
            for category in categories {
                let predicate = NSPredicate(format: "catID = \(NSNumber(value: category.catID))")
                let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
                if items.isEmpty {
                    let entityName = "ItemsCoreData"
                    let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
                    let dummyObject: ItemsCoreData = ItemsCoreData(entity: entity, insertInto: nil)
                    self.arrItems.append(dummyObject)
                } else {
                    self.arrItems.append(items[0])
                }
            }
            self.cacheImages()
        }
    }
    
    //MARK: -Collecion Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrSlide.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell
        let slideData = self.arrSlide[indexPath.row]
        cell.ImgItem.layer.cornerRadius = 8
        cell.ImgItem.layer.borderColor = UIColor.black.cgColor
        cell.ImgItem.layer.borderWidth = 1
        
        ImageLoader_SDWebImage.setImage(slideData.imageName, into: cell.ImgItem) { (_, error) in
            if error != nil {
                let placeholder = ImageLoader_SDWebImage.placeholder
                cell.ImgItem.image = placeholder
            }
            cell.ImgItem.isHidden = (error != nil)
        }
        
        cell.ImgItem.backgroundColor = UIColor.black
        cell.ImgItem.contentMode = .scaleAspectFit
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collPromotion.frame.size.width, height:(self.collPromotion.frame.size.height))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.setCollectionArrow()
    }
    @IBAction func btnNextClick(_ sender: Any)
    {
        
        if collPromotion.visibleCells.count > 0
        {
            let cell: ItemsCollectionViewCell? = collPromotion.visibleCells[0] as! ItemsCollectionViewCell
            
            var index: IndexPath? = nil
            
            if let aCell = cell {
                index = collPromotion.indexPath(for: aCell)
            }
            
            if (index?.row ?? 0) + 1 < self.arrSlide.count
            {
                collPromotion.scrollToItem(at: IndexPath(row: (index?.row ?? 0) + 1, section: 0), at: .right, animated: true)
            }
        }
        
    }
    @IBAction func btnPreClick(_ sender: Any)
    {
        if collPromotion.visibleCells.count > 0
        {
            var cell: ItemsCollectionViewCell? = collPromotion.visibleCells[0] as! ItemsCollectionViewCell
            var index: IndexPath? = nil
            if let aCell = cell {
                index = collPromotion.indexPath(for: aCell)
            }
            
            if (index?.row ?? 0) < self.arrSlide.count
            {
                collPromotion.scrollToItem(at: IndexPath(row: (index?.row ?? 0) - 1, section: 0), at: .left, animated: true)
            }
        }
        
    }

    func setCollectionArrow()
    {
        let pageWidth: CGFloat
        pageWidth  = collPromotion.frame.size.width
        btnPre.isHidden = true
        let page : NSInteger  = NSInteger(collPromotion.contentOffset.x / pageWidth)
        pageView.currentPage = page
        getPage = page
        let language = UserDefaults.standard.value(forKey: "lang") as? String
        if page == 0
        {
            if language == "ara"
            {
                btnPre.isHidden = false
                btnNext.isHidden = true
            }
            else
            {
                btnPre.isHidden = true
                btnNext.isHidden = false
            }
        }
        else if page == self.arrSlide.count - 1
        {
            if language == "ara"
            {
                btnPre.isHidden = true
                btnNext.isHidden = false
            }
            else
            {
                btnPre.isHidden = false
                btnNext.isHidden = true
            }
        }
        else
        {
            btnPre.isHidden = false
            btnNext.isHidden = false
        }
        
    }

    @IBAction func btnCloseClick (_ sender : AnyObject)
    {
        viewPromotion.isHidden = true
        imgTranspent.isHidden = true
    }

    func getImage()
    {
        SkopelosClient.shared.read { context in
            let items = SlideShow.SK_all(context)
            self.arrSlide = items
            if self.arrSlide.count > 0
            {
                self.pageView.numberOfPages = self.arrSlide.count
                self.pageView.currentPage = 0
                self.collPromotion.isHidden = false
                self.collPromotion.reloadData()
            }
                
            else
            {
                self.collPromotion.isHidden = true
            }
        }
        
        
    }
    //MARK: -Action
    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        let objVC: Feedback1VC? = storyboard?.instantiateViewController(withIdentifier: "Feedback1VC") as? Feedback1VC
        objVC?.strIsCome = "fini"
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
        //self.performSegue(withIdentifier: "FeedbackSegue", sender: nil)
    }

//Fini_ItemList
    func goBackToMainPage(password: String){
        
        let LayoutData = GetLayout()
        
        if(LayoutData[0].password == password){
            
            SkopelosClient.shared.writeSync { context in
                self.listLayoutType.removeAll();
                let settings = LayoutType.SK_all(context)
                settings.forEach { setting in
                    setting.SK_remove(context)
                }
                
            }
            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandViewController")
            self.navigationController?.pushViewController(destVC, animated: true)
        }else{
            ToastView.shared.long(self.view, txt_msg: "Invalid Password")
        }

    }
    func GetLayout() -> [LayoutType] {
       
        SkopelosClient.shared.read { context in
                   let Setting = LayoutType.SK_all(context)
                   self.listLayoutType = Setting
               }
        return listLayoutType
    }
    
    
    var intArrCount:Int = 0 {
        didSet {
            self.floatProgress = Float(self.intArrCount) / Float(self.intTotalCount)
            self.progressBar.setProgress(Float(self.floatProgress) , animated: true)
            print("self.progresbarView.progress is: \(self.progressBar.progress)")
            var progressValue = self.progressBar.progress
            progressValue = progressValue * 100
            self.lblDisplyPer.text = "\( Int(floor(progressValue))) %"
        }
    }
    @objc func btnMenuDoubleTap(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Login",
                                      message: "Please Enter server password to go back to Main Menu",
                                      preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            
            UserDefaults.standard.removeObject(forKey: "lang")
            UserDefaults.standard.synchronize()
            print("Menu")
            self.viewWillAppear(true)
            self.goBackToMainPage(password: alert.textFields![0].text ?? "TestKosar")
            
            
        })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
            
            textField.placeholder = "Password"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
        }
        alert.addAction(loginAction)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            //
        })
        alert.addAction(cancel)

                  present(alert, animated: true, completion: nil)
        print("tapped")
    }
    
    
    @objc func btnFeedBackDoubleTap(_ gesture: UITapGestureRecognizer) {
       SkopelosClient.shared.read { context in
            self.arrMainFb = FeedbackData.SK_all(context)
        }
        
        if self.arrMainFb.count > 0
        {
            let alert = UIAlertController(title: "",
                                          message: "Would you like to sync feedback to the server ?",
                                          preferredStyle: .alert)
            let btnOkAction = UIAlertAction(title: "Yes", style: .default, handler: {
                (action) -> Void in
               // BrandViewController.syncServerApi()
                
                self.intFbRow = 0
                self.syncServerApi()
              //  self.imgBrendbg.isHidden = false
               self.viewTap.isHidden = false
                
            })
            let btnCancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(btnOkAction)
            alert.addAction(btnCancelAction)
            present(alert, animated: true, completion: nil)
        }else{
              ToastView.shared.long(self.view, txt_msg: "No Feedback Data")
        }
        print("tapped")
    }
    
      func syncServerApi()
         {
             
                 self.intTotalCount = arrMainFb.count
            
                 let dict = self.arrMainFb[intFbRow]

             
             if (dict.response != nil)
             {
                 let strUrl = String(format: "http://%@:%@/mobile/AddFeedBack?UDID=%@&responseType=%@&custMobile=%@&custName=%@&custEmail=%@&question=%@&response=%@&branchName=%@&date=%@", settingString.ip,String(format: "%d", settingString.port),dict.udid!,dict.resType!,dict.mobie!,dict.name!,dict.email!,dict.que!,dict.response!,dict.branchName!,dict.datetime!)
                    
                 
                 print("foo \(strUrl)")
                     let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                     let url = NSURL(string: urlString!)
                     
                     //fetching the data from the url
                     
                 URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                     DispatchQueue.main.async {
                         
                         if error != nil {
                             
                             ToastView.shared.long(self.view, txt_msg: "No internet,Please check internet connectivity")
                          //   self.imgBrendbg.isHidden = true
                             self.viewTap.isHidden = true
                             
                         } else {
                             let httpResponse = response as! HTTPURLResponse
                             
                             if httpResponse.statusCode == 200 {
                                 
                                 self.arrCountFb.add("1")
                                 if self.arrCountFb.count == self.arrMainFb.count {
                                     
                                     
     //                                SkopelosClient.shared.writeSync { dict in
     //                                    let settings = FeedbackData.SK_all(dict)
     //                                    settings.forEach { setting in
     //                                        setting.SK_remove(dict)
     //                                    }
     //                                }
                                     
                                     SkopelosClient.shared.writeSync { context in
                                         let settings = FeedbackData.SK_all(context)
                                         settings.forEach { setting in
                                             setting.SK_remove(context)
                                         }
                                     }
                                     
                                     
                                     self.arrCountFb.removeAllObjects()
                                     self.viewWillAppear(true)
                                 //    self.imgBrendbg.isHidden = true
                                     self.viewTap.isHidden = true

                                    ToastView.shared.long(self.view, txt_msg: "Data Have been sent to server")
                                 }
                                 else
                                 {
                                     self.intFbRow = self.intFbRow + 1
                                     self.syncServerApi()
                                     
     //                                SkopelosClient.shared.writeSync { context in
     //                                    let settings = FeedbackData.SK_all(context)
     //                                    settings.forEach { setting in
     //                                        setting.SK_remove(context)
     //                                    }
     //                                }
                                     self.intArrCount += 1
                                 }
                             }
                         }
                         
                     }
                 }).resume()
             }
            
                 
         }
         
    func wagaDuggu (fileName: String) -> UIImage{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath) {
            if UIImage(contentsOfFile: filePath) != nil
            {
                let image = UIImage(contentsOfFile: filePath)!
                return UIImage(contentsOfFile: filePath)!
            }
            else
            {
                return UIImage(named: "NoImage")!

            }
            
        }else{
            return UIImage(named: "NoImage")!
        }
    }
    func GetGifImageFromStorage(fileName: String) -> UIImage
    {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath)
        {
            let fileURL = NSURL(fileURLWithPath: filePath)
            let image = UIImage.gifImageWithURL(fileURL as URL)
            return image!
        }
        else{
            return UIImage(named: "NoImage")!
        }
    }
    
    func downloadBrandImageLogo(){
        SkopelosClient.shared.read { context in
            let BrandID :Int32? = BrandViewController.Brandhelper.brandID;
            let predicate = NSPredicate(format: "brandID = \(NSNumber(value:BrandID!))")
            let items = Brands.SK_all(predicate, context: context)
            var brandData = [Brands]()
            brandData = items;
            
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.imgbrandLogo) { (_, error) in
                if error != nil {
                    self.imgbrandLogo.image = ImageLoader_SDWebImage.placeholder
                    self.conimgLogoWidth.constant = 0
                } else {
                    self.conimgLogoWidth.constant = 150
                }
                
                self.imgbrandLogo.updateConstraintsIfNeeded()
                self.imgbrandLogo.layoutIfNeeded()
            }
        }
    }
    func downloadThemes(ThemeID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData = items
            let str4 = self.themeData[0].fontColor!
            let str5 = self.themeData[0].arabicButton!

            if  ( str4.isEmpty)
            {
                //btnLanguage.setTitleColor( UIColor.black, for: .normal)
                self.btnPromotion.setTitleColor( UIColor.black, for: .normal)
            }
            else
            {
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColor!)
                self.btnLanguage.setTitleColor( color1, for: .normal)
                self.btnPromotion.setTitleColor( color1, for: .normal)
                self.btnFeedback.setTitleColor( color1, for: .normal)
            }
            if  !(str5.isEmpty)
            {
                let getAlpha = Float(Float(self.themeData[0].arabicButton!)!/100.00)
                self.imgTranspent.backgroundColor  = UIColor.white.withAlphaComponent(CGFloat(getAlpha))
            }
            else
            {
                self.imgTranspent.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            }
            
            ImageLoader_SDWebImage.setImage(self.themeData[0].popupBackground, into: self.imgBackground) { (_, error) in
                if error != nil {
                    let placeholder = ImageLoader_SDWebImage.placeholder
                    self.imgBackground.image = placeholder
                }
                self.imgBackground.isHidden = (error != nil)
            }
        }
    }
    @IBAction func btnPromotionClick(_ sender: UIButton) {
        viewPromotion.isHidden = false
        imgTranspent.isHidden = true
        
        let objVC: Slideshow1Vc? = storyboard?.instantiateViewController(withIdentifier: "Slideshow1Vc") as? Slideshow1Vc
        objVC?.strIsCome = "Promotion"
        objVC?.strIsComefromView = "finiHome"
        //objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    @objc func alarmAlertActivate(){
        UIView.animate(withDuration: 0.3) {
            self.imgMenu.alpha = self.imgMenu.alpha == 1.0 ? 0.0 : 1.0
        }
    }

    @IBAction func btnMenuClick(_ sender: UIButton)
    {
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FiniCatListVC") as! FiniCatListVC
        popOverVC.arrCategories = arrCategories
        popOverVC.arrItems = arrItems
        navigationController?.pushViewController(popOverVC, animated: true)
    }
    @IBAction func btnLanguageClick(_ sender: UIButton)
    {
        
        if UserDefaults.standard.value(forKey: "IsOtherLanguages") as?  String == "1"
        {
            var SelIndex = Int()
            imgLanguage.isHidden = false
            
            self.btnLanguage.titleLabel?.text = ""
            let arr = ["English","عربى","中文","Gaeilge","Italiana","Française","Deutsche","বাংলাদেশী","हिंदी","Pilipinas","اردو","한국어","Española","සිංහල","Türk"]
            let cellConfi1 = FTCellConfiguration()
            cellConfi1.textColor = UIColor.red
            cellConfi1.textAlignment = .center
            FTPopOverMenu.showForSender(sender: sender, with: arr, done: { (selectedIndex) in
                SelIndex  = selectedIndex
                var checkSelection = Int()
                checkSelection = SelIndex
                switch  checkSelection
                {
                case 0: self.strSelLang = "eng"
                case 1: self.strSelLang = "ara"
                case 2: self.strSelLang = "cha"
                case 3:self.strSelLang = "ira"
                case 4:self.strSelLang = "ita"
                case 5:self.strSelLang = "fra"
                case 6:self.strSelLang = "ger"
                case 7: self.strSelLang = "ban"
                case 8:self.strSelLang = "hin"
                case 9:self.strSelLang = "phil"
                case 10:self.strSelLang = "urd"
                case 11:self.strSelLang = "kor"
                case 12:self.strSelLang = "spa"
                case 13:self.strSelLang = "sri"
                case 14:self.strSelLang = "tur"
                default: print(self.strSelLang)
                }
                UserDefaults.standard.set(self.strSelLang, forKey: "lang")
                UserDefaults.standard.synchronize()
                
                if UserDefaults.standard.value(forKey: "lang") == nil
                {
                    self.btnMenu.setTitle("Menu", for: .normal)
                }
                else
                {
                    var getValue = String()
                    getValue = UserDefaults.standard.value(forKey: "lang") as! String
                    switch  getValue
                    {
                    case "eng": self.btnMenu.setTitle("Menu", for: .normal)
                    case "ara": self.btnMenu.setTitle("القائمة", for: .normal)
                    case "cha":self.btnMenu.setTitle("菜單", for: .normal)
                    case "ira":self.btnMenu.setTitle("Clár", for: .normal)
                    case "ita":self.btnMenu.setTitle("Menu", for: .normal)
                    case "fra":self.btnMenu.setTitle("Menu", for: .normal)
                    case "ger":self.btnMenu.setTitle("Speisekarte", for: .normal)
                    case "ban": self.btnMenu.setTitle("মেনু", for: .normal)
                    case "hin":self.btnMenu.setTitle("भोजनसूची", for: .normal)
                    case "phil":self.btnMenu.setTitle("Menu", for: .normal)
                    case "urd":self.btnMenu.setTitle("مینو", for: .normal)
                    case "kor":self.btnMenu.setTitle("메뉴", for: .normal)
                    case "spa":self.btnMenu.setTitle("Menú", for: .normal)
                    case "sri":self.btnMenu.setTitle("මෙනු", for: .normal)
                    case "tur":self.btnMenu.setTitle("Menü", for: .normal)
                    default: print(self.strSelLang)
                    }
                    
                }
                
                
            }) {
                
            }
            
            
        }
        else
        {
            self.btnLanguage.setImage(nil, for: .normal)
            imgLanguage.isHidden = true
            
            if UserDefaults.standard.value(forKey: "lang")as? String == "eng"
            {
                self.btnLanguage.setTitle("ENG", for: .normal)
                self.btnMenu.setTitle("القائمة", for: .normal)
                self.strSelLang = "ara"
            }
            else
            {
                self.btnLanguage.setTitle("عربى", for: .normal)
                self.strSelLang = "eng"
                self.btnMenu.setTitle("Menu", for: .normal)
                
            }
            UserDefaults.standard.set(self.strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()
            
        }
        
    }

    func colorWithHexString (hex:String) -> UIColor {
        var cString:String =  hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        if (cString.count != 6) {
            return UIColor.black
        }
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}
