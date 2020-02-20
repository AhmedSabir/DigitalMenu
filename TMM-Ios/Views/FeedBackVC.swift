//
//  FeedBackVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/23/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData

class FeedBackVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PassAttributeData,PasstextData
{
    func textChange(strText: String, setTag: Int) {
        var dict = arrFeedBack?[setTag] as? [String:AnyObject]
        dict? ["ans"] = strText as AnyObject
        arrFeedBack?[setTag] = dict!

    }
    
    func starSelected(strAttr: String,setTag:Int)
    {
        var dict = arrFeedBack?[setTag] as? [String:AnyObject]
        dict? ["ans"] = strAttr as AnyObject
        arrFeedBack?[setTag] = dict!
    }
    
    
    //Outlets
    @IBOutlet weak var viewFeedBack: UIView!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var tblFeedBack: UITableView!
    @IBOutlet weak var btnCl: UIButton!
    @IBOutlet weak var btnSub: UIButton!

    var  strRate:String!
    var arrFeedBack :NSMutableArray!
    var arrStarFeedBack :NSMutableArray!
    var arrRadioFeedBack :NSMutableArray!
    var arrEmojiFeedback :NSMutableArray!
    var arrTextFeedBack :NSMutableArray!
    var arrReplace:NSMutableArray = []
    var themeData = [Themes]()
    var  strEmoji:String!
    var  strRadioSelect:String!
    var que:String!
    var resType:String!
    var res:String!
    var strIsCome:String!
    
    struct ItemDetails {
        static var CategoryID = Int32();
        static var FavID = Int32();
        static var itemPosition = IndexPath() ;
        static var staticThemeData = [Themes]()
        static var itemId = Int32();
        static var strPassitemId = Int32();
        
    }
    
    //VIEWCONTACT DETAILS
    @IBOutlet weak var viewContactDetail: UIView!
    @IBOutlet weak var lblContactDetails: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var contblFeedbackHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        ImageLoader_SDWebImage.getImage(themeData[0].popupBackground) { (image, _) in
            if let img = image {
                self.tblFeedBack.backgroundColor = UIColor(patternImage: img)
            } else {
                self.tblFeedBack.backgroundColor = .white
            }
        }
        self.viewContactDetail.layer.cornerRadius = 5.0
        self.viewContactDetail.layer.borderColor = UIColor.black.cgColor
        self.viewContactDetail.layer.borderWidth = 1.5

        self.btnSub.layer.cornerRadius = 5
        self.btnSub.layer.borderColor = UIColor.black.cgColor
        
        strRate = "0"
        strEmoji = "0"
        strRadioSelect = "0"

        arrRadioFeedBack = [["name":"","isSelect":"0"]]
        arrStarFeedBack = [["count":"0"]]
        arrTextFeedBack = [["msg":""]]
         arrEmojiFeedback = [["emojiCount":"0"]]
         self.tblFeedBack.layer.cornerRadius = 5
        self.tblFeedBack.layer.borderColor = UIColor.black.cgColor
        self.tblFeedBack.layer.borderWidth = 1.5
        var strQue:Int!
        let arr = NSMutableArray(array: UserDefaults.standard.value(forKey: "feedbackArry") as! Array)
        let sortedArray = (arr as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sequence", ascending: true)])
        self.arrFeedBack = NSMutableArray(array:sortedArray)
        for i in 0..<self.arrFeedBack.count
        {
            let dict = NSMutableDictionary(dictionary: (self.arrFeedBack[i] as? Dictionary)!)
            strQue = dict["TypeId"] as? Int
            
            if strQue == 1
            
            {
                dict["radio"] = arrStarFeedBack
            }
            else if strQue == 2
                
            {
                dict["radio"] = arrEmojiFeedback
            }
            else if strQue == 3
                
            {
                dict["radio"] = arrTextFeedBack
            }
            else if strQue == 4
            {
                dict["radio"] = arrRadioFeedBack
            }
            else
            {
                dict["radio"] = ""
            }
            
            dict["ans"] = ""
            
            arrFeedBack[i] = dict
        }
        print(arrFeedBack)
//        arrFeedBack =
//            [["radio":arrRadioFeedBack,"type":"2","que":"Hotel service is good or bad?","isComp":"1"],["radio":arrStarFeedBack,"type":"0","que":"How was the food quality? Give Rattings","isComp":"0"],["radio":arrTextFeedBack,"type":"1","que":"Please mention your Comment","isComp":"1"],["radio":arrEmojiFeedback,"type":"3","que":"How was the food?","isComp":"0"]]

        for i in 0..<arrRadioFeedBack.count
        {
            print(i)
            arrReplace.add("0")
        }
        self.viewFeedBack.layer.borderColor = UIColor.darkGray.cgColor
        self.viewFeedBack.layer.borderWidth = 1.0
        self.viewFeedBack.layer.cornerRadius = 5
        txtName.setLeftPaddingPoints(10)
        txtEmail.setLeftPaddingPoints(10)
        txtContactNo.setLeftPaddingPoints(10)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.contblFeedbackHeight.constant = self.view.frame.size.height - 500
    }
    //MARK: -Tableview Method
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrFeedBack.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict = NSMutableDictionary(dictionary: arrFeedBack[section] as! Dictionary)
        let arr =  dict["radio"] as? NSMutableArray
        return arr!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = NSMutableDictionary(dictionary:arrFeedBack[indexPath.section] as! Dictionary)
        let subarry = dict["radio"] as? NSMutableArray
    
