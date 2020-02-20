//
//  ViewController.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 6/30/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

class BrandViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    //Why CoreData and SQLite3?
   
    @IBOutlet weak var brandName: UILabel!
//    @IBOutlet weak var btnLayoutA: UIButton!
//    @IBOutlet weak var btnLayoutB: UIButton!
//    @IBOutlet weak var btnLayoutC: UIButton!
//
    @IBOutlet weak var viewMainLayout: UIView!
//    @IBOutlet weak var viewLayoutB: UIView!
//    @IBOutlet weak var viewLayoutC: UIView!
//    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var conViewLayoutHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBrendbg: UIView!
    @IBOutlet weak var imgBrendbg: UIImageView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var lblDisplyPer: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnSyncFB: UIButton!
    @IBOutlet weak var lblFBcount: UILabel!
    @IBOutlet weak var lbltackingOrder: UILabel!
    @IBOutlet weak var btncheck: UIButton!

    var arrMainFb = [FeedbackData]()
    var page:Int  = 0
    var timer  = Timer()
    var timeLaunched: Int = 0
    //var timer: Timer?
    
//    @IBOutlet weak var imgLayoutA: UIImageView!
//    @IBOutlet weak var imgLayoutB: UIImageView!
//    @IBOutlet weak var imgLayoutC: UIImageView!

    var p = [NSLayoutConstraint]()
    var l = [NSLayoutConstraint]()
    var initialOrientation = true
    var isInPortrait = false
    var getPage:Int = 0
    var intTotalCount = NSInteger()
    var floatProgress = Float()
    var strTackingOrder = String()
    var listLayoutType = [LayoutType]()
    var intFbRow : Int!
    var strboard:UIStoryboard!
    var Selectedindex:Int!
    var arrReplace:NSMutableArray = []
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    //A string array to save all the names
    var nameArray = [String]()
    struct Brandhelper {
        static var brandID = Int32()
        static var themeID = Int32()
        static var feedBack = Int32()
        static var TackingOrder = Int32()

    }
    
    override func viewDidLayoutSubviews() {
        if getPage == 0
        
        {
            btnPre.isHidden = true
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewTap.isHidden  = true

    }
    @IBOutlet weak var CollListViewBrands: UICollectionView!
    @IBOutlet weak var CollListViewLayout: UICollectionView!

    var listSettings = [SettingDataCore]()
    var listBrands = [Brands]()
    var listTheme = [Themes]()
   var listItems = [ItemsCoreData]()
    var ListCategory = [CategoryCoreData]()
    var listLayout =  [[String:AnyObject]]()
    var listSlide = [SlideShow]()
    var listExtra = [Extra]()

    var arrCountFb : NSMutableArray = []

    
    @IBAction func btnSetting(_ sender: Any)
    {
        btnSetting.isSelected = true
  // Crashlytics.sharedInstance().crash()
        OnSettingClicked()
    // fetchThemse()

    }
   // ......................................//
    // MARK: -NEXTPREV Action
    
    @IBAction func btnSyncFBClick(_ sender: Any)
    {
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
                
                
                self.intFbRow = 0
                self.syncServerApi()
                self.imgBrendbg.isHidden = false
                self.viewTap.isHidden = false
                
            })
            let btnCancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(btnOkAction)
            alert.addAction(btnCancelAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
   
    
    //API
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
                        self.imgBrendbg.isHidden = true
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
                                self.imgBrendbg.isHidden = true
                                self.viewTap.isHidden = true
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
    
    
    @IBAction func btnNextClick(_ sender: Any)
    {
        if CollListViewLayout.visibleCells.count > 0
        {
            let cell: LayoutCell? = CollListViewLayout.visibleCells[0] as? LayoutCell
            var index: IndexPath? = nil
            if let aCell = cell {
                index = CollListViewLayout.indexPath(for: aCell)
            }
            if (index?.row ?? 0) + 5 < self.listLayout.count
            {
                CollListViewLayout.scrollToItem(at: IndexPath(row: (index?.row ?? 0) + 5, section: 0), at: .right, animated: true)
                page = 1
            }
            
        }
    }
    @IBAction func btnPrevClick(_ sender: Any)
    {
        if CollListViewLayout.visibleCells.count > 0
        {
            let cell: LayoutCell? = CollListViewLayout.visibleCells[0] as? LayoutCell
            var index: IndexPath? = nil
            if let aCell = cell {
                index = CollListViewLayout.indexPath(for: aCell)
//                index!.row = (index?.row)! + 6
            }
            if (index?.row ?? 0) - 5 < self.listLayout.count
            {
                CollListViewLayout.scrollToItem(at: IndexPath(row: (index?.row ?? 0) - 5, section: 0), at: .left, animated: true)
                page = 0
            }

        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.setCollectionArrow()
    }
    func setCollectionArrow()
    {
        //var cell: ItemsCollectionViewCell? = itemsDetail.cellForItem(at: <#T##IndexPath#>)
        let pageWidth: CGFloat = (CollListViewLayout.frame.size.width) / 7
         page  = NSInteger(CollListViewLayout.contentOffset.x / pageWidth)
        //btnPre.isHidden = true
        if page == 0
        {
                btnPre.isHidden = true
                btnNext.isHidden = false
        }
        else if page == self.listLayout.count - 5
        {
                btnPre.isHidden = false
                btnNext.isHidden = true
        }
    }

    func OnSettingClicked()  {
        
        self.lblDisplyPer.isHidden = true
        
        SkopelosClient.shared.read { context in
            let Setting = SettingDataCore.SK_all(context)
            self.listSettings = Setting
            settingString.ip = self.listSettings[0].ipAddress!
            settingString.port = self.listSettings[0].port
            settingString.password = self.listSettings[0].password!
            settingString.second =  self.listSettings[0].second
            settingString.Setting = "http://"+settingString.ip+":"+String(settingString.port)
            settingString.branchName = settingString.branchName
            UserDefaults.standard.set(settingString.branchName, forKey: "branchName")
            UserDefaults.standard.set(String(format: "%.f", settingString.second), forKey: "second")
            UserDefaults.standard.set(settingString.ip, forKey: "ip")
            UserDefaults.standard.synchronize()
        }
        
        let alert = UIAlertController(title: "Login",
                                      message: "Insert Ip, Port and Password to Synchronise with your brand",
                                      preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            settingString.ip = alert.textFields![0].text!
            let portstring = alert.textFields![1].text
            settingString.port = Int32(portstring!)!
            settingString.password = alert.textFields![2].text!
            settingString.second = (alert.textFields![3].text! as NSString).floatValue
            settingString.branchName = alert.textFields![4].text!
            UserDefaults.standard.set(alert.textFields![3].text!, forKey: "second")
            UserDefaults.standard.set(alert.textFields![4].text!, forKey: "branchName")
            UserDefaults.standard.synchronize()
            settingString.Setting = "http://"+settingString.ip+":"+String(settingString.port)
            self.SaveSetting(ip: settingString.ip, port: settingString.port, password: settingString.password,second:String(format: "%f", settingString.second), branchName: settingString.branchName )
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.viewTap.isHidden = false
            self.imgBrendbg.isHidden = false
            UserDefaults.standard.removeObject(forKey: "lang")
            UserDefaults.standard.synchronize()

            self.imgBrendbg.image = UIImage.gifImageWithName("loading7_orange")
            self.getBrands(password: settingString.password)
            self.viewWillAppear(true)


            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
//
        })
        if(self.listSettings.isEmpty ){
            self.SaveSetting(ip: "192.168.1.1", port: 90, password: "odada",second: "3", branchName: "Kuwait")
            UserDefaults.standard.removeObject(forKey: "lang")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(settingString.second, forKey: "second")
            UserDefaults.standard.set(settingString.branchName , forKey: "branchName")
            UserDefaults.standard.synchronize()
//            let btnImage    = UIImage(named: "checkbox_unselect")!
//            let imageButton : UIButton = UIButton(frame: CGRect(x: 15, y: 230, width: 30, height: 30))
//            imageButton.setBackgroundImage(btnImage, for: UIControlState())
//            imageButton.addTarget(self, action: #selector(self.checkBoxAction(_:)), for: .touchUpInside)
//            alert.view.addSubview(imageButton)

        }
        else{

            
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .numberPad
                textField.text =  self.listSettings[0].ipAddress
                textField.placeholder = "Type IP adress"
                textField.textColor = UIColor.black
                textField.font = UIFont(name: "Calibri", size: 15)
            }
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.text =  String(self.listSettings[0].port)
                textField.keyboardType = .numberPad
                textField.placeholder = "Type your Port Number"
                textField.textColor = UIColor.black
                textField.font = UIFont(name: "Calibri", size: 15)
            }
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.placeholder = "Type your password"
                textField.text =  self.listSettings[0].password
                textField.textColor = UIColor.black
                textField.font = UIFont(name: "Calibri", size: 15)
                
            }
            alert.addTextField { [weak self] textField -> Void in
                //TextField configuration
                textField.keyboardAppearance = .dark
                textField.keyboardType = .phonePad
                textField.placeholder = "Type second between 1 to 9"
                textField.text = String(format: "%.f",(self?.listSettings[0].second)!)
                textField.textColor = UIColor.black
                //textField.text  = "3"
                textField.font = UIFont(name: "Calibri", size: 15)
                textField.delegate = self
            }
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.placeholder = "Type your branchname"
                textField.text =  self.listSettings[0].branchName
                textField.textColor = UIColor.black
                textField.font = UIFont(name: "Calibri", size: 15)
                
            }
