//
//  HideItemVC.swift
//  TMM-Ios
//
//  Created by Cisner iMac on 25/01/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData

class HideItemVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var tblFav:UITableView!
        @IBOutlet weak var conviewCartbtnHeight:NSLayoutConstraint!
    @IBOutlet weak var lblNoRecord:UILabel!
    @IBOutlet weak var viewTop:UIView!
    @IBOutlet weak var viewBackground:UIView!
    
    @IBOutlet weak var viewcartButtons:UIView!
    @IBOutlet weak var btnSave:UIButton!
    @IBOutlet weak var btnClear:UIButton!
    
    
    @IBOutlet weak var viewProcesPopup: UIView!
    @IBOutlet weak var viewSubPopup: UIView!
    @IBOutlet weak var txtTableNO: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblvalidpw: UILabel!

    
    var arrFav = [[String:AnyObject]]()
    var themeData = [Themes]()
    var listItems = [ItemsCoreData]()
    var listItems1 = NSSet()
    var getCatId :Int32 = 0
    var selectedIndex :Int = 0
    var GetArr : NSMutableArray = []
    var strIsCome = String()
    var selectedItemIndex:Int = 0
    var getWaiterId = Int()
     var getItemId = String()
    var getBrandId  = String()
    var getPort = Int32()
    var getIp = String()

    struct ItemDetails {
        static var CategoryID = Int32();
        static var FavID = Int32();
        static var itemPosition = IndexPath() ;
        static var staticThemeData = [Themes]()
        static var itemId = Int32();
        
    }
    
    struct Language {
        static var language = "";
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSettingData()
        viewProcesPopup.isHidden = true
        lblvalidpw.isHidden = true
        txtTableNO.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
//        viewcartButtons.isHidden = false
        self.lblNoRecord.text = "No Record found"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
        self.viewTop.frame = self.view.bounds
        self.viewTop.translatesAutoresizingMaskIntoConstraints = false
        self.viewTop.addGestureRecognizer(tap)
        self.GethideItems()
        let str = themeData[0].fontColorItemName
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.btnSubmit.setBackgroundImage((image ?? placeholder), for: [])
            self.btnCancel.setBackgroundImage((image ?? placeholder), for: [])
            self.btnSave.setBackgroundImage((image ?? placeholder), for: [])
            self.btnClear.setBackgroundImage((image ?? placeholder), for: [])
        }
        

        if   (str == nil || str!.isEmpty)
        {
            self.btnSave.titleLabel?.textColor = UIColor.black
            self.btnClear.titleLabel?.textColor = UIColor.black
            self.btnSubmit.titleLabel?.textColor = UIColor.black
            self.btnCancel.titleLabel?.textColor = UIColor.black

            
        }
        else
        {
            let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
            self.btnSubmit.setTitleColor(color1, for: .normal)
            self.btnCancel.setTitleColor(color1, for: .normal)
            self.btnSave.setTitleColor(color1, for: .normal)
            self.btnClear.setTitleColor(color1, for: .normal)

        }

        
    }
    //MARK: -TableView Method
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrFav.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict = arrFav[section] ["data"]
        return dict!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavCell
        
        let dictdata = arrFav[indexPath.section]
        let arrGet:[[String:AnyObject]]  = dictdata["data"] as! [[String:AnyObject]]
        let dict  = arrGet[indexPath.row]
        cell.viewFav.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewFav.layer.borderWidth = 0.7
        cell.viewFav.layer.cornerRadius = 4.0
        let CurrentLanguage =  UserDefaults.standard.value(forKey: "lang") as? String
        if (CurrentLanguage == "eng")
        {
            //            cell.lblItemname.text = dict.itemName
            cell.lblItemname.text = dict["itemName"] as? String
            
        }
        else
        {
            //            cell.lblItemname.text = dict.itemNameAr
            cell.lblItemname.text = dict["itemNameAr"] as? String
            
            
        }
        let str = themeData[0].fontColorItemName
        
        
        if   (str == nil || str!.isEmpty)
        {
            cell.lblItemname.textColor = UIColor.black
            
            
        }
        else
        {
            let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
            cell.lblItemname.textColor  = color1
            
        }
        ImageLoader_SDWebImage.setImage((dict["imageName"] as? String), into: cell.imgFav)
        
        ImageLoader_SDWebImage.getImage(themeData[0].popupBackground) { (image, _) in
            if let img = image {
                cell.contentView.backgroundColor = UIColor(patternImage: img)
            } else {
                cell.contentView.backgroundColor = .white
            }
        }
        cell.btnFav.addTarget(self, action: #selector(self.btnFvrtItemClick(_:)), for: .touchUpInside)
        return cell

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view  = UIView(frame: CGRect(x: 0, y: 0, width:self.tblFav.frame.size.width, height: 50))
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 5.0
        let lbl = UILabel(frame:CGRect(x: 0, y: 0, width:view.frame.size.width, height: 50))
        lbl.text = arrFav[section]["title"] as? String
        let fontText: UIFont = (UIFont(name: "Calibri-Bold" , size: 25))!
        lbl.font = fontText
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.contentMode = .scaleAspectFit
        //        lbl.backgroundColor = UIColor(patternImage:(self.GetImageFromStorage(fileName: themeData[0].categoryActive!)))
        lbl.backgroundColor = UIColor(red: 81.0/255, green: 81.0/255, blue: 81.0/255, alpha: 0.8)
        lbl.clipsToBounds = true
        view.addSubview(lbl)
        
        view.clipsToBounds = true
        
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //        var str = String()
        //        let CurrentLanguage = Language.language;
        //        if (CurrentLanguage=="eng")
        //        {
        //            str = self.listItems[indexPath.row].itemName!
        //
        //        }
        //        else
        //        {
        //            str = self.listItems[indexPath.row].itemNameAr!
        //
        //        }
        //        let maxHeight = 5000
        //        let size = CGSize(width: 170, height: CGFloat.greatestFiniteMagnitude)
        //        let attributes: [String : AnyObject] = [
        //            fontA : UIFont(name: "Calibri", size: 23)
        //            // etc.
        //        ]
        //        let rect = text.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        //        return rect.height
        //        return max(100, height)
        let dict = arrFav[indexPath.section]
        let arrGet:[[String:AnyObject]]  = dict ["data"] as! [[String:AnyObject]]
        let dictdata = arrGet[indexPath.row]
        
        var strData = String()
        let CurrentLanguage = Language.language;
        if (CurrentLanguage=="eng")
        {
            strData = dictdata["itemName"] as! String
            
        }
        else
        {
            strData = dictdata["itemNameAr"] as! String
        }
        if strData != ""
        {
            let constraint = CGSize(width: self.tblFav.frame.size.width - 20, height: 50000.0)
            
            let fontText: UIFont = (UIFont(name: "Calibri" , size: 23))!
            let size: CGRect = strData.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: fontText], context: nil)
            var height1: CGFloat
            if size.size.height < 30
            {
                height1 = 150
                return height1
            }
            else
            {
                height1 = size.size.height + 150
                return height1 + 10
                
            }
        }
        else
        {
            return 100
        }
    }
    func downloadThemes(ThemeID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData = items;
            ItemDetails.staticThemeData = items;
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].popupBackground) { (image, _) in
                if let img = image {
                    self.viewBackground.backgroundColor = UIColor(patternImage: img)
                    self.tblFav.backgroundColor = UIColor(patternImage: img)
                    self.viewSubPopup.backgroundColor = UIColor(patternImage: img)
                } else {
                    self.viewBackground.backgroundColor = .white
                    self.tblFav.backgroundColor = .white
                    self.viewSubPopup.backgroundColor = .white
                }
            }
            
            self.viewBackground.layer.cornerRadius = 5.0
            self.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
            self.viewBackground.layer.borderWidth = 3.0
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].categoryInactive) { (image, _) in
                let placeholder = ImageLoader_SDWebImage.placeholder
                self.btnSubmit.setBackgroundImage((image ?? placeholder), for: [])
                self.btnCancel.setBackgroundImage((image ?? placeholder), for: [])
                self.btnSave.setBackgroundImage((image ?? placeholder), for: [])
                self.btnClear.setBackgroundImage((image ?? placeholder), for: [])
            }
            
            self.btnClear.setTitleColor(.black, for: .normal)
            self.btnSave.setTitleColor(.black, for: .normal)
            self.btnClear.setTitleColor(.black, for: .normal)
            self.btnSave.setTitleColor(.black, for: .normal)
            
            
            self.viewSubPopup.layer.cornerRadius = 5.0
            self.viewSubPopup.layer.borderColor = UIColor.lightGray.cgColor
            self.viewSubPopup.layer.borderWidth = 3.0
            
            let str = self.themeData[0].fontColorItemName
            
            
            if   (str == nil || str!.isEmpty)
            {
                self.btnSubmit.titleLabel?.textColor = UIColor.black
                self.btnCancel.titleLabel?.textColor = UIColor.black
                self.btnSave.titleLabel?.textColor = UIColor.black
                self.btnClear.titleLabel?.textColor = UIColor.black
                
            }
            else
            {
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                //                self.btnProcess.titleLabel?.textColor  = color1
                self.btnSubmit.setTitleColor(color1, for: .normal)
                self.btnCancel.setTitleColor(color1, for: .normal)
                self.btnSave.setTitleColor(color1, for: .normal)
                self.btnClear.setTitleColor(color1, for: .normal)
                
                
                
            }
        }
        
        
    }
    
    func wagaDuggu (fileName: String) -> UIImage{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }else{
            return UIImage(named: "NoImage")!
        }
    }
    

    @IBAction func btnprocesstClick(_ sender: Any)
    {
        viewProcesPopup.isHidden = false
        btnClear.isSelected = false
        self.btnSave.isSelected = true
    }
    @IBAction func btnclearCartClick(_ sender: Any)
    {
        
        
            self.RemoveAllData(completion: { (success) in
                if success
                {
//                    ToastView.shared.long(self.view, txt_msg: "Data sync successfully!")
                    self.WSCallforSyncbtnClick(completion: {(success) in
                        ToastView.shared.long(self.view, txt_msg: "Data sync successfully!")
                        self.navigationController?.popViewController(animated: true)
                        
                    })

                }
                else
                {
                    ToastView.shared.long(self.view, txt_msg: "No data available Please try again")

                }
                
                })
//        let alertController = UIAlertController(title: "", message: "Are sure want to clear data?", preferredStyle: .alert)
//
//        // Create the actions
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//                self.viewProcesPopup.isHidden = true
//                UserDefaults.standard.removeObject(forKey: "isDatasaved")
//                UserDefaults.standard.synchronize()
////                self.RemoveFromData()
//
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
//            UIAlertAction in
//            NSLog("Cancel Pressed")
//            self.tblFav.isHidden = false
//            self.lblNoRecord.isHidden = true
//        }
//
//        // Add the actions
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//
//        // Present the controller
//        self.present(alertController, animated: true, completion: nil)

    }
    @IBAction func btnSendOrdrClick(_ sender: Any)
    {
        self.view.endEditing(true)
//        if (txtTableNO.text?.isEmpty)! || txtTableNO.text == "" || txtTableNO.text?.count == 0
//        {
//            OperationQueue.main.addOperation({
//                ToastView.shared.long(self.view, txt_msg: "Please enter table number")
//                self.txtTableNO.becomeFirstResponder()
//            })
//        }
         if (txtPassword.text?.isEmpty)! || txtPassword.text == "" || txtPassword.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter password")
                self.txtPassword.becomeFirstResponder()
            })
        }
        else
        {
            
            passWordVerify { (success) in
                if success
                {
                    self.WScallforSaveClick(completion: { (success) in
                        if success
                        {
                            let alert = UIAlertController(title: "", message: "Your data save successfully!", preferredStyle: .alert)
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
//                                self.RemoveFromData()
                                UserDefaults.standard.set("yes", forKey: "isDatasaved")
                                self.txtPassword.text = ""
                                self.viewProcesPopup.isHidden = true
                                
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
//                            self.GethideItems()
                        }
                    })
                }
                else {
                    let alert = UIAlertController(title: "", message: "Password does not match", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
                
            }
            
        }
    }
    func GethideItems()
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isCheck = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            self.listItems = items
            let sortedArray = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "catID", ascending: true)])
            self.listItems = sortedArray as! [ItemsCoreData]
         self.getItemId = ""
            self.arrFav.removeAll()
            if self.listItems.count > 0
            {

                self.lblNoRecord.isHidden = true
                for dict in self.listItems
                {
                    self.getBrandId = String(format: "%d",dict.brandID )

                    if self.arrFav.count > 0
                    {
                        var isAdded : Bool = false
                        for i in 0..<self.arrFav.count
                        {
                            let dic =  NSMutableDictionary(dictionary: self.arrFav[i] as Dictionary)
                            
                            if (dic["title"] as? String) == dict.catName
                            {
                                var aaaaaaa:[[String:AnyObject]] = dic.object(forKey: "data") as! [[String:AnyObject]]
                                let keys = Array(dict.entity.attributesByName.keys)
                                let dic11 = dict.dictionaryWithValues(forKeys: keys)
                                aaaaaaa.append(dic11 as [String : AnyObject])
                                dic["data"] = aaaaaaa as AnyObject
                                self.arrFav[i] = dic as! [String : AnyObject]
                                print(self.arrFav)
                                isAdded = true
                            }
                        }
                        
                        if isAdded == false
                        {
                            var arr1 = [[String:AnyObject]]()
                            let keys = Array(dict.entity.attributesByName.keys)
                            let dic = dict.dictionaryWithValues(forKeys: keys)
                            arr1.append(((dic as AnyObject) as? [String : AnyObject])!)
                            self.arrFav.append (["data":(arr1 as AnyObject)  ,"title":dict.catName! as AnyObject])
                            
                        }
                        
                        
                    }
                    else
                    {
                        var arr1 = [[String:AnyObject]]()
                        let keys = Array(dict.entity.attributesByName.keys)
                        let dic = dict.dictionaryWithValues(forKeys: keys)
                        arr1.append(((dic as AnyObject) as? [String : AnyObject])!)
                        self.arrFav.append (["data":(arr1 as AnyObject)  ,"title":dict.catName! as AnyObject])
                        
                    }
                    
                }
                
                //                self.conviewTotalHeight.constant = 50
                    if self.listItems.count > 0
                    {
                        for dict in self.listItems
                        {
                           //
                            if self.getItemId == ""
                            {
                                self.getItemId = String(format: "%d",dict.itemID)       //String(format: "%d",dic["itemID"] as! Int32 )
                            }
                            else
                            {
                                self.getItemId = String(format: "%@,%d",self.getItemId ,dict.itemID)
                            }
                        }
                    

                  
                }

                 print(self.getItemId)
                
                self.tblFav.isHidden = false
                self.tblFav.rowHeight = UITableViewAutomaticDimension
                self.tblFav.estimatedRowHeight = 320
                self.conviewCartbtnHeight.constant = 50
                self.tblFav.reloadData()
                
            }
            else
            {
                self.lblNoRecord.isHidden = false
                self.tblFav.isHidden = true
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                self.btnSubmit.setTitleColor(color1, for: .normal)
                self.btnCancel.setTitleColor(color1, for: .normal)

                self.conviewCartbtnHeight.constant = 50
                
            }
            
        }
    }
    @objc func btnFvrtItemClick(_ sender: Any)
    {
        var row:Int!
        let btn = sender as! UIButton
        var section:Int!
        let position: CGPoint = btn.convert(CGPoint(x: 0, y: 0), to: self.tblFav)
        if let indexPath = self.tblFav.indexPathForRow(at: position)
        {
            section = indexPath.section
            row = indexPath.row
        }
        
        let dic = self.arrFav[section]
        let arr1:[[String:AnyObject]]   = (dic ["data"] as? [[String:AnyObject]])!
        let dic1  = arr1[row]
        getCatId = dic1["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isCheck = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            for dict in items
            {
                if dict.itemID == self.getCatId
                {
                    dict.isCheck = 0
                }
            }
            self.GethideItems()
        }
    }
    
    
    func RemoveAllData (completion:@escaping (_ success:Bool) -> Void)
    {
     
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isCheck = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            for dict in items
            {
                dict.isCheck = 0
            }
            completion(true)
        }
    }

    func RemoveFromData()
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isCheck = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            for dict in items
            {
                dict.isCheck = 0
            }
            self.tblFav.isHidden = true
            self.lblNoRecord.isHidden = false
            self.conviewCartbtnHeight.constant = 0
            
        }
        
    }

    func colorWithHexString (hex:String) -> UIColor {
        //        var cString:String = //hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
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
    @IBAction func btnCancelClick(_ sender: Any)
    {
        viewProcesPopup.isHidden = true
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClosePopupClick(_ sender: Any)
    {
        viewProcesPopup.isHidden = true
    }
    func getSettingData()
    {
        SkopelosClient.shared.read { context in
            let Setting = SettingDataCore.SK_all(context)
            self.getIp = Setting[0].ipAddress!
            self.getPort = Setting[0].port
        }

    }
    
    func passWordVerify(completion:@escaping (_ success:Bool) -> Void)
    {
        
        let strUrl = String(format: "http://%@:%@/mobile/userlogin?password=%@",self.getIp,String(format: "%d", getPort),self.txtPassword.text!)
        let url = NSURL(string: strUrl)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if error != nil
            {
                DispatchQueue.main.async {
                    ToastView.shared.long(self.view, txt_msg: "No internet,Please check internet connectivity")
                }
            }
            else
            {

                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //printing the json in console
                    print(jsonObj?.value(forKey: "dtUsers")! as Any)
                    let jsondata = jsonObj?.value(forKey: "dtUsers")! as Any
                    if let jsondata = jsondata as? [String:AnyObject] {
                        
                        if jsondata["WaiterID"] as? Int32 != 0
                        {
                            DispatchQueue.main.async
                                {
                                    self.lblvalidpw.isHidden = true
                                    self.getWaiterId = (jsondata["WaiterID"] as? Int)!
                                    completion(true)
                                    
                            }
                            
                        }
                        else
                        {
                            DispatchQueue.main.async
                                {
                                    self.lblvalidpw.isHidden = false
                                    self.txtPassword.text = ""
                                    completion(false)
                                    
                            }
                            
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.lblvalidpw.isHidden = false
                        self.txtPassword.text = ""
                        completion(false)
                    }
                }
                
            }
        }).resume()
        
        
    }
    //MARK: -API Parsing
    
    func WScallforSaveClick(completion:@escaping (_ success:Bool) -> Void)
    
    {
        
        let strUrl = String(format: "http://%@:%@/mobile/OutofStock?Json=%@",getIp,String(format: "%d",getPort),getItemId)
        let url = NSURL(string: strUrl)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if error != nil
            {
                DispatchQueue.main.async {
                    ToastView.shared.long(self.view, txt_msg: "No internet,Please check internet connectivity")
                }
            }
            else
            {
                
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200
                {
                    DispatchQueue.main.async
                        {
                            completion(true)

                    }

                }

                        else
                        {
                            DispatchQueue.main.async
                                {
                                    completion(false)
                                    
                            }
                            
                        }
                }
        }).resume()
        

        
    }
    
   func WSCallforSyncbtnClick(completion:@escaping (_ success:Bool) -> Void)
   {
        let strUrl = String(format: "http://%@:%@/mobile/getoutofStock?BrandID=%@",getIp,String(format: "%d", getPort),getBrandId)
        let url = NSURL(string: strUrl)
    URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
        DispatchQueue.main.async {
            if error != nil
            {
                ToastView.shared.long(self.view, txt_msg: "No internet,Please check internet connectivity")
            }
            else
            {
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    let jsondata = jsonObj?.value(forKey: "dtItems")! as Any
                    if let jsondata = jsondata as? [[String:AnyObject]] {
                        var arrGet = [[String:AnyObject]]()
                        if jsonObj?["Message"] as? String == "Success"
                        {
                            
                            arrGet = jsondata
                            
                            SkopelosClient.shared.read { context in
                                let predicate = NSPredicate(format: "brandID = \(NSNumber(value:Int(self.getBrandId)!))")
                                let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
                                for i in 0..<items.count
                                {
                                    let dict = items[i]
                                    for j in 0..<arrGet.count
                                    {
                                        var getDict = arrGet[j]
                                        if dict.itemID == getDict["id"]as?Int32
                                        {
                                            dict.isCheck = 1
                                        }
                                        
                                    }
                                }
                                self.tblFav.reloadData()
                                completion(true)
                                
                            }
                        }
                        else
                        {
                            ToastView.shared.long(self.view, txt_msg: "Please try again")
                            completion(false)
                        }
                    }
                }
                else
                {
                    ToastView.shared.long(self.view, txt_msg: "Please try again")
                    completion(false)
                }
                
            }
        }
    }).resume()
    

    
    
    }
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) { //sender: UITapGestureRecognizer
        
        navigationController?.popViewController(animated: true)
        
    }

  

}