        let subdict = NSMutableDictionary(dictionary: subarry![indexPath.row] as! Dictionary)
        if dict["TypeId"] as? Int == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath)as! StarCell
                cell.lblQue.text  = dict["Question"] as? String
            let black = UIColor.white // 1.0 alpha
            cell.setIndex = indexPath.section
            cell.delegate =  self
            cell.contentView.backgroundColor = UIColor.withAlphaComponent(black)(0.6)
            return cell
        }
        else if (dict["TypeId"] as? Int == 4)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)as! TextCell
                cell.lblQue.text  = dict["Question"] as? String
            //cell.lblQue.font = (UIFont(name: "Calibri" , size: 28))
            cell.txtMessage.layer.borderColor = UIColor.darkGray.cgColor
            cell.txtMessage.layer.borderWidth = 0.7
            cell.txtMessage.clipsToBounds = true
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 5.0
            cell.setInd = indexPath.section
            cell.delegete = self
//            let txtMessage:UITextView = cell.viewWithTag(120) as! UITextView
            let black = UIColor.white // 1.0 alpha
            cell.contentView.backgroundColor = UIColor.withAlphaComponent(black)(0.6)
           // contblFeedbackHeight.constant = CGFloat((self.arrFeedBack.count * 120) )
            return cell
            
        }
        else if (dict["TypeId"] as? Int == 2)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath)as! EmojiCell
            cell.lblQue.text  = dict["Question"] as? String
            //            cell.lblQue.font = (UIFont(name: "Calibri" , size: 28))
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 5.0
            let black = UIColor.white // 1.0 alpha
            cell.contentView.backgroundColor = UIColor.withAlphaComponent(black)(0.6)
            let btn1:UIButton = cell.viewWithTag(12) as! UIButton
            let btn2:UIButton = cell.viewWithTag(13) as! UIButton
            let btn3:UIButton = cell.viewWithTag(14) as! UIButton
            let btn4:UIButton = cell.viewWithTag(15) as! UIButton
            let btn5:UIButton = cell.viewWithTag(16) as! UIButton
            
            btn1.addTarget(self, action: #selector(btn1Click(_:)), for: .touchUpInside)
            btn2.addTarget(self, action: #selector(btn2Click(_:)), for: .touchUpInside)
            btn3.addTarget(self, action: #selector(btn3Click(_:)), for: .touchUpInside)
            btn4.addTarget(self, action: #selector(btn4Click(_:)), for: .touchUpInside)
            btn5.addTarget(self, action: #selector(btn5Click(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
         //   contblFeedbackHeight.constant = CGFloat((self.arrFeedBack.count * 120) )
            return cell
          

        }

        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath)as! RadioCell
            cell.lblQue.text  = dict["Question"] as? String
            cell.lblName.text = "Yes"
            cell.lblNo.text = "NO"
            cell.btnYes = cell.viewWithTag(112) as? UIButton
            cell.btnNo = cell.viewWithTag(113) as? UIButton
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 5.0
            let black = UIColor.white // 1.0 alpha
            cell.contentView.backgroundColor = UIColor.withAlphaComponent(black)(0.6)
            
            cell.btnYes.addTarget(self, action: #selector(btnYesClick(_:)), for: .touchUpInside)
            cell.btnNo.addTarget(self, action: #selector(btnNOClick(_:)), for: .touchUpInside)
           // contblFeedbackHeight.constant = CGFloat((self.arrFeedBack.count * 120))

            return cell
        }
        
    }
    @objc func btn1Click(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as? EmojiCell
                    cell?.btn1.isSelected = true
                    cell?.btn2.isSelected = false
                    cell?.btn3.isSelected = false
                    cell?.btn4.isSelected = false
                    cell?.btn5.isSelected = false
                    //strEmoji = "1"
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "1" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!

        }

        
    }
    @objc func btn2Click(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! EmojiCell
                    cell.btn2.isSelected = true
                    cell.btn1.isSelected = false
                    cell.btn3.isSelected = false
                    cell.btn4.isSelected = false
                    cell.btn5.isSelected = false
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "2" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!

        }
    }
    @objc func btn3Click(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! EmojiCell
            cell.btn3.isSelected = true
            cell.btn2.isSelected = false
            cell.btn1.isSelected = false
            cell.btn4.isSelected = false
            cell.btn5.isSelected = false
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "3" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!


        }

        
    }
    @objc func btn4Click(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! EmojiCell
            cell.btn4.isSelected = true
            cell.btn2.isSelected = false
            cell.btn3.isSelected = false
            cell.btn1.isSelected = false
            cell.btn5.isSelected = false
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "4" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!


        }

    }
    @objc func btn5Click(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! EmojiCell
            cell.btn5.isSelected = true
            cell.btn2.isSelected = false
            cell.btn3.isSelected = false
            cell.btn4.isSelected = false
            cell.btn1.isSelected = false
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "5" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!


        }

    }


    @objc func btnYesClick(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! RadioCell
            cell.btnYes.isSelected = true
            cell.btnNo.isSelected = false
            cell.imgRadio.image = UIImage(named: "radio_select")
            cell.imgNo.image = UIImage(named: "radio_unselect")
//            strRadioSelect = "1"
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "yes" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!


        }