//            alert.addTextField { (textField: UITextField) in
////                textField.isUserInteractionEnabled = false
//                textField.text =  "Taking Order"
//                textField.setLeftPaddingPoints(30)
//
//                let view1 : UIView = UIView(frame: CGRect(x:0, y: 0, width: alert.view.frame.size.width - 20, height:25))
////                view1.frame = textField.frame
//
//                view1.backgroundColor = UIColor.clear
//                textField.textColor = UIColor.black
//                let imageButton : UIButton = UIButton(frame: CGRect(x:0, y: -3, width: 25, height:25))
//                let btnImage = UIImage(named: "checkbox_unselect")!
//                let btnImage1 = UIImage(named: "checkbox_fill")!
//
//                if UserDefaults .standard.value(forKey:"strTackingOrder") as? String == "yes"
//                {
//                    imageButton.isSelected = true
//                    self.strTackingOrder = "yes"
//                    imageButton.setBackgroundImage(btnImage1, for: UIControlState())
//
//                }
//                else
//                {
//                    imageButton.isSelected = false
//                    self.strTackingOrder = ""
//                    imageButton.setBackgroundImage(btnImage, for:UIControlState())
//
//                }
//
//                imageButton.addTarget(self, action: #selector(self.checkBoxAction(_:)), for: .touchUpInside)
//                view1.addSubview(imageButton)
//                textField.addSubview(view1)
//                textField.font = UIFont(name: "Calibri", size: 15)
//            }
            
            alert.addAction(loginAction)
            alert.addAction(cancel)

            present(alert, animated: true, completion: nil)
        }
    }
    var intArrCount:Int = 0 {
        didSet {
            self.floatProgress = Float(self.intArrCount) / Float(self.intTotalCount)
            self.progressBar?.setProgress(Float(self.floatProgress) , animated: true)
            print("self.progresbarView.progress is: \(self.progressBar!.progress)")
            var progressValue = self.progressBar?.progress
            progressValue = progressValue! * 100
            self.lblDisplyPer?.text = "\( Int(floor(progressValue!))) %"
        }
    }

    @IBAction func checkBoxAction(_ sender: AnyObject)
    {
        if btncheck.isSelected
        {
            btncheck.isSelected = false
            self.strTackingOrder = ""
            let btnImage    = UIImage(named: "checkbox_unselect")!
            btncheck.setBackgroundImage(btnImage, for: UIControlState())
        }else {
            btncheck.isSelected = true
            strTackingOrder = "yes"
            let btnImage    = UIImage(named: "checkbox_fill")!
             btncheck.setBackgroundImage(btnImage, for: UIControlState())
        }
    }

    override func viewDidLoad() {
    //updateLabel()
    //  timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(BrandViewController.updateLabel)), userInfo: nil, repeats: true)

        super.viewDidLoad()
      //  Fabric.sharedSDK().debug=true
             // Do any additional setup after loading the view, typically from a nib.
//        self.conViewLayoutHeight.constant = 0
        self.strTackingOrder = ""
        self.GetExistingBrands()
        self.GetExistingSettings()
        self.progressBar.progress = 0
        self.lblDisplyPer.text = "0 %"
        self.intTotalCount = 0
        self.btnSyncFB.isHidden = true
        listLayout = [["img":"LayoutA","name":"Layout-A","id":0],["img":"LayoutB","name":"Layout-B","id":1],["img":"LayoutC","name":"Layout-C","id":2],["img":"LayoutD","name":"Layout-D","id":3],["img":"LayoutE","name":"Traditional Layout","id":4],["img":"FiniLayout","name":"Fini Layout","id":5]] as [[String : AnyObject]]

        Selectedindex = 0
        CollListViewLayout.selectItem(at: IndexPath(row: Selectedindex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        self.viewMainLayout.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.viewBrendbg.backgroundColor = UIColor.white
        self.btnSetting.layer.borderColor = UIColor.clear.cgColor
        self.btncheck.isSelected = false
        
        self.btncheck.isHidden = true
        for i in 0..<listLayout.count
        {
            if i == 0
            {
                arrReplace.add("1")
            }
            else{
                arrReplace.add("0")

            }
        }
          OpenSelectedLayout()
    }

    override func viewWillAppear(_ animated: Bool) {

        if UserDefaults.standard.value(forKey: "feedbackArry") != nil {
            
            let arr = NSMutableArray(array: UserDefaults.standard.value(forKey: "feedbackArry") as! Array)
            
            SkopelosClient.shared.read { context in
                let Setting = FeedbackData.SK_all(context)
                
                let feedback:Int = UserDefaults.standard.value(forKey: "feedback") as? Int ?? 0
                if  feedback == 0 {
                    self.btnSyncFB.isHidden = true
                    self.lblFBcount.isHidden = true
                } else {
                    if Setting.count == 0 {
                        //btnSyncFB.isHidden = true
                        self.lblFBcount.isHidden = true
                    } else {
                        self.btnSyncFB.isHidden = false
                        self.lblFBcount.isHidden = false
                        self.lblFBcount.layer.cornerRadius = self.lblFBcount.frame.size.width / 2
                        self.lblFBcount.layer.borderWidth = 1.0
                        self.lblFBcount.layer.borderColor = UIColor.clear.cgColor
                        self.lblFBcount.text = String(format: "%d", (Setting.count/arr.count))
                        if self.lblFBcount.text == "0" {
                            self.lblFBcount.isHidden = true
                        }
                    }
                }
            }
        }
        else{
            btnSyncFB.isHidden = true
            lblFBcount.isHidden = true
        }


    }
   @objc  func updateMethod()
    {
        if Reachability.isConnectedToNetwork() == true {
            
            SkopelosClient.shared.read { context in
                let Setting = FeedbackData.SK_all(context)
                self.arrMainFb = Setting
            }
            
            if self.arrMainFb.count > 0
            {
                self.intFbRow = 0
                self.syncServerApi()
                self.imgBrendbg.isHidden = false
                self.viewTap.isHidden = false
            }
        }
        else {
            print("Internet connection FAILED")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ImageLoader_SDWebImage.deleteCachedImages(cacheType: .memory)
    }
  
    //MARK: -Collection Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == CollListViewLayout
        {
            return self.listLayout.count
        }
        else
        {
             return self.listBrands.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == CollListViewLayout
        {
            let cell = CollListViewLayout.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as! LayoutCell
            cell.imgLayout.image = UIImage(named: (self.listLayout[indexPath.row]["img"] as? String)!)
            cell.lblLayoutName.text = self.listLayout[indexPath.row]["name"] as? String
            cell.LayoutId = self.listLayout[indexPath.row]["id"] as! Int
            if arrReplace[indexPath.row] as? String == "0"
            {
                cell.lblLayoutName.textColor = UIColor.black
                cell.viewLayout.backgroundColor = UIColor.white
                cell.lblLayoutName.backgroundColor = UIColor.clear
            }
            else
            {
                cell.viewLayout.backgroundColor = UIColor(red: 217.0/255, green: 142.0/255, blue: 32.0/255, alpha: 1.0)
                cell.lblLayoutName.textColor = UIColor.white
                cell.lblLayoutName.backgroundColor = UIColor.clear
                
            }
            cell.viewLayout.layer.cornerRadius = 5
            cell.viewLayout.layer.borderColor  = UIColor.black.cgColor
            cell.viewLayout.layer.borderWidth  = 0.7

            cell.btnLayout.tag = indexPath.row
            cell.btnLayout.isUserInteractionEnabled = false
            //cell.btnLayout.addTarget(self, action: #selector(LayoutClick(_:)), for: .touchUpInside)
            //conViewLayoutHeight.constant = CollListViewLayout.contentSize.height + 20
            return cell

        }
        else
        {
            let cell = CollListViewBrands.dequeueReusableCell(withReuseIdentifier: "BrandNameCell", for: indexPath) as! BrandNameCell
            let brandDetails1: Brands
            brandDetails1 = self.listBrands[indexPath.row]
            cell.viewInnerCell.layer.borderColor = UIColor.black.cgColor
            cell.imgBrandlogo.layer.borderColor = UIColor.black.cgColor
            cell.viewInnerCell.layer.borderWidth = 1.5
            //        cell.imgBrandlogo.layer.borderWidth = 1
            cell.viewInnerCell.layer.cornerRadius = 5.0
            //        cell.imgBrandlogo.layer.cornerRadius = cell.imgBrandlogo.frame.size.width / 2
            cell.lblBrandname.layer.cornerRadius = 5.0
            cell.lblBrandname.layer.borderWidth = 1
            cell.lblBrandname.layer.borderColor = UIColor.clear.cgColor
            
            //        cell.lblBrandname.layer.backgroundColor = UIColor(red: 217.0/255, green: 142.0/255, blue: 32.0/255, alpha: 1.0).cgColor
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let localUrl = documentDirectory?.appendingPathComponent(brandDetails1.brandLogo!)
            
            if FileManager.default.fileExists(atPath: (localUrl?.path)!){
                if let cert = NSData(contentsOfFile: (localUrl?.path)!) {
                    cell.imgBrandlogo?.image = UIImage(data: cert as Data)
                    
                }
            }
            
            cell.lblBrandname?.text = brandDetails1.brandName
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == CollListViewLayout
        {

                return CGSize(width:(self.CollListViewLayout.frame.size.width - 10)/3 , height: 350)

        }
            
        else
        {
            let brand = listBrands[indexPath.item]
            let str:String = brand.brandName!
            
            let size1 = str.size(withAttributes: nil)
            var height:CGFloat = 0
            
            if size1.height < 200
            {
                height = 150 //200
            }
            else
            {
                height = size1.height
            }

            return CGSize(width: (self.view.frame.size.width / 5) - 20, height: max(150, height))
       
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    
//        let indexPath = CollListViewBrands.cellForItem(at:NSIndexPath(row: indexPath.item, section: 0) as IndexPath) //optional, to get from any UIButton for example
        if collectionView == CollListViewLayout
        {
            let cell = collectionView.cellForItem(at: indexPath) as! LayoutCell
//            cell.viewLayout.backgroundColor = UIColor(red: 217.0/255, green: 142.0/255, blue: 32.0/255, alpha: 1.0)
            Selectedindex = cell.LayoutId

                        if arrReplace[indexPath.item] as? String  == "0"
                        {
                            if arrReplace.contains("1")
                            {
                                arrReplace.remove("1")
                                arrReplace.add("0")
                            }
                            arrReplace.replaceObject(at: indexPath.item , with: "1")
                        }
           
            let indexPath = IndexPath(item: indexPath.item, section: 0)
            self.CollListViewLayout.reloadData()
            self.CollListViewLayout.scrollToItem(at: indexPath, at:.centeredHorizontally, animated: false)
        }
        else
        {
            let brandDetails: Brands
            brandDetails = self.listBrands[indexPath.row]
            Brandhelper.feedBack = Int32(brandDetails.feedback)
            
            Brandhelper.brandID = Int32(brandDetails.brandID)
            Brandhelper.themeID = Int32(brandDetails.themeID)
            onBrandClick(brandID:  Brandhelper.brandID)

        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
//    {
//
//        let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.item, section: 0)) as? LayoutCell
//        cell?.viewLayout.backgroundColor = UIColor.white
//        cell?.lblLayoutName.backgroundColor = UIColor.clear
//        cell?.lblLayoutName.textColor = UIColor.black
//        cell?.viewLayout.layer.cornerRadius = 5
//        cell?.viewLayout.layer.borderColor  = UIColor.black.cgColor
//        cell?.viewLayout.layer.borderWidth  = 0.7
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listBrands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as! BrandTableViewCell
        let brandDetails: Brands
        brandDetails = self.listBrands[indexPath.row]
        cell.BrandName?.text = brandDetails.brandName;
        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let brandDetails: Brands
        brandDetails = self.listBrands[(indexPath?.row)!]
        Brandhelper.brandID = Int32(brandDetails.brandID)
        Brandhelper.themeID = Int32(brandDetails.themeID)
        onBrandClick(brandID:  Brandhelper.brandID)
    }
    func SaveSetting (ip: String,port: Int32, password: String,second: String,branchName:String)
    {
        
        SkopelosClient.shared.writeSync { context in
            
            self.listSettings.removeAll();
            let settings = SettingDataCore.SK_all(context)
            settings.forEach { setting in
                setting.SK_remove(context)
            }
            
            let Setting = SettingDataCore.SK_create(context)
            Setting.ipAddress = ip
            Setting.password = password
            Setting.port = port
            Setting.second = Float(second)!
            Setting.branchName = branchName
            self.listSettings.append(Setting)
        }
    }
    

    func SaveLayout (layoutID: Int)
       {
           
           SkopelosClient.shared.writeSync { context in
               self.listLayoutType.removeAll();
               let settings = LayoutType.SK_all(context)
               settings.forEach { setting in
                   setting.SK_remove(context)
               }
               let Setting = LayoutType.SK_create(context)
            Setting.layoutId = Int16(layoutID)
            Setting.password = settingString.password
            Setting.themeID =  Int16(Brandhelper.themeID)
            Setting.feedbackID = Int16(Brandhelper.feedBack)
            Setting.brandID = Int16(Brandhelper.brandID)
               self.listLayoutType.append(Setting)
           }
       }
    
//    func GetLayout (layoutID: Int)
//         {
//
//             SkopelosClient.shared.writeSync { context in
//
//                 self.listLayout.removeAll();
//                 let settings = LayoutType.SK_all(context)
//                 settings.forEach { setting in
//                     setting.SK_remove(context)
//                 }
//                 let Setting = LayoutType.SK_create(context)
//                Setting.layoutId = Int16(layoutID)
//                Setting.password = self.listSettings[0].password
//                 self.listLayout.append(Setting)
//             }
//         }
//
    
    
    func GetExistingBrands() {
        UserDefaults.standard.removeObject(forKey: "lang")
        UserDefaults.standard.set("eng", forKey: "lang")
        UserDefaults.standard.synchronize()
        
        SkopelosClient.shared.read { context in
            let BrandData = Brands.SK_all(context)
            
            self.listBrands = BrandData
            if self.listBrands.count > 0
                
            {
                self.viewMainLayout.isHidden = false
            }
            else
            {
                self.SetupLayout()
            }
            for i in 0..<self.listBrands.count
            {
                let dict = self.listBrands[i]
                if dict.orderTaking == 1
                    
                {
                    if UserDefaults.standard.value(forKey: "strTackingOrder") as? String == "yes"
                    {
                        DispatchQueue.main.async {
                            self.lbltackingOrder.isHidden = false
                            self.btncheck.isHidden = false
                            self.btncheck.isSelected = true
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.lbltackingOrder.isHidden = false
                            self.btncheck.isHidden = false
                            self.btncheck.isSelected = false
                            
                        }
                    }
                    //self.strTackingOrder = "yes"
                    
                    
                }
                else
                {
                    //self.strTackingOrder = ""
                    DispatchQueue.main.async {
                        self.lbltackingOrder.isHidden = true
                        self.btncheck.isHidden = true
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    
    
    
    
    func GetExistingSettings()
    {
        
        SkopelosClient.shared.read { context in
            let SettingData = SettingDataCore.SK_all(context)
            self.listSettings = SettingData
            if(self.listSettings.isEmpty )
            {
                self.SaveSetting(ip: "192.168.1.1", port: 90, password: "odada",second: "3", branchName: "Kuwait")
                UserDefaults.standard.set(String(format: "%.f", settingString.second), forKey: "second")
                UserDefaults.standard.set(settingString.branchName, forKey: "branchName")
                UserDefaults.standard.synchronize()
                self.SetupLayout()
                
            } else {
                self.viewMainLayout.isHidden = false
                
                settingString.ip = SettingData[0].ipAddress!
                settingString.port = SettingData[0].port
                settingString.password = SettingData[0].password!
                settingString.second = SettingData[0].second
                UserDefaults.standard.set(String(format: "%.f", settingString.second), forKey: "second")
                UserDefaults.standard.synchronize()
                settingString.Setting = "http://"+settingString.ip+":"+String(settingString.port)
            }
        }
    }
    
    
    func OpenSelectedLayout(){
        let LayoutTypes = GetLayout()
        if(LayoutTypes.count != 0){
            
            Selectedindex = Int(LayoutTypes[0].layoutId)
            Brandhelper.brandID=Int32(LayoutTypes[0].brandID)
            Brandhelper.feedBack=Int32(LayoutTypes[0].feedbackID)
            Brandhelper.themeID=Int32(LayoutTypes[0].themeID)
            self.getExtraData()
            self.goToItemsPage()
        }
        
        
    }
    
    func GetLayout() -> [LayoutType] {
          
           SkopelosClient.shared.read { context in
                      let Setting = LayoutType.SK_all(context)
                      self.listLayoutType = Setting
                  }
           return listLayoutType
       }
    
    
    func onBrandClick(brandID: Int32){
   
        
        SaveLayout(layoutID: self.Selectedindex)
        let brandSync = UIAlertController(title: "Synchronise Data",
                                      message: "on Yes it will synchronise the selected Brand Data",
                                      preferredStyle: .alert)
        let brandSyncYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            UserDefaults.standard.removeObject(forKey: "lang")
            UserDefaults.standard.set("eng", forKey: "lang")

            self.viewTap.isHidden = false
            self.imgBrendbg.isHidden = false
            self.imgBrendbg.image  = UIImage.gifImageWithName("loading7_orange")
            UIApplication.shared.beginIgnoringInteractionEvents()
            UserDefaults.standard.synchronize()
            
            ImageLoader_SDWebImage.deleteCachedImages(cacheType: .all) {
                if Brandhelper.feedBack == 1
                {
                    self.passFeedbackData(BrandID: brandID)
                }
                self.getThemes()
                self.setSlideshowImage(BrandID: brandID)
                self.getExtraData()
                self.lblDisplyPer.isHidden = false
                self.getCategory(BrandID: brandID)
            }
        })
        
        
        let brandSyncNo = UIAlertAction(title: "No", style: .destructive, handler: { (action) -> Void in
            //            self.readvalues ()
             if UserDefaults.standard.value(forKey: "brandId") as? Int32 != nil
             {
                if UserDefaults.standard.value(forKey: "brandId") as? Int32  == brandID
                {
                    self.getExtraData()
                    self.goToItemsPage()
                    
                }
                else
                {
                    self.lbltackingOrder.isHidden = true
                    self.btncheck.isHidden = true
                    self.btncheck.isSelected = false
                    self.strTackingOrder = ""
                    UserDefaults.standard.removeObject(forKey: "strTackingOrder")
                    UserDefaults.standard.synchronize()
                    let alert = UIAlertController(title: "Synchronise Data",
                                                      message: "No data available.Please sync first.",
                                                      preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)

                }

            }
            else
             {
                self.lbltackingOrder.isHidden = true
                self.btncheck.isHidden = true
                self.strTackingOrder = ""
                self.btncheck.isSelected = false
                UserDefaults.standard.removeObject(forKey: "strTackingOrder")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Synchronise Data",
                                              message: "No data available.Please sync first.",
                                              preferredStyle: .alert)
              
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
 
            }
        })
        
        brandSync.addAction(brandSyncYes)
        brandSync.addAction(brandSyncNo)
        present(brandSync, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSague"
        {
                let controller = segue.destination as! HomePageVC
                controller.Selectedindex = Selectedindex
        }
    }

    func goToItemsPage()
    {

        if btncheck.isSelected == true
        {
             self.strTackingOrder = "yes"
            UserDefaults.standard.set(self.strTackingOrder, forKey: "strTackingOrder")
            UserDefaults.standard.synchronize()
        }
        else{
            self.strTackingOrder = ""
            UserDefaults.standard.set(self.strTackingOrder, forKey: "strTackingOrder")
            UserDefaults.standard.synchronize()
        }
                 if Selectedindex == 5
                {
                    self.performSegue(withIdentifier: "FiniHome", sender: self)
                    
                 }
                 else
                 {
                    self.performSegue(withIdentifier: "homeSague", sender: self)

        }
    }
    
    func getBrands(password:String )
    {
        let URL_HEROES = settingString.Setting+"/mobile/getbrands?password="+password
        //creating a NSURL
        let url = NSURL(string: URL_HEROES)
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            DispatchQueue.main.async {
                if error != nil {
                    
                    ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                    self.viewMainLayout.isHidden  = true
                    self.imgBrendbg.isHidden = true
                    self.viewTap.isHidden = true
                }
                else
                {
                    self.listBrands.removeAll();
                    UserDefaults.standard.removeObject(forKey: "strTackingOrder")
                    UserDefaults.standard.synchronize()
                    //3rd party for coredata 
                    SkopelosClient.shared.writeSync { context in
                        let brands = Brands.SK_all(context)
                        brands.forEach { setting in
                            setting.SK_remove(context)
                        }
                    }
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        if jsonObj!.value(forKey: "brand")! as? Int32 == 0
                        {
                            ToastView.shared.long(self.view, txt_msg: "Invalid Password")
                            self.viewMainLayout.isHidden = true
                        }
                        else
                        {
                            self.viewMainLayout.isHidden = false
                            let dispatchGroup = DispatchGroup()
                            if let heroeArray = jsonObj!.value(forKey: "brand") as? NSArray {
                                
                                for heroe in heroeArray
                                {
                                    //converting the element to a dictionary
                                    if let heroeDict = heroe as? NSDictionary {
                                        
                                        //getting the name from the dictionary
                                        let brandID  = heroeDict.value(forKey: "brandID")
                                        let brandSeq = heroeDict.value(forKey: "brandSeq")
                                        let themeID = heroeDict.value(forKey: "themeID")
                                        let mandarin = heroeDict.value(forKey: "mandarin")
                                        let russian = heroeDict.value(forKey: "russian")
                                        let brandName = heroeDict.value(forKey: "brandName")
                                        let brandNameAr = heroeDict.value(forKey: "brandNameAr")
                                        let brandLogo = heroeDict.value(forKey: "brandLogo")
                                        var feedback = Int32()
                                        if heroeDict.value(forKey: "feedback") != nil ||  heroeDict.value(forKey: "feedback")as? Int32  != 0
                                        {
                                            feedback = heroeDict.value(forKey: "feedback") as? Int32 ?? 0
                                        }
                                        else
                                        {
                                            feedback = 0
                                        }
                                        UserDefaults.standard.set(feedback, forKey:"feedback")
                                        UserDefaults.standard.synchronize()
                                        var fb = String()
                                        var insta = String()
                                        var currency = String()
                                        var telephone = String()
                                        var orderTaking = Int32()
                                        if (heroeDict.value(forKey: "facebook") != nil)  || heroeDict.value(forKey: "facebook")  is String
                                        {
                                            fb = heroeDict.value(forKey: "facebook") as! String
                                        }
                                        else
                                        {
                                            fb = ""
                                        }
                                        if (heroeDict.value(forKey: "instagram") != nil)  || heroeDict.value(forKey: "instagram")  is String
                                        {
                                            insta = heroeDict.value(forKey: "instagram") as! String
                                        }
                                        else
                                        {
                                            insta = ""
                                        }
                                        if (heroeDict.value(forKey: "currency") != nil)  || heroeDict.value(forKey: "currency")  is String
                                        {
                                            currency = heroeDict.value(forKey: "currency") as! String
                                        }
                                        else
                                        {
                                            currency = "KD"
                                        }
                                        if (heroeDict.value(forKey: "Telephone") != nil)  || heroeDict.value(forKey: "Telephone")  is String
                                        {
                                            telephone = heroeDict.value(forKey: "Telephone") as! String
                                        }
                                        else
                                        {
                                            telephone = ""
                                        }
                                        
                                        if (heroeDict.value(forKey: "orderTaking") != nil)
                                            
                                        {
                                            orderTaking = heroeDict.value(forKey: "orderTaking") as! Int32
                                        }
                                        else
                                        {
                                            orderTaking = 0
                                            
                                        }
                                        //adding the name to the list
                                        
                                        SkopelosClient.shared.writeSync { context in
                                            let BrandDataInsert = Brands.SK_create(context)
                                            BrandDataInsert.brandID = brandID as! Int32
                                            BrandDataInsert.brandSeq = brandSeq as! Int32
                                            BrandDataInsert.themeID = themeID as! Int32
                                            BrandDataInsert.russian = russian as! Int32
                                            BrandDataInsert.mandarin = mandarin as! Int32
                                            BrandDataInsert.brandName = brandName as? String
                                            BrandDataInsert.brandNameAra = brandNameAr as? String
                                            BrandDataInsert.brandLogo = brandLogo as? String
                                            BrandDataInsert.feedback = feedback
                                            BrandDataInsert.facebook = fb
                                            BrandDataInsert.instagram = insta
                                            BrandDataInsert.telephone = telephone
                                            BrandDataInsert.currency = currency
                                            BrandDataInsert.orderTaking = orderTaking
                                            if orderTaking == 1
                                            {
                                                //self.strTackingOrder = "yes"
                                                DispatchQueue.main.async {
                                                    self.lbltackingOrder.isHidden = false
                                                    self.btncheck.isHidden = false
                                                }
                                            }
                                            else
                                            {
                                                //self.strTackingOrder = ""
                                                DispatchQueue.main.async {
                                                    self.lbltackingOrder.isHidden = true
                                                    self.btncheck.isHidden = true
                                                }
                                            }
                                            UserDefaults.standard.set(currency, forKey: "cur")
                                            UserDefaults.standard.synchronize()
                                            
                                            dispatchGroup.enter()
                                            ImageLoader_SDWebImage.downloadImage(BrandDataInsert.brandLogo) { (_, _) in
                                                dispatchGroup.leave()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                SkopelosClient.shared.read { context in
                                    self.listBrands = Brands.SK_all(context)
                                }
                                self.getThemes();
                            }
                        }
                    } else {
                        ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                        self.viewMainLayout.isHidden  = true
                        self.imgBrendbg.isHidden = true
                        self.viewTap.isHidden = true
                    }
                }
            }
           
        }).resume()
    }
    
    func getThemes()
    {
        
        let URL_HEROES = settingString.Setting+"/mobile/getbrands?password="+settingString.password
        //creating a NSURL
        let url = NSURL(string: URL_HEROES)
        
        //fetching the data from the url
        UserDefaults.standard.removeObject(forKey: "lang")
        UserDefaults.standard.set("eng", forKey: "lang")
        UserDefaults.standard.synchronize()

        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                    self.imgBrendbg.isHidden = true
                    self.viewTap.isHidden = true
                    
                } else {
                    
                    self.listSettings.removeAll();
                    
                    SkopelosClient.shared.writeSync { context in
                        let themes = Themes.SK_all(context)
                        themes.forEach { theme in
                            theme.SK_remove(context)
                        }
                    }
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        let dispatchGroup = DispatchGroup()
                        
                        if let heroeArray = jsonObj!.value(forKey: "theme") as? NSArray {
                            //                        self.intTotalCount =  heroeArray.count
                            //                        self.lblDisplyPer.text = "0 %"
                            //looping through all the elements
                            for heroe in heroeArray{
                                
                                //converting the element to a dictionary
                                if let heroeDict = heroe as? NSDictionary {
                                    
                                    //getting the name from the dictionary
                                    
                                    let themeID  = heroeDict.value(forKey: "themeID")
                                    let themeName = heroeDict.value(forKey: "themeName")
                                    let categoryActive = heroeDict.value(forKey: "categoryActive")
                                    let themeColorforButton = heroeDict.value(forKey: "menuBackgroundColor")
                                    let categoryInActive = heroeDict.value(forKey: "categoryInActive")
                                    let englishButton = heroeDict.value(forKey: "englishButton")
                                    let homeScreen = heroeDict.value(forKey: "homeScreen")
                                    var arabicButton:String = ""
                                    var leftArrow:String = ""
                                    
                                    if (heroeDict["leftArrow"] as? String) != nil
                                    {
                                        leftArrow  = (heroeDict["leftArrow"] as? String)!
                                    }
                                    else
                                    {
                                        leftArrow = ""
                                    }
                                    if (heroeDict["menuBackgroundTransparency"] as? String) != nil
                                    {
                                        arabicButton = heroeDict.value(forKey: "menuBackgroundTransparency") as! String
                                    }
                                    else
                                    {
                                        arabicButton = ""
                                    }
                                    let popUpBackground = heroeDict.value(forKey: "popUpBackground")
                                    let FontColor = heroeDict.value(forKey: "FontColor")
                                    let FontColorItem = heroeDict.value(forKey:"FontColorItemName")
                                    let FontColorIng = heroeDict.value(forKey:"FontColorIngName")
                                    var strsetting :String = ""
                                    if (heroeDict["homePageImage"] as? String) != nil
                                    {
                                        strsetting = heroeDict.value(forKey:"homePageImage") as! String
                                    }
                                    else
                                    {
                                        strsetting = ""
                                    }
                                    
                                    let FontColorPrice = heroeDict.value(forKey:"FontColorPrice")
                                    let itemBackgroundColor = heroeDict.value(forKey:"itemBackgroundColor")
                                    var getdatavalue:String
                                    var Promotion111:String = ""
                                    if (heroeDict["Promotion"] as? String) != nil
                                    {
                                        Promotion111 = heroeDict.value(forKey:"Promotion") as! String
                                    }
                                    else
                                    {
                                        
                                    }
                                    if heroeDict.value(forKey:"rightTop") != nil || heroeDict.value(forKey:"rightTop") is String
                                    {
                                        getdatavalue =  heroeDict.value(forKey:"rightTop") as! String
                                    }
                                    else
                                    {
                                        getdatavalue = "75"
                                    }
                                    //adding the name to the list
                                    SkopelosClient.shared.writeSync { context in
                                        let ThemeDataInsert = Themes.SK_create(context)
                                        ThemeDataInsert.rightTop =  getdatavalue
                                        ThemeDataInsert.promotion =  Promotion111
                                        ThemeDataInsert.themeID = themeID as! Int32
                                        ThemeDataInsert.themeName = themeName as? String
                                        ThemeDataInsert.categoryActive = categoryActive as? String
                                        ThemeDataInsert.setting = strsetting
                                        ThemeDataInsert.homeScreen = homeScreen as? String
                                        
                                        ThemeDataInsert.categoryInactive = categoryInActive as? String
                                        ThemeDataInsert.englishButton = englishButton as? String
                                        ThemeDataInsert.arabicButton = arabicButton
                                        ThemeDataInsert.background = homeScreen as? String
                                        ThemeDataInsert.separatorLine = themeColorforButton as? String
                                        ThemeDataInsert.popupBackground = popUpBackground as? String
                                        ThemeDataInsert.fontColor = FontColor as? String
                                        ThemeDataInsert.fontColorPrice = FontColorPrice as? String
                                        ThemeDataInsert.fontColorItemName = FontColorItem as? String
                                        ThemeDataInsert.fontColorIngName = FontColorIng as? String
                                        ThemeDataInsert.itemBackgroundColor = itemBackgroundColor as? String
                                        
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.setting, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.popupBackground, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.background, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.categoryActive, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.categoryInactive, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.englishButton, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.arabicButton, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ThemeDataInsert.homeScreen, completion: { (_, _) in
                                            dispatchGroup.leave()
                                        })
                                        self.listTheme.append(ThemeDataInsert)
                                    }
                                }
                            }
                            
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            self.CollListViewBrands.reloadData()
                            if self.btnSetting.isSelected
                            {
                                self.imgBrendbg.isHidden = true
                                self.viewTap.isHidden = true
                                self.btnSetting.isSelected = false
                                
                            }
                        }
                    } else {
                        
                        ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                        self.imgBrendbg.isHidden = true
                        self.viewTap.isHidden = true
                    }
                }
            }
            
        }).resume()
    }
    
    func fetchThemse(){
        
        let params = ["password": "552"]
        print("Tata: called now")

        API.callDictionaryAPI(webserviceFor: .brands, paramaters: params) { (error, data) in
            
            if let task = data {
                if let responseData = task as? BrandThemeModel{
                    for each in responseData.theme ?? []{
                        print("Tata: \(each.BrandName ?? "")")
                    }
                }
            }
            else{
                print("Tata : \(error)")
            }
        }
    }
    
    func getCategory(BrandID : Int32){
        UserDefaults.standard.removeObject(forKey: "lang")
        UserDefaults.standard.set("eng", forKey: "lang")
        UserDefaults.standard.synchronize()
        let URL_Cateogry = settingString.Setting+"/mobile/Category?brandID="+String(BrandID) ;
        //creating a NSURL
        let url = NSURL(string: URL_Cateogry)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    print(error ?? "")
                    
                    // self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    ToastView.shared.long(self.view, txt_msg: "Data Sync Failed please check net connection")
                    self.imgBrendbg.isHidden = true
                    self.viewTap.isHidden = true
                }
                else {
                    
                    SkopelosClient.shared.writeSync { context in
                        let predicate = NSPredicate(format: "catID != %i", 0)
                        let categories = CategoryCoreData.SK_all(context, predicate: predicate, sortTerm: "catSequence", ascending: true)
                        categories.forEach { categorie in
                            categorie.SK_remove(context)
                        }
                    }
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    {
                        //getting the avengers tag array from json and converting it to NSArray
                        if let heroeArray = jsonObj!.value(forKey: "dtCategory") as? NSArray
                        {
                            
                            //looping through all the elements
                            for heroe in heroeArray{
                                
                                //converting the element to a dictionary
                                if let heroeDict = heroe as? NSDictionary
                                {
                                    //getting the name from the dictionary
                                    let Cat_NUM = heroeDict.value(forKey: "CAT_NUM")
                                    let CAT_NAME = heroeDict.value(forKey: "CAT_NAME")
                                    
                                    let catNameArabic = heroeDict.value(forKey: "CAT_NAME_ARABIC")
                                    let CatSeq = heroeDict.value(forKey: "SEQ_NUM")
                                    let catNameMan = heroeDict.value(forKey: "catNameMan")
                                    let catNameRus = heroeDict.value(forKey: "catNameRus")
                                    //LANGUAGES
                                    
                                    let CategoryName_bangladeshi = heroeDict.value(forKey: "CategoryName_bangladeshi")
                                    let CategoryName_chinese = heroeDict.value(forKey: "CategoryName_chinese")
                                    let CategoryName_french = heroeDict.value(forKey: "CategoryName_french")
                                    let CategoryName_germany = heroeDict.value(forKey: "CategoryName_germany")
                                    let CategoryName_hindi = heroeDict.value(forKey: "CategoryName_hindi")
                                    let CategoryName_iranian = heroeDict.value(forKey: "CategoryName_iranian")
                                    let CategoryName_italian = heroeDict.value(forKey: "CategoryName_italian")
                                    let CategoryName_korean = heroeDict.value(forKey: "CategoryName_korean")
                                    let CategoryName_philippines = heroeDict.value(forKey: "CategoryName_philippines")
                                    let CategoryName_spain = heroeDict.value(forKey: "CategoryName_spain")
                                    let CategoryName_srilanka = heroeDict.value(forKey: "CategoryName_srilanka")
                                    let CategoryName_turkish = heroeDict.value(forKey: "CategoryName_turkish")
                                    let CategoryName_urdu = heroeDict.value(forKey: "CategoryName_urdu")
                                    
                                    
                                    //adding the name to the list
                                    
                                    SkopelosClient.shared.writeSync { context in
                                        let CategoryData = CategoryCoreData.SK_create(context)
                                        CategoryData.catSequence = CatSeq as! Int32
                                        CategoryData.catID =  Cat_NUM as! Int32
                                        CategoryData.catNameEng = CAT_NAME as? String
                                        CategoryData.catNameAra = catNameArabic as? String
                                        CategoryData.catNameMan = catNameMan as? String
                                        CategoryData.catNameRus = catNameRus as? String
                                        
                                        CategoryData.categoryNameUrdu = CategoryName_urdu as? String
                                        CategoryData.categoryNameHindi = CategoryName_hindi as? String
                                        CategoryData.categoryNameSpain = CategoryName_spain as? String
                                        CategoryData.categoryNameFrench = CategoryName_french as? String
                                        CategoryData.categoryNameKorean = CategoryName_korean as? String
                                        CategoryData.categoryNameChinese = CategoryName_chinese as? String
                                        CategoryData.categoryNameGermany = CategoryName_germany as? String
                                        CategoryData.categoryNameItalian = CategoryName_italian as? String
                                        CategoryData.categoryNameTurkish = CategoryName_turkish as? String
                                        CategoryData.categoryNameIraninan = CategoryName_iranian as? String
                                        CategoryData.categoryNameSrilanka = CategoryName_srilanka as? String
                                        CategoryData.categoryNamePhilippines = CategoryName_philippines as? String
                                        CategoryData.categoryNameBangladeshi = CategoryName_bangladeshi as? String
                                        self.ListCategory.append(CategoryData)
                                    }
                                }
                            }
                            self.getItems(BrandID: BrandID)
                        }
                    }
                }
            }
        }).resume()
        
    }
    
    func getItems(BrandID : Int32){
        UserDefaults.standard.removeObject(forKey: "lang")
        UserDefaults.standard.set("eng", forKey: "lang")
        UserDefaults.standard.synchronize()

        let URL_Cateogry = settingString.Setting+"/mobile/item?brandID="+String(BrandID) ;
        //creating a NSURL
        
        let url = NSURL(string: URL_Cateogry)
        self.clearTempFolder();
        
        SkopelosClient.shared.writeSync { context in
            let items = ItemsCoreData.SK_all(context)
            items.forEach { item in
                item.SK_remove(context)
            }
        }
            
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                if let error = error {
                    print(error)
                   
                } else {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        
                        let dispatchGroup = DispatchGroup()
                        
                        //getting the avengers tag array from json and converting it to NSArray
                        if let heroeArray = jsonObj!.value(forKey: "dtItems") as? NSArray {
                            //looping through all the elements
                            self.intTotalCount = heroeArray.count
//                            self.lblDisplyPer.text = "0 %"
                            for heroe in heroeArray {
                                //converting the element to a dictionary
                                if let heroeDict = heroe as? NSDictionary {
                                    
                                    //getting the name from the dictionary
                                    
                                    let ItemID  = heroeDict.value(forKey: "ID")
                                    let Price = heroeDict.value(forKey: "PRICE")
                                    let Seq_Num = heroeDict.value(forKey: "Seq_Num")
                                    let Item_Name = heroeDict.value(forKey: "ITEM_NAME")
                                    let ITEMName_bangladeshi = heroeDict.value(forKey: "ITEMName_bangladeshi")
                                    let ITEMName_chinese = heroeDict.value(forKey: "ITEMName_chinese")
                                    let ITEMName_french = heroeDict.value(forKey: "ITEMName_french")
                                    let ITEMName_germany = heroeDict.value(forKey: "ITEMName_germany")
                                    let ITEMName_hindi = heroeDict.value(forKey: "ITEMName_hindi")
                                    let ITEMName_iranian = heroeDict.value(forKey: "ITEMName_iranian")
                                    let ITEMName_italian = heroeDict.value(forKey: "ITEMName_italian")
                                    let ITEMName_korean = heroeDict.value(forKey: "ITEMName_korean")
                                    let ITEMName_philippines = heroeDict.value(forKey: "ITEMName_philippines")
                                    let ITEMName_spain = heroeDict.value(forKey: "ITEMName_spain")
                                    let ITEMName_srilanka = heroeDict.value(forKey: "ITEMName_srilanka")
                                    let ITEMName_turkish = heroeDict.value(forKey: "ITEMName_turkish")
                                    let ITEMName_urdu = heroeDict.value(forKey: "ITEMName_urdu")
                                    let Item_Name_Arabic = heroeDict.value(forKey: "ITEM_NAME_ARABIC")
                                    let ItemNameMan = heroeDict.value(forKey: "ItemNameMan")
                                    let ItemNameRus  = heroeDict.value(forKey: "ItemNameRus")
                                    let IMAGENAME = heroeDict.value(forKey: "IMAGENAME")
                                    let imageGIF = heroeDict.value(forKey: "IMAGENAME")
                                    let Cat_NUM = heroeDict.value(forKey: "CAT_NUM")
                                    let CAT_NAME = heroeDict.value(forKey: "CAT_NAME")
                                    let catNameArabic = heroeDict.value(forKey: "catNameArabic")
                                    let catNameRus = heroeDict.value(forKey: "catNameRus")
                                    let catNameMan = heroeDict.value(forKey: "catNameMan")
                                    let BrandID = heroeDict.value(forKey: "BrandID")
                                    var  OrderItemID:Int32!
                                    
                                    if heroeDict.value(forKey: "OrderItemID") != nil ||  heroeDict.value(forKey: "OrderItemID") is Int32 || !((heroeDict.value(forKey: "OrderItemID" ) != nil)) is String
                                    {
                                        OrderItemID = heroeDict.value(forKey: "OrderItemID") as? Int32

                                    }
                                    else
                                    {
                                        OrderItemID = 0

                                    }
                                    var videolink = String()
                                    if  heroeDict.value(forKey: "Video") == nil ||  heroeDict.value(forKey: "Video")as? String == ""
                                    {
                                        videolink = ""
                                    }
                                    else
                                    {
                                        videolink = (heroeDict.value(forKey: "Video") as? String)!
                                    }
                                    let isOtherLang:Int = (heroeDict.value(forKey: "IsOtherLanguages") as? Int)!
                                    let IsOtherLanguages = String(format: "%d", isOtherLang)
                                    UserDefaults.standard.set(IsOtherLanguages, forKey: "IsOtherLanguages")
                                    UserDefaults.standard.synchronize()

                                    let INGREDIENT = heroeDict.value(forKey: "INGREDIENT")
                                    let INGREDIENT_ARABIC = heroeDict.value(forKey: "INGREDIENT_ARABIC")
                                    let INGREDIENT_Man = heroeDict.value(forKey: "INGREDIENT_Man")
                                    let INGREDIENT_Rus = heroeDict.value(forKey: "INGREDIENT_Rus")
                                    let Ingredient_bangladeshi = heroeDict.value(forKey: "Ingredient_bangladeshi")
                                    let Ingredient_chinese = heroeDict.value(forKey: "Ingredient_chinese")
                                    let Ingredient_french = heroeDict.value(forKey: "Ingredient_french")
                                    let Ingredient_germany = heroeDict.value(forKey: "Ingredient_germany")
                                    let Ingredient_hindi = heroeDict.value(forKey: "Ingredient_hindi")
                                    let Ingredient_iranian = heroeDict.value(forKey: "Ingredient_iranian")
                                    let Ingredient_italian = heroeDict.value(forKey: "Ingredient_italian")
                                    let Ingredient_korean = heroeDict.value(forKey: "Ingredient_korean")
                                    let Ingredient_urdu = heroeDict.value(forKey: "Ingredient_urdu")
                                    let Ingredient_philippines = heroeDict.value(forKey: "Ingredient_philippines")
                                    let Ingredient_spain = heroeDict.value(forKey: "Ingredient_spain")
                                    let Ingredient_srilanka = heroeDict.value(forKey: "Ingredient_srilanka")
                                    let Ingredient_turkish = heroeDict.value(forKey: "Ingredient_turkish")
                                    
                                    SkopelosClient.shared.writeSync { context in
                                        let ItemDataInsert = ItemsCoreData.SK_create(context)
                                        ItemDataInsert.brandID = BrandID as! Int32
                                        ItemDataInsert.itemID = ItemID as! Int32
                                        ItemDataInsert.itemName = Item_Name as? String
                                        ItemDataInsert.itemNameAr = Item_Name_Arabic as? String
                                        ItemDataInsert.isOtherLanguages = IsOtherLanguages as? String
                                        
                                        ItemDataInsert.itemNameMan = ItemNameMan as? String
                                        ItemDataInsert.itemNameRus = ItemNameRus as? String
                                        ItemDataInsert.itemNamebangladeshi = ITEMName_bangladeshi as? String
                                        ItemDataInsert.itemNameFrench = ITEMName_french as? String
                                        ItemDataInsert.itemNameGermany = ITEMName_germany as? String
                                        ItemDataInsert.itemNameHindi = ITEMName_hindi as? String
                                        ItemDataInsert.itemNameTurkish = ITEMName_turkish as? String
                                        ItemDataInsert.itemNameUrdu = ITEMName_urdu as? String
                                        ItemDataInsert.itemNameKorean = ITEMName_korean as? String
                                        ItemDataInsert.itemNamePhilippines = ITEMName_philippines as? String
                                        ItemDataInsert.itemNameSpain = ITEMName_spain as? String
                                        ItemDataInsert.itemNameChinese = ITEMName_chinese as? String
                                        ItemDataInsert.itemNameSrilanka = ITEMName_srilanka as? String
                                        ItemDataInsert.itemNameIranian = ITEMName_iranian as? String
                                        ItemDataInsert.itemNameItalian = ITEMName_italian as? String
                                        
                                        ItemDataInsert.imageName = IMAGENAME as? String
                                        ItemDataInsert.itemSeq = Seq_Num as! Int32
                                        ItemDataInsert.price = Price as? String
                                        ItemDataInsert.imageGIF = imageGIF  as? NSData
                                        ItemDataInsert.orderItemID = OrderItemID
                                        ItemDataInsert.video = videolink
                                        ItemDataInsert.catID =  Cat_NUM as! Int32
                                        ItemDataInsert.catName = CAT_NAME as? String
                                        ItemDataInsert.catNameAra = catNameArabic as? String
                                        ItemDataInsert.catNameMan = catNameMan as? String
                                        ItemDataInsert.catNameRus = catNameRus as? String
                                        ItemDataInsert.ingredientEng = INGREDIENT as? String
                                        ItemDataInsert.ingredientAra = INGREDIENT_ARABIC as? String
                                        ItemDataInsert.ingredientMan = INGREDIENT_Man as? String
                                        ItemDataInsert.ingredientRus = INGREDIENT_Rus as? String
                                        ItemDataInsert.ingredientBangladeshi = Ingredient_bangladeshi as? String
                                        ItemDataInsert.ingredientChinese = Ingredient_chinese as? String
                                        ItemDataInsert.ingridentFrench = Ingredient_french as? String
                                        ItemDataInsert.ingridentGermany = Ingredient_germany as? String
                                        ItemDataInsert.ingridentHindi = Ingredient_hindi as? String
                                        ItemDataInsert.ingredientKorean = Ingredient_korean as? String
                                        ItemDataInsert.ingredientPhilippines = Ingredient_philippines as? String
                                        ItemDataInsert.ingredientSpain = Ingredient_spain as? String
                                        ItemDataInsert.ingredientSrilanka = Ingredient_srilanka as? String
                                        ItemDataInsert.ingredientIranian = Ingredient_iranian as? String
                                        ItemDataInsert.ingredientItalian = Ingredient_italian as? String
                                        ItemDataInsert.ingredientUrdu = Ingredient_urdu as? String
                                        ItemDataInsert.ingredientTurkish = Ingredient_turkish as? String
                                        
                                        self.listItems.append(ItemDataInsert)
                                        if (ItemDataInsert.video! != "" || !ItemDataInsert.video!.isEmpty)
                                        {
                                            OperationQueue.main.addOperation({
                                                self.saveVideo(fileName: ItemDataInsert.video!)
                                            })
                                        }
                                        
                                        dispatchGroup.enter()
                                        ImageLoader_SDWebImage.downloadImage(ItemDataInsert.imageName) { (_,_) in
                                            DispatchQueue.main.async {
                                                self.intArrCount += 1
                                            }
                                            dispatchGroup.leave()
                                        }
                                    }
                                }
                            }
                        }
                        
                        dispatchGroup.notify(queue: .main, execute: {
                            self.moveToItemsPage(BrandID)
                        })
                    }
                }
                
                
            }).resume()
    }
    
    private func moveToItemsPage(_ BrandID: Int32) {
        self.goToItemsPage()
        UIApplication.shared.endIgnoringInteractionEvents()
        UserDefaults.standard.set(BrandID, forKey: "brandId")
        UserDefaults.standard.synchronize()
    }
    
    func saveVideo(fileName: String)
    {
        do{
            let imgURL = URL(string: settingString.Setting+"/video/"+fileName)
            if imgURL != nil {
                let data = try? Data(contentsOf: imgURL!)
                if data == nil
                {
//                    SaveImageCannotBeDowloaded(fileName:fileName)
                    
                }
                else
                {
//                    let FileImage = UIImage(data: data!)
//                    if (FileImage == nil)
//                    {
//                        SaveImageCannotBeDowloaded(fileName:fileName)
//                    }
//                    else
//                    {
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileURL = documentsURL.appendingPathComponent("\(fileName)")
                        if fileName.range(of: ".MP4") != nil
                        {
                            let imgData = try Data(contentsOf: imgURL!)
                            try imgData.write(to: fileURL,options: .atomic)
                        }
                        if fileName.range(of: ".mp4") != nil
                        {
                            let imgData = try Data(contentsOf: imgURL!)
                            try imgData.write(to: fileURL,options: .atomic)
                        }

                    
//                    }
                    
                }
                
                
            }
            else{
//                SaveImageCannotBeDowloaded(fileName:fileName)
            }
            
        } catch {  }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.count == 0
        {
            return true
        }
        if validatePhone(string) {
            var strMaxLength = ""
            strMaxLength = "2"
            let currentString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            let value = Int(currentString as String) ?? 0
            let j = Int(strMaxLength) ?? 0
            let length: Int =  (currentString as String).count
            if length >= j || string.hasPrefix(",") || string.hasPrefix("*") || string.hasPrefix("#") || string.hasPrefix(";") || value == 0 || value > 9 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }

    func validatePhone(_ phoneNumber: String?) -> Bool {
        let phoneRegex = "[0-9]"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: phoneNumber) {
            return false
        } else {
            return true
        }
    }
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
   
    func setSlideshowImage(BrandID: Int32)
    
    {
        let str = String(format: "%d", BrandID)
        let URL_HEROES = settingString.Setting+"/mobile/GetImageSlideShow?brandID="+str
        //creating a NSURL
        let url = NSURL(string: URL_HEROES)
        
        SkopelosClient.shared.writeSync { context in
            let items = SlideShow.SK_all(context)
            items.forEach { item in
                item.SK_remove(context)
            }
        }

        //fetching the data from the url
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                    self.viewMainLayout.isHidden  = true
                    
                }
            } else {
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //printing the json in console
                        if let heroeArray = jsonObj!.value(forKey: "dtItems") as? NSArray {
                            //looping through all the elements
                            for heroe in heroeArray
                            {
                                //converting the element to a dictionary
                                if let heroeDict = heroe as? NSDictionary {
                                    
                                    //getting the name from the dictionary
                                    let imageName = heroeDict.value(forKey: "IMAGENAME")
                                    
                                    SkopelosClient.shared.writeSync { context in
                                        let BrandDataInsert = SlideShow.SK_create(context)
                                        BrandDataInsert.imageName = imageName as? String
                                        ImageLoader_SDWebImage.downloadImage(BrandDataInsert.imageName) { (_, _) in }
                                        self.listSlide.append(BrandDataInsert)
                                    }
                                }
                            }
                            
            
                    }
                    //getting the avengers tag array from json and converting it to NSArray
                    
                }
            }
            
        }).resume()

    }
    
    //For setupLayout
    
    func SetupLayout()
    {
        self.viewMainLayout.isHidden = true

    }
    //MARK: -API
    func passFeedbackData(BrandID: Int32)
    {
        let str = String(format: "%d", BrandID)
        let port = String(format:"%d",settingString.port)
        let URL_HEROES = "http://"+settingString.ip+":"+port+"/mobile/Getfeedback?brandID="+str
        //creating a NSURL
        let url = NSURL(string: URL_HEROES)
        
        //fetching the data from the url
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    ToastView.shared.long(self.view, txt_msg: "Brand Data Sync Failed please check net connection")
                    self.viewMainLayout.isHidden  = true
                    
                }
            } else {
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    //printing the json in console
                    // let heroeArray = jsonObj!.value(forKey: "dtFeedBackLayout") as? NSMutableArray
                    //getting the name from the dictionary
                    UserDefaults.standard.set(jsonObj!.value(forKey: "dtFeedBackLayout"), forKey: "feedbackArry")
                    UserDefaults.standard.synchronize()
                    }
                
                }
        }).resume()

        
    }
    
    
    @objc func updateLabel() {
        print("Timer Called\(timeLaunched)")
       timeLaunched += 1
    }
    //MARK: -API
    
    func getExtraData()
    {
        let URL_HEROES = "http://"+settingString.ip+":"+String(format: "%d", settingString.port)+"/mobile/getextra?brandID="+String(format: "%d",Brandhelper.brandID)
        let url = NSURL(string: URL_HEROES)
        
        SkopelosClient.shared.writeSync { context in
            let items = Extra.SK_all(context)
            items.forEach { item in
                item.SK_remove(context)
            }
        }
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                
            } else {
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    if let heroeArray = jsonObj!.value(forKey: "dtExtras") as? NSArray {
                        //looping through all the elements
                        
                        for heroe in heroeArray{
                            
                            //converting the element to a dictionary
                            if let heroeDict = heroe as? NSDictionary {
                                
                                //getting the name from the dictionary
                                
                                let ItemID  = heroeDict.value(forKey: "ItemID")
                                let Price = heroeDict.value(forKey: "Price")
                                let ExtraID = heroeDict.value(forKey: "ExtraID")
                                let ExtraName = heroeDict.value(forKey: "ExtraName")
                                let ExtraNameArabic = heroeDict.value(forKey: "ExtraNameArabic")
                                let BrandID = heroeDict.value(forKey: "BrandID")
                                let  ImageName = heroeDict.value(forKey: "ImageName")
                                //adding the name to the list
                                
                                SkopelosClient.shared.writeSync { context in
                                    let extradata = Extra.SK_create(context)
                                    extradata.brandId = BrandID as! Int32
                                    extradata.itemID = ItemID as! Int32
                                    extradata.extraNameArabic = ExtraNameArabic as? String
                                    extradata.extraName = ExtraName as? String
                                    extradata.extraID = ExtraID as! Int32
                                    extradata.price = Price as? String
                                    extradata.imageName = ImageName as? String
                                    self.listExtra.append(extradata)
                                    ImageLoader_SDWebImage.downloadImage(extradata.imageName) { (_, _) in }
                                }
                            }
                        }
                    }
                    
                } else {
                   
                }
            }
        }).resume()
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

