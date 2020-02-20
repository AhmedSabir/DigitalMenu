//
//  ItemViewLayoutCVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/2/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ItemViewLayoutCVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource
{
    var duration = 0.5
    var isPresenting = false
    
    var snapshot:UIView?
    
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var btnBrand: UIButton!

    // @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var viewFeedBack: UIView!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblFeedback: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnBrandLogo: UIButton!

    @IBOutlet weak var viewInsta: UIView!
    @IBOutlet weak var viewFb: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblfb: UILabel!
    @IBOutlet weak var lblInsta: UILabel!
    @IBOutlet weak var btnHideUnhideItem: UIButton!
    
    
    
     @IBOutlet var btnHome: UIButton!
    @IBOutlet var viewFav: UIView!

    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!
    var listItems1 = [ItemsCoreData]()
    let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as? String

    var id :Int32 = 0
    var index:Int!
    var strCome:String!
    var strCome1:String!
    var  strRate:String!
    var arrReplace:NSMutableArray = []
    var selectedIndex:Int = 0
    var arrFav = [[String:AnyObject]]()
    var arrCheck = [ItemsCoreData]()
    
    @IBAction func btnLogoClick(_ sender: UIButton)
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        if self.strCome != "slide"
        {
            navigationController?.popViewController(animated: true)
        }
        else
        {
        let objVC: SlideShowVC? = storyboard?.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
        objVC?.strIsCome = "layoutC"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }

    }
    
    @IBAction func btnFbClick(_ sender: UIButton)
    {
        Common.openFacebookURL(for: strfb)
    }
    @IBAction func btnInstaClick(_ sender: UIButton)
    {
        Common.openInstagramURL(for: strinsta)
    }
    @IBAction func btnCallClick(_ sender: UIButton)
    {
        Common.openCallURL(for: strcall)
    }

    @IBAction func btnHomeClick(_ sender: UIButton)
    {
        let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
        objVC?.Selectedindex = 2
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

    }
    @IBAction func btnChangeLanguage(_ sender: UIButton)
    {
        print("Language Changed Button clicked");
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        if (CurrentLanguage=="eng")
        {
            //            language.setBackgroundImage(self.GetImageFromStorage(fileName: themeData[0].englishButton!), for: [])
            Language.language="ara"
            language.setTitle("ENG", for: .normal)
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
        }else if (CurrentLanguage=="ara")
        {
            language.setTitle("عربى", for: .normal)
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            Language.language="eng"
            //            language.backgroundColor = UIColor(red: 226.0/255, green: 0/255, blue: 1/255, alpha: 1.0)
            
        }
        
        
        self.GetCategory()
        
    }
    
    struct Language {
        static var language = "eng";
    }
    struct ItemDetails {
        static var CategoryID = Int32();
        static var FavID = Int32();
        static var itemPosition = IndexPath() ;
        static var staticThemeData = [Themes]()
        static var itemId = Int32()
        static var  strCome = String()
        static var strPassitemId = Int32();

    }
    //A string array to save all the names
    
    
    
    var listItems = [ItemsCoreData]()
    var listCategories = [CategoryCoreData]()
    var Categories = [CategoryViewData]()
    var themeData = [Themes]()
    var arrFeedBack :NSMutableArray!
    var arrStarFeedBack :NSMutableArray!
    var arrRadioFeedBack :NSMutableArray!
    var arrTextFeedBack :NSMutableArray!
    @IBOutlet weak var ItemsView: UICollectionView!
    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
    }
    
    //MARK: -Action
    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        let objVC: FeedBackVC? = storyboard?.instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
        objVC?.strIsCome = "layoutC"
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

       // self.performSegue(withIdentifier: "FeedbackSegue", sender: nil)
    }

    
    @IBAction func btnCloseClick(_ sender: UIButton)
    {
        viewFeedBack.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.GetCategory()
        self.GethideItems()
        self.CategoriesView.selectItem(at: IndexPath(row:selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            self.btnfav.setImage(UIImage(named:"cart"), for: .normal)
            self.btnfav.setImage(UIImage(named:"cart"), for: .selected)
            
        }
        else
        {
            
            if btnfav.isSelected == true
            {
                btnfav.isSelected = false
                btnHideUnhideItem.isSelected = false
                
                self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
            }
            else if btnHideUnhideItem.isSelected == true
            {
                btnfav.isSelected = false
                btnHideUnhideItem.isSelected = false
            }
        }
    }
    

    @IBAction func btnfavClick(_ sender: UIButton)
    {
        self.btnfav.isSelected = true
        
        
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FavVC") as! FavVC
        popOverVC.strIsCome = "layoutC"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)

        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.GetCategory()
        
        if strCome1 == "fav" || strCome == "slide"
        {
            //            UserDefaults.standard.set(selectedIndex, forKey: "id")
            //            UserDefaults.standard.synchronize() 
            self.CategoriesView.scrollToItem(at:IndexPath(row:selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
            
        }
        else
        {
            //print(UserDefaults.standard.value(forKey: "id")!)
            UserDefaults.standard.set(1, forKey: "id")
            UserDefaults.standard.synchronize()
            
        }
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo();
        language.setTitleColor(colorWithHexString(hex:themeData[0].fontColorItemName!), for: .normal)
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryActive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        if (CurrentLanguage=="eng")
        {
            language.setTitle("عربى", for: .normal)
        }
        else if (CurrentLanguage=="ara")
        {
            language.setTitle("ENG", for: .normal)
        }
        if BrandViewController.Brandhelper.feedBack == 0
        {
            self.btnFeedBack.isHidden = true
        }
        else
        {
            self.btnFeedBack.isHidden = false
            
        }

        //Feedback
        
        
        //        arrRadioFeedBack = [["name":"Yes","isSelect":"0"],["name":"No","isSelect":"0"]]
        arrRadioFeedBack = [["name":"","isSelect":"0"]]
        arrStarFeedBack = [["count":"0"]]
        arrTextFeedBack = [["msg":""]]
        arrFeedBack =
            [["radio":arrRadioFeedBack,"type":"2","que":"Hotel service is good or bad?","isComp":"1"],["radio":arrStarFeedBack,"type":"0","que":"How was the food quality? Give Rattings","isComp":"0"],["radio":arrTextFeedBack,"type":"1","que":"Please mention your Comment","isComp":"1"]]
        for i in 0..<arrRadioFeedBack.count
        {
            print(i)
            arrReplace.add("0")
        }
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            self.btnfav.setImage(UIImage(named:"cart"), for: .normal)
            self.btnfav.setImage(UIImage(named:"cart"), for: .selected)
            
        }
        else
        {
            self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
            
        }
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))  //Tap function will call when user tap on button
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))  //Long function will call when user long press on button.
        language.addGestureRecognizer(longGesture)
        if (themeData[0].englishButton != nil)
        {
            
            btnHome.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            self.viewFav.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            
        }
        else
        {
            btnHome.backgroundColor = UIColor.lightGray
            self.viewFav.backgroundColor = UIColor.lightGray
        }

    }
    
    //MARK: -Long Press
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            btnHideUnhideItem.isHidden = false
            UserDefaults.standard.removeObject(forKey: "isDatasaved")
            UserDefaults.standard.synchronize()
            self.ItemsView.reloadData()
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began
        {
            print("UIGestureRecognizerStateBegan.")
            //            btnHideUnhideItem.isHidden = false
            //Do Whatever You want on Began of Gesture
        }
    }
    
    @IBAction func btnHideUnhideItemClick(_ sender: UIButton)
    {
        //        if btnHideUnhideItem.isSelected
        //        {
        //            btnHideUnhideItem.isSelected = false
        //
        //        }
        //        else
        //        {
        btnHideUnhideItem.isHidden = false
        btnHideUnhideItem.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "HideItemVC") as! HideItemVC
        popOverVC.strIsCome = "check"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
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
        let isComp = dict["isComp"] as? String
        if dict["type"] as? String == "0"
            
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath)as! StarCell
            if isComp == "1"
            {
                //  Converted to Swift 4 by Swiftify v4.2.7000 - https://objectivec2swift.com/
                var myString: NSMutableAttributedString?
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "1.png")
                
                let attachmentString = NSAttributedString(attachment: attachment)
                myString = NSMutableAttributedString(string: (dict["que"] as? String)!)
                myString?.append(attachmentString)
                cell.lblQue.attributedText = myString
                
            }
            else
            {
                cell.lblQue.text  = dict["que"] as? String
                
            }
            
            let fontText: UIFont = (UIFont(name: "Calibri" , size: 28))!
            cell.lblQue.font = fontText
            return cell
        }
        else if (dict["type"] as? String == "1")
        {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)as! TextCell
            if isComp == "1"
            {
                //  Converted to Swift 4 by Swiftify v4.2.7000 - https://objectivec2swift.com/
                var myString: NSMutableAttributedString?
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "1.png")
                
                let attachmentString = NSAttributedString(attachment: attachment)
                myString = NSMutableAttributedString(string: (dict["que"] as? String)!)
                myString?.append(attachmentString)
                cell.lblQue.attributedText = myString
                
            }
            else
            {
                cell.lblQue.text  = dict["que"] as? String
                
            }
            cell.lblQue.font = (UIFont(name: "Calibri" , size: 28))
            cell.txtMessage.text = ""
            cell.txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtMessage.layer.borderWidth = 0.7
            cell.txtMessage.clipsToBounds = true
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath)as! RadioCell
            //            cell.lblName.text = subdict["name"] as? String
            let isComp = dict["isComp"] as? String
            
            if isComp == "1"
            {
                var myString: NSMutableAttributedString?
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "1.png")
                
                let attachmentString = NSAttributedString(attachment: attachment)
                myString = NSMutableAttributedString(string: (dict["que"] as? String)!)
                myString?.append(attachmentString)
                cell.lblQue.attributedText = myString
                
            }
            else
            {
                cell.lblQue.text  = dict["que"] as? String
                
                
            }
            cell.lblQue.font = (UIFont(name: "Calibri" , size: 28))
            cell.lblName.text = "Yes"
            cell.lblNo.text = "NO"
            
            //            if arrReplace[indexPath.row] as? String == "0"
            //            {
            //                cell.imgRadio.image = UIImage(named: "radio_unselect")!
            //
            //            }
            //            else
            //            {
            //                cell.imgRadio.image = UIImage(named: "radio_select")!
            //
            //            }
            cell.btnYes.tag = 0
            cell.btnNo.tag = 0
            cell.btnYes.addTarget(self, action: #selector(btnYesClick(_:)), for: .touchUpInside)
            cell.btnNo.addTarget(self, action: #selector(btnNOClick(_:)), for: .touchUpInside)
            
            return cell
            
        }
        
    }
    @objc func btnYesClick(_ sender: Any)
    {
        let btn = UIButton ()
        let cell = tblFeedback.cellForRow(at:IndexPath(row: btn.tag, section: 0)) as! RadioCell
        cell.btnYes.isSelected = true
        cell.btnNo.isSelected = false
        cell.imgRadio.image = UIImage(named: "radio_select")
        cell.imgNo.image = UIImage(named: "radio_unselect")
        
    }
    @objc func btnNOClick(_ sender: Any)
    {
        let btn = UIButton ()
        let cell = tblFeedback.cellForRow(at:IndexPath(row: btn.tag, section: 0)) as! RadioCell
        cell.btnNo.isSelected = true
        cell.btnYes.isSelected = false
        cell.imgNo.image = UIImage(named: "radio_select")
        cell.imgRadio.image = UIImage(named: "radio_unselect")
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view  = UIView()
        view = UIView(frame: CGRect(x: 0, y: 0, width: self.tblFeedback.frame.size.width, height: 80))
        view.backgroundColor = UIColor.clear
        let lblQue = UILabel(frame: CGRect(x: 45, y: 0, width:view.frame.size.width - 40, height: 40))
        let dict = NSMutableDictionary(dictionary:self.arrFeedBack[section] as! Dictionary)
        let isComp = dict["isComp"] as? String
        if isComp == "1"
        {
            //  Converted to Swift 4 by Swiftify v4.2.7000 - https://objectivec2swift.com/
            var myString: NSMutableAttributedString?
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "1.png")
            
            let attachmentString = NSAttributedString(attachment: attachment)
            myString = NSMutableAttributedString(string: (dict["que"] as? String)!)
            myString?.append(attachmentString)
            lblQue.attributedText = myString
            
        }
        else
        {
            lblQue.text = dict ["que"] as? String
            
        }
        
        //        lblQue.text = dict ["que"] as? String
        lblQue.font = (UIFont(name: "Calibri" , size: 28))
        lblQue.numberOfLines = 0
        view.addSubview(lblQue)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        let dict = NSMutableDictionary(dictionary: arrFeedBack[section] as! Dictionary)
        let str = dict["que"] as? String
        if dict["type"] as? String == "1"
        {
            //            if str != ""
            //            {
            //                let constraint = CGSize(width: self.tblFeedback.frame.size.width - 20, height: 50000.0)
            //
            //                let fontText: UIFont = (UIFont(name: "Calibri" , size: 28))!
            //                let size: CGRect = str!.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: fontText], context: nil)
            //                var height1: CGFloat
            //                if size.size.height < 30
            //                {
            //                    height1 = 30
            //                    return height1
            //                }
            //                else
            //                {
            //                    height1 = size.size.height + 70
            //                    return height1
            //
            //                }
            //            }
            //
            //            else
            //            {
            return 0
            //            }
            
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //        let dict = NSMutableDictionary(dictionary: arrFeedBack[indexPath.section] as! Dictionary)
        //        if dict["type"] as? String == "1"
        //        {
        //            return 90
        //        }
        //        else
        //        {
        //            let str = dict["que"] as? String
        //
        //            if str != ""
        //            {
        //                let constraint = CGSize(width: self.tblFeedback.frame.size.width - 40, height: 50000.0)
        //
        //                let fontText: UIFont = (UIFont(name: "Calibri" , size: 28))!
        //                let size: CGRect = str!.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: fontText], context: nil)
        //                var height1: CGFloat
        //                if size.size.height < 30
        //                {
        //                    height1 = 80
        //                    return height1
        //                }
        //                else
        //                {
        //                    height1 = size.size.height + 60
        //                    return height1
        //
        //                }
        //            }
        //
        //            else
        //            {
        return 120
        //            }
        
        
        
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = NSMutableDictionary(dictionary: arrFeedBack[indexPath.section] as! Dictionary)
        if dict["type"] as? String == "2"
        {
            let arr = dict ["radio"] as? NSMutableArray
            let dic1 = NSMutableDictionary(dictionary: arr![indexPath.row] as! Dictionary)
            let temp = NSMutableDictionary(dictionary: arr![indexPath.row] as! Dictionary)
            
            //            if (arrReplace[indexPath.row] == "0") {
            //                if arrReplace.contains("1") {
            //                    arrReplace.removeAll(where: { element in element == "1" })
            //                    arrReplace.append("0")
            //                }
            //                arrReplace[indexPath.row] = "1"
            //            } else {
            //                arrReplace[indexPath.row] = "0"
            //            }
            
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
        self.tblFeedback.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        if (CurrentLanguage=="eng")
        {
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
        }
        else
        {
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
        }
        language.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
//        self.btnfav.isSelected = false
//        self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
        
    }
    
    var listCategory = [ItemsCoreData]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.CategoriesView){
            return listCategories.count
        }else{
            return listItems.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.CategoriesView)
        {
            let cell = CategoriesView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! CategoryCollectionViewCell;
            let CategoryDetails: CategoryCoreData
            CategoryDetails = self.listCategories[indexPath.row]
            cell.CategoryName.text = CategoryName(CategoryList: CategoryDetails)
            let str4 = themeData[0].fontColor
            
            if  (str4 == nil || str4!.isEmpty)
            {
                cell.CategoryName.textColor = UIColor.black
                
            }
                
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColor!)
                cell.CategoryName.textColor  = color1
                
            }
            
            let contentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:cell.frame.size.width, height: cell.frame.size.height))
            contentImageView.backgroundColor = UIColor.clear
            ImageLoader_SDWebImage.setImage(themeData[0].categoryInactive, into: contentImageView)
            let view1 = UIView()
            view1.addSubview(contentImageView)
            cell.backgroundView = view1
            
            let contentImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width:cell.frame.size.width, height: cell.frame.size.height))
            contentImageView1.backgroundColor = UIColor.clear
            ImageLoader_SDWebImage.setImage(themeData[0].categoryActive, into: contentImageView1)
            let view2 = UIView()
            view2.backgroundColor = UIColor.clear
            view2.addSubview(contentImageView1)
            cell.selectedBackgroundView = view2
            
            let SelectedCategories = self.listCategories[(indexPath.row)]
            //            let catSeq = self.listCategories[indexPath.row].catSequence
            //            let catSeq:Int32? = Int32(SelectedCategories.catSequence)
            let catID : Int32? = Int32(SelectedCategories.catID)
            if UserDefaults.standard.value(forKey: "id")as? Int32 != nil
            {
                    if ((UserDefaults.standard.value(forKey: "id")as! Int32) == catID)
                {
                    //                    cell.isSelected = true
                    self.GetItems(CatID: catID!)
                    cell.isSelected = true
                    //                    self.CategoriesView.scrollToItem(at:IndexPath(row: indexPath.item, section: 0), at: .centeredHorizontally, animated: false)
                }
                else
                {
                    cell.isSelected = false
                    
                }
            }
            else
            {
                cell.isSelected = false
            }
            
            
            
            return cell
        }else{
            let cell = ItemsView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell;
            let ItemsDetail: ItemsCoreData
            cell.viewInner.layer.cornerRadius = 3.0
            cell.viewInner.layer.borderColor = UIColor.clear.cgColor
            cell.viewInner.clipsToBounds = true
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            ItemsDetail = self.listItems[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblPrice.text = String(format: "%@ %@",strcurrency, ItemsDetail.price!)
            cell.delegate = self
            let str1111 = themeData[0].itemBackgroundColor
            if (CurrentLanguage=="eng")
            {
                cell.lblOutofstock.text = "Out Of Stock!"
            }
            else
            {
                cell.lblOutofstock.text = "إنتهى من المخزن!"
            }

            if  (str1111 == nil || str1111!.isEmpty)
            {
                cell.viewInner.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                
            }
                
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].itemBackgroundColor!)
                let strGet = themeData[0].rightTop!
                if strGet.contains(".png")  || strGet.contains(".jpg")
                {
                    let getAlpha = Float(Float(70)/100.00)
                    cell.viewInner.backgroundColor  = color1.withAlphaComponent(CGFloat(getAlpha))
                    
                }
                else
                {
                    let getAlpha = Float(Float(themeData[0].rightTop!)!/100.00)
                    cell.viewInner.backgroundColor  = color1.withAlphaComponent(CGFloat(getAlpha))
                    
                }

                
            }

            let str = themeData[0].fontColorPrice
            
            
            if   (str == nil || str!.isEmpty)
            {
                cell.lblPrice.textColor = UIColor.black
                
                
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorPrice!)
                cell.lblPrice.textColor  = color1
                
            }
            let str1 = themeData[0].fontColorItemName
            
            if   (str1 == nil || str1!.isEmpty)
            {
                cell.lblItemName.textColor = UIColor.black
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
                cell.lblItemName.textColor  = color1
            }
            let str2 = themeData[0].fontColorIngName
            
            if  (str2 == nil || str2!.isEmpty)
            {
                cell.lblIngredient.textColor = UIColor.black
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorIngName!)
                cell.lblIngredient.textColor  = color1
            }
            
            if ItemsDetail.isFav == 0
            {
                cell.btnfav.isSelected = false
            }
                
            else
            {
                cell.btnfav.isSelected = true
                
            }
            if UserDefaults.standard.value(forKey: "isDatasaved")as? String == "yes"
            {
                if ItemsDetail.isCheck == 1
                {
                    cell.btnCheck.isHidden = true
                    cell.viewOutofStock.isHidden = false
                    cell.btnCheck.isSelected = true
                    btnHideUnhideItem.isHidden = true
                }
                else{
                    cell.btnCheck.isHidden = true
                    cell.viewOutofStock.isHidden = true
                    cell.btnCheck.isSelected = false
                    btnHideUnhideItem.isHidden = true
                }
                
            }
            else
            {
                
                if btnHideUnhideItem.isHidden  == false
                {
                    if ItemsDetail.isCheck == 0
                    {
                        cell.viewOutofStock.isHidden = true
                        cell.btnCheck.isSelected = false
                        cell.btnCheck.isHidden = false
                        
                    }
                        
                    else
                    {
                        
                        cell.viewOutofStock.isHidden = false
                        cell.btnCheck.isSelected = true
                        cell.btnCheck.isHidden = false
                        
                    }
                }
                else
                {
                    
                    //                    cell.btnCheck.isHidden = false
                    //                    cell.viewOutofStock.isHidden = false
                    //                    cell.btnCheck.isSelected = true
                    //                    btnHideUnhideItem.isHidden = false
                    if ItemsDetail.isCheck == 0
                    {
                        cell.viewOutofStock.isHidden = true
                        cell.btnCheck.isSelected = false
                        cell.btnCheck.isHidden = true
                        
                    }
                        
                    else
                    {
                        
                        cell.viewOutofStock.isHidden = false
                        cell.btnCheck.isSelected = true
                        cell.btnCheck.isHidden = true
                        
                    }
                }
            }
            
            

            
            if(CurrentLanguage == "ara")
            {
                cell.lblItemName.text = ItemsDetail.itemNameAr;
                cell.lblIngredient.text = ItemsDetail.ingredientAra;
            }else
            {
                cell.lblItemName.text=ItemsDetail.itemName;
                cell.lblIngredient.text=ItemsDetail.ingredientEng;
            }
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.ImgItem)
            cell.btnfav.tag = indexPath.row
            
            
            index = cell.btnfav.tag
            //            id = self.listItems[index].itemID
            cell.btnfav.addTarget(self, action: #selector(btnFvrtItemClick(_:)), for: .touchUpInside)
            //--------  jignya
            
            if ItemsDetail.qty > 0
            {
                cell.lblQuantity.text = String(format: "%d", ItemsDetail.qty)
            }
            else
            {
                cell.lblQuantity.text = "ADD"
            }
            
            
            
            if UserDefaults.standard.value(forKey:"strTackingOrder") as? String == "yes"
            {
                cell.btnfav.isHidden = true
                cell.viewQuantity.isHidden = false
            }
            else
            {
                cell.btnfav.isHidden = false
                cell.viewQuantity.isHidden = true
                
                
            }
            
            
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            cell.btnCheck.tag = indexPath.row
            cell.btnPlus.addTarget(self, action: #selector(btnplusClick(_:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(btnminusClick(_:)), for: .touchUpInside)
            cell.btnCheck.addTarget(self, action: #selector(btnCheckItemClick(_:)), for: .touchUpInside)
            
            //-----------------------
            return cell
        }
    }
    
    @objc func btnCheckItemClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        id =  self.listItems[btn.tag].itemID
        
        
        if btn.isSelected == false
        {
            btn.isSelected = true
            
            self.setChecktohide(checkId: 1)
            
        }
        else
        {
            btn.isSelected = false
            self.setChecktohide(checkId: 0)
            
        }
        
        
    }

    @objc func btnplusClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        id =  self.listItems[btn.tag].itemID
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:ItemDetails.CategoryID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.id
                {
                    var Qty : Int = Int(dict.qty)
                    Qty = Qty + 1
                    dict.qty = Int32(Qty)
                }
            }
            self.ItemsView.reloadData()
        }
    }
    
    @objc func btnminusClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        id =  self.listItems[btn.tag].itemID
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:ItemDetails.CategoryID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.id
                {
                    var Qty : Int = Int(dict.qty)
                    if Qty != 0
                    {
                        Qty = Qty - 1
                        dict.qty = Int32(Qty)
                    }
                }
            }
            self.ItemsView.reloadData()
        }
    }
    
    func setChecktohide(checkId:Int32) {
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:ItemDetails.CategoryID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.id
                {
                    if (dict.isCheck == Int32(0))
                    {
                        dict.isCheck = checkId
                        // var arr1 = [[String:AnyObject]]()
                        
                        
                    }
                    else
                    {
                        dict.isCheck = 0
                        
                    }
                }
                
            }
            self.ItemsView.reloadData()
            self.GethideItems()
        }
        
    }
    //MARK -GetHideData
    func GethideItems()
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "isCheck = 1")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            self.listItems1 = items
            let sortedArray = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "catID", ascending: true)])
            self.listItems1 = sortedArray as! [ItemsCoreData]
            
            self.arrCheck.removeAll()
            if self.listItems1.count > 0
            {
                
                self.arrCheck = self.listItems1
            }
            else
            {
                self.btnHideUnhideItem.isHidden = true
                self.ItemsView.reloadData()
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
    
    @objc func btnFvrtItemClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        //        btn.isSelected = !btn.isSelected
        id =  self.listItems[btn.tag].itemID
        if btn.isSelected == false
        {
            btn.isSelected = true
            
            self.setFav(favId: 1)
            
        }
        else
        {
            btn.isSelected = false
            self.setFav(favId: 0)
            
        }
        
        
    }
    
    
    
    @objc func tap(_ sender: UITapGestureRecognizer)
    {
        
        let location = sender.location(in: self.ItemsView)
        let indexPath = self.ItemsView.indexPathForItem(at: location)
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            ItemDetails.itemPosition = indexPath!
            let index = indexPath!.row
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
            self.ItemsView.isHidden = false
            let SelectedCategories = self.listCategories[(indexPath.row)]
            let catID : Int32? = Int32(SelectedCategories.catID)
            let CatSeq: Int32? = Int32(SelectedCategories.catSequence)
            UserDefaults.standard.set(catID, forKey: "id")
            selectedIndex = indexPath.row
            //        UserDefaults.standard.set(CatSeq, forKey: "id")
            UserDefaults.standard.synchronize()
            self.GetItems(CatID: catID!)
            self.CategoriesView.reloadData()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == self.CategoriesView)
        {
            
            let SelectedCategories = self.listCategories[(indexPath.row)]
            var size = CategoryName(CategoryList: SelectedCategories).size(withAttributes: nil)
            size.width =  size.width + 180
            size.height = 100
            return CGSize(width:max(60,size.width),height:size.height)
        }
        else
        {
            //return CGSize(width: 466, height: 600)
            return CGSize(width:(self.view.frame.size.width - 20 )/2, height: self.view.frame.size.height - 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 3
        
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
            
            return UIImage(named: "NOImage")!
        }
    }
    
    @IBOutlet weak var CategoriesView: UICollectionView!
    
    
    func GetCategory(){
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID != %i", 0)
            let categories = CategoryCoreData.SK_all(context, predicate: predicate, sortTerm: "catSequence", ascending: true)
            if categories.count > 0
            {
                self.listCategories = categories
                
                self.GetItems(CatID: self.listCategories[0].catID)
                self.CategoriesView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
                //                UserDefaults.standard.set(self.listCategories[0].catID, forKey: "id")
                //                UserDefaults.standard.synchronize()
            }
            
            self.CategoriesView.reloadData()
            
        }
    }
    func GetItems(CatID: Int32){
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:CatID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            ItemDetails.CategoryID = CatID;
            self.listItems = items

            if self.listItems.count > 0 {
                self.ItemsView.reloadData()
                
                self.ItemsView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                             at: .right,
                                             animated: false)
                
            } else {
                self.ItemsView.isHidden = true
            }
        }
    }
    
    func setFav(favId:Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:ItemDetails.CategoryID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.id
                {
                    if (dict.isFav == Int32(0))
                    {
                        dict.isFav = favId
                        // var arr1 = [[String:AnyObject]]()
                        
                    }
                    else
                    {
                        dict.isFav = 0
                        
                    }
                }
            }
            self.ItemsView.reloadData()
        }
        
    }
    func CategoryName (CategoryList : CategoryCoreData) ->String {
        var CategoryName : String? = "" ;
        if(CurrentLanguage == "ara")
        {
            CategoryName = CategoryList.catNameAra
        }
        else {
            CategoryName = CategoryList.catNameEng
        }
        
        return CategoryName!;
    }
    func downloadBrandImageLogo(){
        
        SkopelosClient.shared.read { context in
            let BrandID :Int32? = BrandViewController.Brandhelper.brandID;
            let predicate = NSPredicate(format: "brandID = \(NSNumber(value:BrandID!))")
            let items = Brands.SK_all(predicate, context: context)
            var brandData = [Brands]()
            brandData=items;
            
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.brandLogo) { (_, error) in
                self.brandLogo.isHidden = (error != nil)
                self.btnBrandLogo.isHidden = (error != nil)
            }

            if brandData[0].facebook == ""
            {
                self.viewFb.isHidden = true
                
            }
            else
            {
                self.viewFb.isHidden = false
                self.strfb = brandData[0].facebook
                self.lblfb.text = self.strfb
                let str4 = self.themeData[0].fontColor
                
                if  (str4 == nil || str4!.isEmpty)
                {
                    self.lblfb.textColor = UIColor.black
                    
                }
                    
                else
                {
                    let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                    self.lblfb.textColor  = color1
                    
                }
                
                
                
            }
            if brandData[0].instagram == ""
            {
                self.viewInsta.isHidden =  true
                //                strinsta = "instagram://user?username=khush_23_04"
                
            }
            else
            {
                self.viewInsta.isHidden = false
                self.strinsta = brandData[0].instagram
                self.lblInsta.text = self.strinsta
                let str11 = self.themeData[0].fontColor
                
                if  (str11 == nil || str11!.isEmpty)
                {
                    self.lblInsta.textColor = UIColor.black
                    
                }
                    
                else
                {
                    let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                    self.lblInsta.textColor  = color1
                    
                }
                
                
            }
            if brandData[0].telephone == ""
            {
                self.viewCall.isHidden = true
                
            }
            else
            {
                self.viewCall.isHidden = false
                self.strcall = brandData[0].telephone
                self.lblCall.text = self.strcall
                let str1233 = self.themeData[0].fontColor
                
                if  (str1233 == nil || str1233!.isEmpty)
                {
                    self.lblCall.textColor = UIColor.black
                    
                }
                    
                else
                {
                    let color1 = self.colorWithHexString(hex: self.themeData[0].fontColorItemName!)
                    self.lblCall.textColor = color1
                    
                }
 
            }
            if brandData[0].currency == ""
            {
                self.strcurrency = "KD"
            }
            else
            {
                self.strcurrency = brandData[0].currency
            }
        }
    }
    func downloadThemes(ThemeID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ItemDetails.staticThemeData = items;
            let imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: imageView)
            self.view.addSubview(imageView)
            self.view.sendSubview(toBack: imageView)
        }
        
    }
}
extension ItemViewLayoutCVC: CollectionViewCellDelegate
{
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        let indexPath = self.ItemsView.indexPath(for: cell)
        let items  = self.listItems[(indexPath?.row)!]
        // Call `performSegue`
        ItemViewLayoutCVC.ItemDetails.itemPosition = indexPath!
        ItemViewLayoutCVC.ItemDetails.strCome = "layoutC"
        ItemViewLayoutCVC.ItemDetails.strPassitemId = items.itemSeq

        self.performSegue(withIdentifier: "itemsDetailViewSegue", sender: nil)
    }
}