//        let cell = tblFeedBack.cellForRow(at:IndexPath(row: btn.tag, section: 0)) as! RadioCell
    }
    @objc func btnNOClick(_ sender: Any)
    {
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! RadioCell
        cell.btnNo.isSelected = true
        cell.btnYes.isSelected = false
        cell.imgNo.image = UIImage(named: "radio_select")
        cell.imgRadio.image = UIImage(named: "radio_unselect")
//        strRadioSelect = "2"
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = "no" as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!

    }
    }
    
    @objc func TextViewUpdate(_ sender : Any)
    {
//        let txt = sender
//        let cell = tblFeedBack.cellForRow(at: IndexPath(row: txt.tag, section: 0)) as! TextCell
        let ButtonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tblFeedBack)
        let indexPath = tblFeedBack.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            print("Cell indexPath: \(String(describing: indexPath?.row))")
            let cell = tblFeedBack.cellForRow(at: (indexPath)!) as! TextCell
            var dict = arrFeedBack?[(indexPath?.section)!] as? [String:AnyObject]
            dict? ["ans"] = cell.txtMessage.text! as AnyObject
            arrFeedBack?[(indexPath?.section)!] = dict!
        }
    }
    
   
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view  = UIView()
       // var Backgroundview  = UIView()
        view = UIView(frame: CGRect(x: 10, y: 0, width: self.tblFeedBack.frame.size.width, height: 80))
        view.backgroundColor = UIColor.clear

        let lblQue = UILabel(frame: CGRect(x: 45, y: 0, width:view.frame.size.width - 60, height: 40))
        let dict = NSMutableDictionary(dictionary:self.arrFeedBack[section] as! Dictionary)
            lblQue.text = dict ["Question"] as? String
        lblQue.numberOfLines = 0
        view.addSubview(lblQue)
