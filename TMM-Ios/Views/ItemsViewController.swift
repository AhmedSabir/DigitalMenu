//
//  ItemsView.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 7/11/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ImageIO
import MobileCoreServices
import AVKit

class ItemViewController : UIViewController ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var btnfav: UIButton!
     @IBOutlet weak var viewFeedBack: UIView!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblFeedback: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnHideUnhideItem: UIButton!
    @IBOutlet weak var viewInsta: UIView!
    @IBOutlet weak var viewFb: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblfb: UILabel!
    @IBOutlet weak var lblInsta: UILabel!
    @IBOutlet weak var btnBrandLogo: UIButton!

    @IBOutlet var viewHome: UIView!
    @IBOutlet var viewFav: UIView!
    
    
    var id :Int32 = 0
    var index:Int!
    var strCome:String!
    var strCome1:String!
    var  isfeedBack :Int32!
    var  strRate:String!
    var arrReplace:NSMutableArray = []
    var selectedIndex:Int = 0
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()
    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!
//    var arrReplace:NSMutableArray = []
    var arrFav = [[String:AnyObject]]()
    var arrCheck = [ItemsCoreData]()

    struct ItemDetails
    {
        static var CategoryID = Int32();
        static var FavID = Int32();
        static var itemPosition = IndexPath() ;
        static var staticThemeData = [Themes]()
        static var itemId = Int32();
        static var strPassitemId = Int32();
    }
    //A string array to save all the names
    var listItems = [ItemsCoreData]()
    var listItems1 = [ItemsCoreData]()
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
    override func viewDidAppear(_ animated: Bool)
     {
        self.GetCategory()
        self.GethideItems()
    
        self.CategoriesView.selectItem(at: IndexPath(row:selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            self.btnfav.setImage(UIImage(named:"cart"), for: .normal)
            self.btnfav.setImage(UIImage(named:"cart"), for: .selected)
          //  self.btnfav.layer.cornerRadius = self.btnfav.layer.frame.size.width / 2
            
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
    
    @IBAction func btnLogoClick(_ sender: UIButton)
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        self.btnBrandLogo.isSelected = true
        let objVC: SlideShowVC? = storyboard?.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
        objVC?.strIsCome = "layoutA"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }

    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        let objVC: FeedBackVC? = storyboard?.instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
        objVC?.strIsCome = "layoutA"
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    
    @IBAction func btnfavClick(_ sender: UIButton)
    {
        self.btnfav.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FavVC") as! FavVC
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GetCategory()
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            if  strCome == "slide"
            {
                self.CategoriesView.selectItem(at: IndexPath(row:selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            else
            {
                UserDefaults.standard.set(1, forKey: "id")
                UserDefaults.standard.synchronize()
            }

        }
        else
        {
            if strCome1 == "fav" || strCome == "slide" ||  strCome == "check"
            {
                self.CategoriesView.selectItem(at: IndexPath(row:selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            else
            {
                UserDefaults.standard.set(1, forKey: "id")
                UserDefaults.standard.synchronize()
            }
        }
        if BrandViewController.Brandhelper.feedBack == 0
        {
            self.btnFeedBack.isHidden = true
        }
        else
        {
            self.btnFeedBack.isHidden = false

        }
        
        
        
        
        
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo();
        if themeData[0].fontColor == nil
        {
              language.titleLabel?.textColor = UIColor.black
        }
        else
        {
            language.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)

        }
        if (themeData[0].englishButton != nil)
        {
            self.viewHome.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            self.viewFav.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
        }
        else
        {
            self.viewHome.backgroundColor = UIColor.lightGray
            self.viewFav.backgroundColor = UIColor.lightGray
        }
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryActive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        self.btnfav.isSelected = false
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

    }
    
    //MARK: -Long Press
    @objc func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
           
            
            btnHideUnhideItem.isHidden = false
            UserDefaults.standard.removeObject(forKey: "isDatasaved")
            UserDefaults.standard.synchronize()
            self.ItemsView.reloadData()
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began
        {
        }
    }

    @IBAction func btnHideUnhideItemClick(_ sender: UIButton)
    {
        btnHideUnhideItem.isHidden = false
        btnHideUnhideItem.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "HideItemVC") as! HideItemVC
        popOverVC.strIsCome = "check"
        popOverVC.getCatId = ItemDetails.CategoryID
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
        if dict["type"] as? String == "2"
        {
            let arr = dict ["radio"] as? NSMutableArray

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
        language.setTitleColor(colorWithHexString(hex:themeData[0].fontColorItemName!), for: .normal)

        if themeData[0].fontColor == nil
        {
            language.setTitleColor(UIColor.black, for: .normal)

        }
        else
        {
            language.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)

        }
        
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
            view1.backgroundColor = UIColor.clear
            view1.addSubview(contentImageView)
            cell.backgroundView = view1
            
            let contentImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width:cell.frame.size.width, height: cell.frame.size.height))
            contentImageView1.backgroundColor = UIColor.clear
            ImageLoader_SDWebImage.setImage(themeData[0].categoryActive, into: contentImageView1)
            let view2 = UIView()
            view2.backgroundColor = UIColor.clear
            view2.addSubview(contentImageView1)
            view2.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = view2
            contentImageView.backgroundColor = UIColor.clear
            contentImageView1.backgroundColor = UIColor.clear
            
//            if !ImageLoader_SDWebImage.cacheExist(for: themeData[0].categoryInactive) || ImageLoader_SDWebImage.cacheExist(for: themeData[0].categoryActive)
//            {
//                contentImageView1.isHidden = true
//                contentImageView.isHidden = true
//            }
//            else
//            {
//                contentImageView1.isHidden = false
//                contentImageView.isHidden = false
//
//            }
//cell.backgroundColor = UIColor.clear
            let SelectedCategories = self.listCategories[(indexPath.row)]
            let catID : Int32? = Int32(SelectedCategories.catID)
            if UserDefaults.standard.value(forKey: "id")as? Int32 != nil
            {
               
                 if ((UserDefaults.standard.value(forKey: "id")as! Int32) == catID)
                {
                    self.GetItems(CatID: catID!)
                    cell.isSelected = true
                    cell.selectedBackgroundView = view2

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
        }
        else
        {
            
            let cell = ItemsView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell;
            let ItemsDetail: ItemsCoreData
                    cell.viewInner.layer.cornerRadius = 3.0
                    cell.viewInner.layer.borderColor = UIColor.clear.cgColor
                     cell.viewInner.clipsToBounds = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            ItemsDetail = self.listItems[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblPrice.text = String(format: "%@ %@", strcurrency,ItemsDetail.price!)
            cell.delegate = self
            cell.btnCheck.isHidden = true
            let str1111 = themeData[0].itemBackgroundColor
            
            var getValue : String!
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                  cell.lblOutofstock.text = "Out Of Stock!"
            }
                
            else
            {
                getValue = UserDefaults.standard.value(forKey: "lang") as? String
                switch  getValue
                {
                case "eng": cell.lblOutofstock.text = "Out Of Stock!"
                case "ara": cell.lblOutofstock.text = "إنتهى من المخزن!"
                case "cha":cell.lblOutofstock.text = "缺貨！"
                case "ira":cell.lblOutofstock.text = "As stoc!"
                case "ita":cell.lblOutofstock.text = "Esaurito!"
                case "fra":cell.lblOutofstock.text = "En rupture de stock!"
                case "ger":cell.lblOutofstock.text = "Ausverkauft!"
                case "ban": cell.lblOutofstock.text = "স্টক আউট!"
                case "hin":cell.lblOutofstock.text = "अप्राप्य!"
                case "phil":cell.lblOutofstock.text = "Sa labas ng Stock!"
                case "urd":cell.lblOutofstock.text = "زخیرے سے باہر!"
                case "kor":cell.lblOutofstock.text = "품절!"
                case "spa":cell.lblOutofstock.text = "¡Agotado!"
                case "sri":cell.lblOutofstock.text = "තොග අවසන්!"
                case "tur":cell.lblOutofstock.text = "Stoklar tükendi!"
                default:cell.lblOutofstock.text = "Out Of Stock!"
                    
                }
                
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
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                cell.lblItemName.text=ItemsDetail.itemName;
                cell.lblIngredient.text=ItemsDetail.ingredientEng;
                
            }
                
            else
            {
                getValue = UserDefaults.standard.value(forKey: "lang") as? String
                switch  getValue
                {
                case "eng": cell.lblItemName.text = ItemsDetail.itemName
                            cell.lblIngredient.text = ItemsDetail.ingredientEng
                    
                case "ara": cell.lblItemName.text = ItemsDetail.itemNameAr
                            cell.lblIngredient.text = ItemsDetail.ingredientAra
                    
                case "cha": cell.lblItemName.text = ItemsDetail.itemNameChinese
                            cell.lblIngredient.text = ItemsDetail.ingredientChinese
                    
                case "ira":cell.lblItemName.text = ItemsDetail.itemNameIranian
                           cell.lblIngredient.text = ItemsDetail.ingredientIranian
                    
                case "ita":cell.lblItemName.text = ItemsDetail.itemNameItalian
                           cell.lblIngredient.text = ItemsDetail.ingredientItalian
               
                case "fra":cell.lblItemName.text = ItemsDetail.itemNameFrench
                          cell.lblIngredient.text = ItemsDetail.ingridentFrench
                
                case "ger":cell.lblItemName.text = ItemsDetail.itemNameGermany
                           cell.lblIngredient.text = ItemsDetail.ingridentGermany
                
                case "ban": cell.lblItemName.text = ItemsDetail.itemNamebangladeshi
                            cell.lblIngredient.text = ItemsDetail.ingredientBangladeshi
                
                case "hin":cell.lblItemName.text = ItemsDetail.itemNameHindi
                           cell.lblIngredient.text = ItemsDetail.ingridentHindi
               
                case "phil":cell.lblItemName.text = ItemsDetail.itemNamePhilippines
                            cell.lblIngredient.text = ItemsDetail.ingredientPhilippines
                
                case "urd":cell.lblItemName.text = ItemsDetail.itemNameUrdu
                           cell.lblIngredient.text = ItemsDetail.ingredientUrdu
                
                case "kor":cell.lblItemName.text = ItemsDetail.itemNameKorean
                           cell.lblIngredient.text = ItemsDetail.ingredientKorean
                
                case "spa":cell.lblItemName.text = ItemsDetail.itemNameSpain
                           cell.lblIngredient.text = ItemsDetail.ingredientSpain
                
                case "sri":cell.lblItemName.text = ItemsDetail.itemNameSrilanka
                           cell.lblIngredient.text = ItemsDetail.ingredientSrilanka
                
                case "tur":cell.lblItemName.text = ItemsDetail.itemNameTurkish
                           cell.lblIngredient.text = ItemsDetail.ingredientTurkish
                
                default:cell.lblItemName.text = ItemsDetail.itemName
                cell.lblIngredient.text = ItemsDetail.ingredientEng
                    
                }
                
            }

            cell.ImgItem.contentMode = .scaleAspectFit
            cell.ImgItem.isHidden = false
            cell.btnImageItem.isHidden = false
            cell.videoItem.isHidden = true
            
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.ImgItem) { (_, error) in
                if error != nil {
                    let placeholder = ImageLoader_SDWebImage.placeholder
                    cell.ImgItem.image = placeholder
                }
                cell.ImgItem.isHidden = (error != nil)
            }

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
    
    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        
    }
    deinit {
        // Release all resources
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)
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
    
    
    
    
    @objc func tap(_ sender: UITapGestureRecognizer)
    {
        
        let location = sender.location(in: self.ItemsView)
        let indexPath = self.ItemsView.indexPathForItem(at: location)
        if let index = indexPath {
            ItemDetails.itemPosition = indexPath!
            let index = indexPath!.row
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.ItemsView.isHidden = false
        let SelectedCategories = self.listCategories[(indexPath.item)]
        let catID : Int32? = Int32(SelectedCategories.catID)
        let CatSeq: Int32? = Int32(SelectedCategories.catSequence)
        selectedIndex = indexPath.item
        UserDefaults.standard.set(catID, forKey: "id")
        UserDefaults.standard.synchronize()
        self.CategoriesView.reloadData()
        self.GetItems(CatID: catID!)
        self.ItemsView.scrollToItem(at:IndexPath(item:0, section: 0), at:.centeredHorizontally, animated: false)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if (collectionView == self.CategoriesView)
         {
                let SelectedCategories = self.listCategories[(indexPath.row)]
                var size = CategoryName(CategoryList: SelectedCategories).size(withAttributes: nil)
                size.width =  size.width + 180;
                size.height = 80
                return CGSize(width:max(60,size.width),height:size.height)

        }
         else
         {
                return CGSize(width:(self.view.frame.size.width - 20)/2, height: (self.view.frame.size.height - 220))

//

                //return CGSize(width: 466, height: 600)
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
                return image
                
            }
            else
            {
                return UIImage(named: "NoImage")!
                
            }
            
        }else{
            return UIImage(named: "NoImage")!
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
                  NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIDeviceOrientationDidChange, object:nil)
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
    func GetVideoFromStorage(fileName: String) -> URL
    {
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath)
        {
            let fileURL = NSURL(fileURLWithPath: filePath)

            return fileURL as URL
            
        }
        else{
            let fileURL = NSURL(fileURLWithPath: filePath)
            return fileURL as URL

        }
    }

    @IBOutlet weak var CategoriesView: UICollectionView!
    @IBAction func btnHomeClick(_ sender: UIButton)
    {
        if self.strCome != "slide"
        {
            if self.strCome == "feedback"
            {
                let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
                objVC?.Selectedindex = self.selectedIndex
                let aObjNavi = UINavigationController(rootViewController: objVC!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = aObjNavi
                aObjNavi.isNavigationBarHidden = true

            }
            else
            {
                navigationController?.popViewController(animated: true)

            }

        }
        else
        {
                    let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
                    objVC?.Selectedindex = self.selectedIndex
                    let aObjNavi = UINavigationController(rootViewController: objVC!)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = aObjNavi
                    aObjNavi.isNavigationBarHidden = true

        }
    }
    func GetCategory(){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID != %i", 0)
            let categories = CategoryCoreData.SK_all(context, predicate: predicate, sortTerm: "catSequence", ascending: true)
            if categories.count > 0
            {
                self.listCategories = categories
                self.GetItems(CatID: self.listCategories[0].catID)
                self.CategoriesView.reloadData()
                self.selectedIndex = 0
                self.CategoriesView.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    func GetItems(CatID: Int32){
        
        SkopelosClient.shared.read { context in
            self.listItems.removeAll()
            let predicate = NSPredicate(format: "catID = %d",CatID)
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            ItemDetails.CategoryID = CatID
            self.listItems = items
            if   self.listItems.count > 0
            {
                self.ItemsView.reloadData()
                self.selectedIndex = 0
                self.ItemsView?.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0),
                                             at: .right,
                                             animated: false)
                
                self.ItemsView.selectItem(at:  IndexPath(row:self.selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            
            else
            {
                
              //  self.ItemsView.reloadData()
                self.ItemsView.isHidden = true

            }
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
        var getValue : String!
        if UserDefaults.standard.value(forKey: "lang") as?  String == nil
        {
            CategoryName = CategoryList.catNameEng
            return CategoryName!;

        }
            
        else
        {

            getValue = UserDefaults.standard.value(forKey: "lang") as? String
            switch  getValue
            {
            case "eng": CategoryName = CategoryList.catNameEng
            case "ara": CategoryName = CategoryList.catNameAra
            case "cha":CategoryName = CategoryList.categoryNameChinese
            case "ira":CategoryName = CategoryList.categoryNameIraninan
            case "ita":CategoryName = CategoryList.categoryNameItalian
            case "fra":CategoryName = CategoryList.categoryNameFrench
            case "ger":CategoryName = CategoryList.categoryNameGermany
            case "ban": CategoryName = CategoryList.categoryNameBangladeshi
            case "hin":CategoryName = CategoryList.categoryNameHindi
            case "phil":CategoryName = CategoryList.categoryNamePhilippines
            case "urd":CategoryName = CategoryList.categoryNameUrdu
            case "kor":CategoryName = CategoryList.categoryNameKorean
            case "spa":CategoryName = CategoryList.categoryNameSpain
            case "sri":CategoryName = CategoryList.categoryNameSrilanka
            case "tur":CategoryName = CategoryList.categoryNameTurkish
            default:CategoryName = CategoryList.catNameEng
                
            }
            if CategoryName == "" || CategoryName == nil
            {
                CategoryName = ""
                return CategoryName!
            }
            else
            {
                return CategoryName!;

            }

        }

    }
    func downloadBrandImageLogo(){
        SkopelosClient.shared.read
            { context in
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
                    self.lblCall.textColor  = color1
                    
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
    func downloadThemes(ThemeID: Int32){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ItemDetails.staticThemeData = items;
            
            var imageView : UIImageView!
            imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.isHidden = true
            
            self.view.addSubview(imageView)
            self.view.sendSubview(toBack: imageView)
            
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: imageView) { (_, error) in
                if (error != nil) {
                    imageView.image = ImageLoader_SDWebImage.placeholder
                }
                imageView.isHidden = (error != nil)
            }
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
 
}
extension ItemViewController: CollectionViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        let indexPath = self.ItemsView.indexPath(for: cell)
        let items  = self.listItems[(indexPath?.row)!]
        ItemViewController.ItemDetails.itemPosition = indexPath!
        ItemViewController.ItemDetails.strPassitemId = items.itemSeq
        self.performSegue(withIdentifier: "itemsDetailViewSegue", sender: nil)

    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

