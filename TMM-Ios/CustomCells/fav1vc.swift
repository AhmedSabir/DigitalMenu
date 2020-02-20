//
//  fav1vc.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/28/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData

class fav1vc: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    //Outlets
    // @IBOutlet weak var btnclose:UIButton!
    @IBOutlet weak var tblFav:UITableView!
    //    @IBOutlet weak var contblHeight:NSLayoutConstraint!
    @IBOutlet weak var conbtnClearHeight:NSLayoutConstraint!
    @IBOutlet weak var btnClearFav:UIButton!
    @IBOutlet weak var lblNoRecord:UILabel!
    @IBOutlet weak var viewTop:UIView!
    @IBOutlet weak var viewBackground:UIView!
    
    @IBOutlet weak var viewcartButtons:UIView!
    @IBOutlet weak var btnProcess:UIButton!
    @IBOutlet weak var btnClearcart:UIButton!
    @IBOutlet weak var conviewTotalHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewProcesPopup: UIView!
    @IBOutlet weak var viewSubPopup: UIView!
    @IBOutlet weak var txtTableNO: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSendOrder: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblvalidpw: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblGrandTotalData: UILabel!
    
    
    var arrFav = [[String:AnyObject]]()
    var themeData = [Themes]()
    var listItems = [ItemsCoreData]()
    var listItems1 = NSSet()
    var getCatId :Int32 = 0
    var selectedIndex :Int = 0
    var GetArr : NSMutableArray = []
    var strIsCome = String()
    //    var IsNav = String()
    var selectedItemIndex:Int = 0
    var getWaiterId = Int()
    var getIp = String()
    var getPort = Int32()
    var getOrderPort = Int()
    
    
    
    
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
    
    override func viewDidLoad()
    {
        
        viewProcesPopup.isHidden = true
        lblvalidpw.isHidden = true
        txtTableNO.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        getSettingData()
        
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            self.GetItems1()
            viewcartButtons.isHidden = false
            btnClearFav.isHidden = true
            btnProcess.setTitle("Process Order", for: .normal)
            btnClearcart.setTitle("Clear Cart", for: .normal)
            
            // self.conbtnClearHeight.constant = 50
            
        }
        else
        {
            
            self.GetItems()
            btnClearFav.isHidden = false
            viewcartButtons.isHidden = true
            //                self.conbtnClearHeight.constant = 50
            //                self.conviewTotalHeight.constant = 0
            
            
        }
        
        self.lblNoRecord.text = "No Record found"
        //        arrFav = [["name":"BACKED EGGS","img":"img1.jpeg"],["name":"FOCASIA BIANACA","img":"img2.jpeg"],["name":"RIGATONI","img":"img3.jpeg"]]
        self.btnClearFav.layer.borderWidth = 0.7
        self.btnClearFav.layer.borderColor = UIColor.lightGray.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.tblFav.rowHeight = UITableViewAutomaticDimension
        self.tblFav.estimatedRowHeight = 320
        
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
        self.viewTop.frame = self.view.bounds
        self.viewTop.translatesAutoresizingMaskIntoConstraints = false
        self.viewTop.addGestureRecognizer(tap)
        
        
    }
    func getSettingData()
    {
        SkopelosClient.shared.read { context in
            let Setting = SettingDataCore.SK_all(context)
            self.getIp = Setting[0].ipAddress!
            self.getPort = Setting[0].port
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) { //sender: UITapGestureRecognizer
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -TableView Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict = arrFav[section] ["data"]
        return dict!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! FavCell
            
            let dictdata = arrFav[indexPath.section]
            let arrGet:[[String:AnyObject]]  = dictdata["data"] as! [[String:AnyObject]]
            let dict  = arrGet[indexPath.row]
            cell.txtcomment.layer.cornerRadius = 5.0
            cell.txtcomment.text = "Please enter comment"
            cell.txtcomment.textColor = UIColor.lightGray
            cell.txtcomment.layer.borderWidth = 1
            cell.txtcomment.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewFav.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewFav.layer.borderWidth = 0.7
            cell.viewFav.layer.cornerRadius = 4.0
            let CurrentLanguage =  UserDefaults.standard.value(forKey: "lang") as? String
            if (CurrentLanguage == "eng")
            {
                cell.lblItemname.text = dict["itemName"] as? String
                
            }
            else
            {
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
            
            let str1 = themeData[0].fontColorPrice
            if   (str == nil || str!.isEmpty)
            {
                cell.lblunitPrice.textColor = UIColor.black
                cell.lbltotalPrice.textColor = UIColor.black
                
                
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorPrice!)
                cell.lblunitPrice.textColor  = color1
                cell.lbltotalPrice.textColor = color1
                
                
            }
            
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            
            cell.lblunitPrice.text = String(format: "Price :  %@", (dict["price"] as? String)!)
            cell.lblQuantity.text = String(format: "%d", (dict["qty"] as? Int)!)
            
            let price : Float = Float(dict["price"] as! String)!
            let qty = (dict["qty"] as? Int)!
            
            ImageLoader_SDWebImage.setImage((dict["imageName"] as? String), into: cell.imgFav)
            
            cell.lbltotalPrice.text = String(format: "Total :  %.3f", (price * Float(qty)))
            
            cell.btnPlus.addTarget(self, action: #selector(btnplusClick(_:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(btnminusClick(_:)), for: .touchUpInside)
            cell.backgroundColor = UIColor.clear // NEW
            return cell
        }
        else
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
            let str1 = themeData[0].fontColorPrice
            
            
            if   (str == nil || str!.isEmpty)
            {
                cell.lblDesc.textColor = UIColor.black
                
                
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorPrice!)
                cell.lblDesc.textColor  = color1
                
            }
            if strIsCome == "check"
            {
                cell.btnFav.isHidden = true
            }
            else
            {
                cell.btnFav.isHidden = false
                cell.btnFav.tag = indexPath.row
                cell.btnFav.addTarget(self, action: #selector(btnFvrtItemClick(_:)), for: .touchUpInside)
                
            }
            cell.lblDesc.text = dict["price"] as? String
            ImageLoader_SDWebImage.setImage((dict["imageName"] as? String), into: cell.imgFav)
            
            ImageLoader_SDWebImage.getImage(themeData[0].popupBackground) { (image, _) in
                if let img = image {
                    cell.contentView.backgroundColor = UIColor(patternImage: img)
                } else {
                    cell.contentView.backgroundColor = .white
                }
            }
            
            return cell
        }
        
    }
    
    //MARK:- Fav Data
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
        let arr1:[[String:AnyObject]] = (dic ["data"] as? [[String:AnyObject]])!
        let dic1  = arr1[row]
        getCatId = dic1["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isFav = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.getCatId
                {
                    dict.isFav = 0
                }
            }
            self.GetItems()
        }
    }
    
    func removeFav()
    {
        let indexPath = tblFav.indexPathForSelectedRow
        let sectionNumber = indexPath?.section
        let rowNumber = indexPath?.row
        
        let dic = self.arrFav[sectionNumber!]
        let arr1:[[String:AnyObject]]   = (dic ["data"] as? [[String:AnyObject]])!
        let dic1  = arr1[rowNumber!]
        getCatId = dic1["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isFav = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.getCatId
                {
                    dict.isFav = 0
                }
            }
            self.GetItems()
        }
    }
    
    
    //MARK:- For Cart Data
    
    @objc func btnplusClick(_ sender: Any)
    {
        let  btn = sender as! UIButton
        let  touchPoint = btn.convert(CGPoint.zero, to: tblFav)
        let  indexPath: IndexPath? = tblFav.indexPathForRow(at: touchPoint)
        
        let sectionNumber = indexPath?.section
        let rowNumber = indexPath?.row
        
        let dic = self.arrFav[sectionNumber!]
        let arr1:[[String:AnyObject]]   = (dic ["data"] as? [[String:AnyObject]])!
        let dic1  = arr1[rowNumber!]
        getCatId = dic1["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "qty > 0")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.getCatId
                {
                    var Qty : Int = Int(dict.qty)
                    Qty = Qty + 1
                    dict.qty = Int32(Qty)
                }
            }
            self.GetItems1()
        }
    }
    
    @IBAction func btnprocesstClick(_ sender: Any)
    {
        viewProcesPopup.isHidden = false
    }
    
    @IBAction func btnclearCartClick(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: "", message: "Are sure want to clear cart?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.removeAllcartdata()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.tblFav.isHidden = false
            self.lblNoRecord.isHidden = true
            self.conbtnClearHeight.constant = 50
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func removeAllcartdata()
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "qty > 0")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            for dict in items
            {
                dict.qty = 0
            }
            
            self.tblFav.isHidden = true
            self.conviewTotalHeight.constant = 0
            self.lblNoRecord.isHidden = false
            self.conbtnClearHeight.constant = 0
        }
    }
    
    @objc func btnminusClick(_ sender: Any)
    {
        let  btn = sender as! UIButton
        let  touchPoint = btn.convert(CGPoint.zero, to: tblFav)
        let  indexPath: IndexPath? = tblFav.indexPathForRow(at: touchPoint)
        
        //        let indexPath = tblFav.indexPathForSelectedRow
        let sectionNumber = indexPath?.section
        let rowNumber = indexPath?.row
        
        let dic = self.arrFav[sectionNumber!]
        let arr1:[[String:AnyObject]]   = (dic ["data"] as? [[String:AnyObject]])!
        let dic1  = arr1[rowNumber!]
        getCatId = dic1["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "qty > 0")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            var index : Int = 0
            for dict in items
            {
                if dict.itemID == self.getCatId
                {
                    var Qty : Int = Int(dict.qty)
                    if Qty != 0
                    {
                        Qty = Qty - 1
                        dict.qty = Int32(Qty)
                    }
                    else
                    {
                        self.arrFav.remove(at: index)
                    }
                }
                
                index = index + 1
            }
            
            print(self.arrFav)
            
            if self.arrFav.count == 0
            {
                self.tblFav.isHidden = true
                self.lblNoRecord.isHidden = false
                self.conbtnClearHeight.constant = 0
                self.conviewTotalHeight.constant = 0
                
            }
            
            
            self.GetItems1()
            print("saved")
            
        }
    }
    
    @IBAction func btnSendOrdrClick(_ sender: Any)
    {
        self.view.endEditing(true)
        if (txtTableNO.text?.isEmpty)! || txtTableNO.text == "" || txtTableNO.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter table number")
                self.txtTableNO.becomeFirstResponder()
            })
        }
        else if (txtPassword.text?.isEmpty)! || txtPassword.text == "" || txtPassword.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter waiter id/password")
                self.txtPassword.becomeFirstResponder()
            })
        }
        else
        {
            
            passWordVerify { (success) in
                if success
                {
                    self.wscallForplaceOrder()
                }
                else
                {
                    let alertController = UIAlertController(title: "", message: "Invalid Password.", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.txtPassword.text = ""
                        self.txtTableNO.text = ""
                        self.lblvalidpw.isHidden = false
                        self.txtPassword.text = ""
                        
                    }
                    alertController.addAction(okAction)
                    
                }
                
            }
            
            
        }
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
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    func passWordVerify(completion:@escaping (_ success:Bool) -> Void)
    {
        let strUrl = String(format: "http://%@:%@/mobile/userlogin?password=%@",getIp,String(format: "%d", getPort),self.txtPassword.text!)
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
                    let jsondata = jsonObj?.value(forKey: "dtUsers")! as! [String:AnyObject]
                    
                    if jsondata["WaiterID"] as? Int32 != 0
                    {
                        DispatchQueue.main.async
                            {
                                self.lblvalidpw.isHidden = true
                                self.getWaiterId = (jsondata["WaiterID"] as? Int)!
                                self.getOrderPort = Int(jsondata["PORT"] as! String)!
                                self.getPort = Int32(self.getOrderPort)
                                completion(true)
                                
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async
                            {
                                    let alertController = UIAlertController(title: "", message: "Invalid Password.", preferredStyle: .alert)

                                    // Create the actions
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        NSLog("OK Pressed")
                                        self.txtPassword.text = ""
                                        self.txtTableNO.text = ""
                                        self.lblvalidpw.isHidden = false
                                        self.txtPassword.text = ""

                                    }
                                    alertController.addAction(okAction)
                                self.present(alertController, animated: true)
                                self.txtPassword.text = ""
                                self.txtTableNO.text = ""
                                self.lblvalidpw.isHidden = false
                                self.txtPassword.text = ""
                                
                                completion(false)
                                
                        }
                        
                    }
                    
                    //                    self.lblvalidpw.isHidden = true
                    //                    verified = true
                }
                else
                {
                    let alertController = UIAlertController(title: "", message: "Something went wrong Please try again.", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.txtPassword.text = ""
                        self.txtTableNO.text = ""
                        self.lblvalidpw.isHidden = false
                        self.txtPassword.text = ""
                        
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                    completion(false)
                    
                }
                
            }
        }).resume()
        
        
    }
    
    
    func wscallForplaceOrder()
    {
        
        SkopelosClient.shared.read { context in
            
            let predicate = NSPredicate(format: "qty > 0")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            let arrcomments : NSMutableArray = []
            let arrOrders : NSMutableArray = []
            
            for dict in items
            {
                print(dict)
                let dicttemp = ["Comments" : arrcomments , "Extras" : arrcomments , "SendtoPrinter" : "false" , "TableNO" : self.txtTableNO.text! , "OrderItemID" : dict.orderItemID , "ItemID": dict.itemID as Any, "ItemName" : dict.itemName as Any , "ItemNameArabic" : dict.itemNameAr as Any , "Price" : dict.price! , "Quantity" : dict.qty as Any] as [String : AnyObject]
                arrOrders.add(dicttemp)
            }
            
            let strJsonString = self.json(from: arrOrders)
            let strUrl = String(format: "http://%@:%@/Webservice.asmx/ProcessOrder?TableNO=%@&WaiterID=%@&Person=%@&json=%@&comments=%@",self.getIp,String(format: "%d", self.getPort),self.txtTableNO.text!,String(format: "%d", self.getWaiterId),"1",strJsonString!,"")
            let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let url = NSURL(string: urlString!)
            
            //fetching the data from the url
            
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                DispatchQueue.main.async {
                    if error != nil
                    {
                        
                        ToastView.shared.long(self.view, txt_msg: "No internet,Please check internet connectivity")
                    }
                    else
                    {
                        let httpResponse = response as! HTTPURLResponse
                        print("response code = \(httpResponse.statusCode)")
                        
                        if httpResponse.statusCode == 200
                        {
                            print("success")
                            self.viewProcesPopup.isHidden = true
                            self.removeAllcartdata()
                        }
                        else
                        {
                            
                            let alertController = UIAlertController(title: "", message: "Something went wrong,Please try after sometime.", preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                                self.txtPassword.text = ""
                                self.txtTableNO.text = ""
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                            
                        }
                    }
                    
                }
            }).resume()
        }
    }
    
    //MARK:- Tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return arrFav.count
        
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
    
    
    //MARK: -Action Method
    
    //    @IBAction func btnCloseClick(_ sender: UIButton)
    //    {
    //        let pushVC = storyboard?.instantiateViewController(withIdentifier: "ItemViewController")as! ItemViewController
    //       self.navigationController?.pushViewController(pushVC, animated: false)
    //    }
    
    
    @IBAction func btnclearFilterClick(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: "", message: "Are sure want to clear filter?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            //            self.arrFav.removeAll()
            //            self.tblFav.reloadData()
            //            self.tblFav.isHidden = true
            //            self.lblNoRecord.isHidden = false
            //            self.conbtnClearHeight.constant = 0
            self.RemoveFromFav()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.tblFav.isHidden = false
            self.lblNoRecord.isHidden = true
            self.conbtnClearHeight.constant = 50
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func downloadThemes(ThemeID: Int32)
        
    {
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ItemDetails.staticThemeData = items
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].categoryActive) { (image, _) in
                let placeholder = ImageLoader_SDWebImage.placeholder
                self.btnClearFav.setBackgroundImage((image ?? placeholder), for: [])
            }
            
            self.btnClearFav.setTitleColor(.black, for: .normal)
            self.viewBackground.layer.cornerRadius = 5.0
            self.viewBackground.layer.borderWidth = 3.0
            
            if (self.themeData[0].englishButton != nil)
            {
                self.viewBackground.backgroundColor = self.colorWithHexString(hex: self.themeData[0].englishButton!)
                self.viewSubPopup.backgroundColor = self.colorWithHexString(hex: self.themeData[0].englishButton!)
            }
            else
            {
                self.viewBackground.backgroundColor = UIColor.lightGray
                self.viewSubPopup.backgroundColor = UIColor.lightGray
            }
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].categoryInactive) { (image, _) in
                let placeholder = ImageLoader_SDWebImage.placeholder
                self.btnClearcart.setBackgroundImage((image ?? placeholder), for: [])
                self.btnCancel.setBackgroundImage((image ?? placeholder), for: [])
                self.btnProcess.setBackgroundImage((image ?? placeholder), for: [])
            }
            
            let str = self.themeData[0].fontColorItemName
            
            if   (str == nil || str!.isEmpty)
            {
                self.btnProcess.titleLabel?.textColor = UIColor.black
                self.btnCancel.titleLabel?.textColor = UIColor.black
                self.btnClearcart.titleLabel?.textColor = UIColor.black
            }
            else
            {
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                self.btnProcess.setTitleColor(color1, for: .normal)
                self.btnClearcart.setTitleColor(color1, for: .normal)
                self.btnCancel.setTitleColor(color1, for: .normal)
                self.lblGrandTotalData.textColor  = color1
                self.lblGrandTotal.textColor  = color1
            }
            
            self.viewSubPopup.layer.cornerRadius = 5.0
            self.viewSubPopup.layer.borderColor = UIColor.lightGray.cgColor
            self.viewSubPopup.layer.borderWidth = 3.0
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].categoryActive) { (image, _) in
                let placeholder = ImageLoader_SDWebImage.placeholder
                self.btnCancel.setBackgroundImage((image ?? placeholder), for: [])
            }
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
    
    
    //Get Fav Data
    
    
    
    func GetItems1(){
        var total:Float = 0.0
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "qty > 0")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            self.listItems = items
            let sortedArray = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "catID", ascending: true)])
            self.listItems = sortedArray as! [ItemsCoreData]
            
            
            self.arrFav.removeAll()
            if self.listItems.count > 0
            {
                self.lblNoRecord.isHidden = true
                for dict in self.listItems
                {
                    
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
                
                self.conbtnClearHeight.constant = 50
                self.conviewTotalHeight.constant = 50
                for i in 0..<self.arrFav.count
                {
                    let dic =  NSMutableDictionary(dictionary: self.arrFav[i] as Dictionary)
                    let data  = dic["data"] as? [[String:AnyObject]]
                    for j in 0..<data!.count
                    {
                        let dic1 =  NSMutableDictionary(dictionary: data![j] as Dictionary)
                        let price = Float(dic1["price"] as! String)!
                        let qty = (dic1["qty"] as? Int)!
                        if total == Float(0.0)
                        {
                            total = (price * Float(qty))
                        }
                        else
                        {
                            total  = total + (price * Float(qty))
                        }
                        
                    }
                    self.lblGrandTotalData.text = String(format: "Total :  %.3f", total)
                    
                }
                
                
                
                self.tblFav.isHidden = false
                self.tblFav.reloadData()
            }
            else
            {
                self.lblNoRecord.isHidden = false
                self.conbtnClearHeight.constant = 0
                self.tblFav.isHidden = true
                self.conviewTotalHeight.constant = 0
                
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
            self.conviewTotalHeight.constant = 0
            
            self.arrFav.removeAll()
            if self.listItems.count > 0
            {
                self.lblNoRecord.isHidden = true
                for dict in self.listItems
                {
                    
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
                
                
                self.conbtnClearHeight.constant = 50
                self.tblFav.isHidden = false
                self.tblFav.reloadData()
            }
            else
            {
                self.lblNoRecord.isHidden = false
                self.conbtnClearHeight.constant = 0
                self.conviewTotalHeight.constant = 0
                self.tblFav.isHidden = true
            }
            
        }
    }
    
    func GetItems(){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isFav = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            self.listItems = items
            let sortedArray = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "catID", ascending: true)])
            self.listItems = sortedArray as! [ItemsCoreData]
            self.arrFav.removeAll()
            if self.listItems.count > 0
            {
                self.lblNoRecord.isHidden = true
                for dict in self.listItems
                {
                    
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
                self.conbtnClearHeight.constant = 50
                self.conviewTotalHeight.constant = 0
                self.tblFav.isHidden = false
                self.tblFav.reloadData()
            }
            else
            {
                self.lblNoRecord.isHidden = false
                self.conbtnClearHeight.constant = 0
                self.tblFav.isHidden = true
                self.conviewTotalHeight.constant = 0
            }
        }
    }
    
    func RemoveFromFav()
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isFav = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                dict.isFav = 0
            }
            self.tblFav.isHidden = true
            self.lblNoRecord.isHidden = false
            self.conbtnClearHeight.constant = 0
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
            self.conbtnClearHeight.constant = 0
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
    
    
}