//        Backgroundview.addSubview(view)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        let dict = NSMutableDictionary(dictionary: arrFeedBack[section] as! Dictionary)
        let str = dict["Question"] as? String
        if dict["type"] as? String == "1"
        {
            
            return 0
            
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = NSMutableDictionary(dictionary: arrFeedBack[indexPath.section] as! Dictionary)
        if dict["Type"] as? String == "radio"
        {
            let arr = dict ["radio"] as? NSMutableArray
            let dic1 = NSMutableDictionary(dictionary: arr![indexPath.row] as! Dictionary)
            let temp = NSMutableDictionary(dictionary: arr![indexPath.row] as! Dictionary)
            
            if arrReplace[indexPath.row] as? String  == "0"
            {
                if arrReplace.contains("1")
                {
                    arrReplace.remove("1")
                    arrReplace.add("0")
                }
                arrReplace.replaceObject(at: indexPath.row , with: "1")
            }
            else
            {
                arrReplace.replaceObject(at: indexPath.row, with: "0")
                
            }
        }
        self.tblFeedBack.reloadData()
        
    }
    func wagaDuggu (fileName: String) -> UIImage{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath) {
            let image = UIImage(contentsOfFile: filePath)!
            return UIImage(contentsOfFile: filePath)!
            
        }else{
            return UIImage(named: "NoImage")!
        }
    }

    func downloadThemes(ThemeID: Int32){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ItemDetails.staticThemeData = items;
            let imageView : UIImageView!
            imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode =  UIViewContentMode.scaleToFill
            imageView.clipsToBounds = true
            
            ImageLoader_SDWebImage.getImage(self.themeData[0].background) { (image, _) in
                if let img = image {
                    self.view.backgroundColor = UIColor(patternImage: img)
                } else {
                    self.view.backgroundColor = .white
                }
            }
        }
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if (txtName.text?.isEmpty)! || txtName.text == "" || txtName.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter name")
                self.txtName.becomeFirstResponder()
            })

        }
        else if (txtName.text?.count)! < 3
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter valid name")
                self.txtName.becomeFirstResponder()
            })
            
        }
        
        else if (txtEmail.text?.isEmpty)! || txtEmail.text == "" || txtEmail.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter email id")
                self.txtEmail.becomeFirstResponder()
            })
            
        }
        else if !isValidEmail(testStr: txtEmail.text!)
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter valid email id")
                self.txtEmail.becomeFirstResponder()
            })

        }
        else if (txtContactNo.text?.isEmpty)! || txtContactNo.text == "" || txtContactNo.text?.count == 0
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter contact no")
                self.txtContactNo.becomeFirstResponder()
            })
            
        }
        else if (txtContactNo.text?.count)! < 7
        {
            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Please enter valid contact no")
                self.txtContactNo.becomeFirstResponder()
            })

        }
        else
        {
            let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
            var strQQ:Int!
            for i in 0..<self.arrFeedBack.count
            {
                let dict = NSMutableDictionary(dictionary: (self.arrFeedBack[i] as? Dictionary)!)
                strQQ = dict["TypeId"] as? Int

                if strQQ == 1
                {
//                   let cell = tblFeedBack.cellForRow(at: IndexPath(row: i, section: 0)) as! StarCell
                    res = dict["ans"] as? String
                    que = dict["Question"]  as? String
                    resType =  String(format: "%d", (dict["TypeId"] as? Int)!)

                }
                else if strQQ == 2

                {
//                    let cell = tblFeedBack.cellForRow(at: IndexPath(row: i, section: 0)) as! EmojiCell
                    res  = dict["ans"] as? String
                    que = dict["Question"]  as? String
                    resType =  String(format: "%d", (dict["TypeId"] as? Int)!)
                }
                else if strQQ == 3

                {
//                    let cell = tblFeedBack.cellForRow(at: IndexPath(row: i, section: 0)) as! TextCell
                    res  = dict["ans"] as? String
                    que = dict["Question"]  as? String
                    resType =  String(format: "%d", (dict["TypeId"] as? Int)!)

                }
                else
                {
//                    let cell = tblFeedBack.cellForRow(at: IndexPath(row: i, section: 0)) as! RadioCell
                    res = dict["ans"] as? String
                    que = dict["Question"]  as? String
                    resType =  String(format: "%d", (dict["TypeId"] as? Int)!)
                    
                }
                
                var  heroeDict  = Dictionary<String, Any>()
                
//                Customer_name]
//                ,[Customer_email]
//                ,[Customer_mobile]
//                ,[Question]
//                ,[Response_Type]
//                ,[Response]
//                ,[Datetime]
//                ,[Branch_Name]
//                ,[UDID]
                heroeDict ["Customer_name"] = self.txtName.text! as AnyObject
                heroeDict ["Customer_email"] = self.txtEmail.text! as AnyObject
                heroeDict ["Customer_mobile"] = self.txtContactNo.text! as AnyObject
                heroeDict ["UDID"] = UUIDValue
                heroeDict ["Question"] = self.que
                heroeDict ["Response_Type"] = self.resType
                heroeDict ["Branch_Name"] = UserDefaults.standard.value(forKey:"branchName")as? String
                heroeDict ["Response"] = self.res
                let DateFormat = DateFormatter()
                DateFormat.dateFormat = "dd/MM/yyyy hh:mm:ss"
               heroeDict ["Datetime"] = DateFormat.string(from: Date()) // October 8, 2016 at 10:48:53 PM

                print(heroeDict)
                
                //adding the name to the list
                
                SkopelosClient.shared.writeSync { context in
                    let CategoryData = FeedbackData.SK_create(context)
                    CategoryData.branchName =  heroeDict ["Branch_Name"] as? String
                    CategoryData.name =    heroeDict ["Customer_name"] as? String
                    CategoryData.email =  heroeDict ["Customer_email"] as? String
                    CategoryData.mobie = heroeDict ["Customer_mobile"] as? String
                    CategoryData.que = heroeDict ["Question"] as? String
                    CategoryData.response = heroeDict ["Response"] as? String
                    CategoryData.resType = heroeDict ["Response_Type"] as? String
                    CategoryData.udid = heroeDict ["UDID"] as? String
                    CategoryData.datetime = heroeDict ["Datetime"] as? String
                    print(CategoryData, "Is saved")
                }
            }

            OperationQueue.main.addOperation({
                ToastView.shared.long(self.view, txt_msg: "Thanks for your feedback.")
//                self.dismiss(animated: true)
                if self.strIsCome == "layoutA"
                {
                    let objVC: ItemViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController
                    objVC?.strCome = "feedback"
                    let aObjNavi = UINavigationController(rootViewController: objVC!)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = aObjNavi
                    aObjNavi.isNavigationBarHidden = true
                    
                }
                else  if self.strIsCome == "layoutB"
                {
                    let objVC: ItemViewLayoutBVC? = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutBVC") as? ItemViewLayoutBVC
                    objVC?.strCome = "feedback"
                    let aObjNavi = UINavigationController(rootViewController: objVC!)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = aObjNavi
                    aObjNavi.isNavigationBarHidden = true
                    
                }
                else if self.strIsCome == "layoutC"
                {
                    let objVC: ItemViewLayoutCVC? = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutCVC") as? ItemViewLayoutCVC
                    objVC?.strCome = "feedback"
                    let aObjNavi = UINavigationController(rootViewController: objVC!)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = aObjNavi
                    aObjNavi.isNavigationBarHidden = true
                    
                }
                else
                {
                    let objVC: ItemViewControllerLayoutDVC? = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewControllerLayoutDVC") as? ItemViewControllerLayoutDVC
                    objVC?.strCome = "feedback"
                    let aObjNavi = UINavigationController(rootViewController: objVC!)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = aObjNavi
                    aObjNavi.isNavigationBarHidden = true
                    
                }

            })

        }
        

    }

    @IBAction func btnCloseClick(_ sender: UIButton)
    {
        //dismiss(animated: true)
        if strIsCome == "layoutA"
        {
            let objVC: ItemViewController? = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController
            objVC?.strCome = "feedback"
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
       else  if strIsCome == "layoutB"
        {
            let objVC: ItemViewLayoutBVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutBVC") as? ItemViewLayoutBVC
            objVC?.strCome = "feedback"
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else if strIsCome == "layoutC"
        {
            let objVC: ItemViewLayoutCVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutCVC") as? ItemViewLayoutCVC
            objVC?.strCome = "feedback"
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else if strIsCome == "Classiclayout"
        {
            let objVC: ClassicLayoutVC? = storyboard?.instantiateViewController(withIdentifier: "ClassicLayoutVC") as? ClassicLayoutVC
            objVC?.strCome = "feedback"
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }

        else
        {
                let objVC: ItemViewControllerLayoutDVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewControllerLayoutDVC") as? ItemViewControllerLayoutDVC
                objVC?.strCome = "feedback"
                let aObjNavi = UINavigationController(rootViewController: objVC!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = aObjNavi
                aObjNavi.isNavigationBarHidden = true
                
        }

    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func validatePhone(_ phoneNumber: String) -> Bool {
        let phoneRegex = "[0-9]"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: phoneNumber) {
            return false
        }
        else {
            return true
        }
    }

    //MARK: -TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtContactNo
        {
            if string.isEmpty
            {
                return true
            }
            if validatePhone(string)
            {
                var strMaxLength = ""
                strMaxLength = "15"
                let newStr = textField.text as NSString?
                let currentString: String = newStr!.replacingCharacters(in: range, with: string)
                let j = Int(strMaxLength) ?? 0
                let length: Int = currentString.count
                if length >= j {
                    return false
                }
                else {
                    return true
                }
            }
            return false
        }
        
       
        return true
    }

    

}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
