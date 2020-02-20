
//
//  ItemViewLayoutBVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 10/29/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ItemViewLayoutBVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate
{

    @IBOutlet weak var brandLogo: UIImageView!
    // @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var viewFeedBack: UIView!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblFeedback: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnHideUnhideItem: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnbrandLogo: UIButton!

    @IBOutlet var btnHome: UIButton!
    
    var id :Int32 = 0
    var index:Int!
    var strCome:String!
    var strCome1:String!

    var arrFav = [[String:AnyObject]]()

    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!

    @IBOutlet var viewFav: UIView!
    @IBOutlet weak var viewInsta: UIView!
    @IBOutlet weak var viewFb: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblfb: UILabel!
    @IBOutlet weak var lblInsta: UILabel!
    
    let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as? String

    var  strRate:String!
    var arrReplace:NSMutableArray = []
    var selectedIndex:Int = 0
    var arrCheck = [ItemsCoreData]()
    var listItems1 = [ItemsCoreData]()

    
    //MARK: -Action
    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        let objVC: FeedBackVC? = storyboard?.instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
        objVC?.strIsCome = "layoutB"
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

        //self.performSegue(withIdentifier: "FeedbackSegue", sender: nil)
    }
    @IBAction func btnHome111Click(_ sender: Any)
    {
        if self.strCome != "slide"
        {
            navigationController?.popViewController(animated: true)
            
        }
        else
        {
            
            let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
            objVC?.Selectedindex = 1
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
        }

    }

    @IBAction func btnLogoClick(_ sender: UIButton)
        
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        let objVC: SlideShowVC? = storyboard?.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
        objVC?.strIsCome = "layoutB"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

        
        
    }

    @IBAction func btnChangeLanguage(_ sender: UIButton)
    {

        ImageLoader_SDWebImage.getImage(themeData[0].categoryActive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        let CurrentLanguage = Language.language;
        if (CurrentLanguage=="eng")
        {
            Language.language="ara"
            language.setTitle("ENG", for: .normal)
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
        }else if (CurrentLanguage=="ara")
        {
            language.setTitle("عربى", for: .normal)
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            Language.language="eng"
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
    
//    @IBAction func btnFeedbackClick(_ sender: UIButton)
//    {
//        viewFeedBack.isHidden = false
//        //        self.tblFeedback.reloadData()
//    }
//
//    @IBAction func btnCloseClick(_ sender: UIButton)
//    {
//        viewFeedBack.isHidden = true
//
//
//    }
//
    
    @IBAction func btnfavClick(_ sender: UIButton)
    {
        self.btnfav.isSelected = true
//        let objVC: FavVC? = storyboard?.instantiateViewController(withIdentifier: "FavVC") as? FavVC
//        objVC?.strIsCome = "layoutB"
////        objVC?.strIsCome = "NAV"
////        objVC?.selectedIndex = self.selectedIndex
//        objVC?.selectedIndex = 0
//        let aObjNavi = UINavigationController(rootViewController: objVC!)
//        let transition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = aObjNavi
//        transition.subtype = kCATransitionFromBottom
//        aObjNavi.view.layer.add(transition, forKey: nil)
//        aObjNavi.isNavigationBarHidden = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FavVC") as! FavVC
        popOverVC.strIsCome = "layoutB"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)

        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.GetCategory()
//        viewFeedBack.isHidden = true
        if strCome1 == "fav" || strCome == "slide"
        {
            self.CategoriesView.scrollToItem(at:IndexPath(item:selectedIndex, section: 0), at: .centeredVertically, animated: false)
        }
        else
        {

            UserDefaults.standard.set(1, forKey: "id")
            UserDefaults.standard.synchronize()

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
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.language.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        language.setTitleColor(colorWithHexString(hex:themeData[0].fontColorItemName!), for: .normal)
        
        arrRadioFeedBack = [["name":"","isSelect":"0"]]
        arrStarFeedBack = [["count":"0"]]
        arrTextFeedBack = [["msg":""]]
        arrFeedBack =
            [["radio":arrRadioFeedBack,"type":"2","que":"Hotel service is good or bad?","isComp":"1"],["radio":arrStarFeedBack,"type":"0","que":"How was the food quality? Give Rattings","isComp":"0"],["radio":arrTextFeedBack,"type":"1","que":"Please mention your Comment","isComp":"1"]]
        for i in 0..<arrRadioFeedBack.count
        {

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
    

    @IBAction func btnFbClick(_ sender: UIButton)
    {
        Common.openFacebookURL(for: strfb)
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
    

    @IBAction func btnInstaClick(_ sender: UIButton)
    {
        Common.openInstagramURL(for: strinsta)
    }
    @IBAction func btnCallClick(_ sender: UIButton)
    {
        Common.openCallURL(for: strcall)
    }



    
    override func viewWillAppear(_ animated: Bool)
    {
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
//        self.btnfav.isSelected = false
//        self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //        if strCome1 == "fav" || strCome == "slide"
        //        {
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
            let cell = CategoriesView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as? CategoryCollectionViewCell
                        
            let CategoryDetails: CategoryCoreData
            CategoryDetails = self.listCategories[indexPath.row]
            cell?.CategoryName.text = CategoryName(CategoryList: CategoryDetails)
            let str4 = themeData[0].fontColor
            
            if  (str4 == nil || str4!.isEmpty)
            {
                cell?.CategoryName.textColor = UIColor.black
                
            }
                
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColor!)
                cell?.CategoryName.textColor  = color1
                
            }
            
            let contentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:(cell?.frame.size.width)!, height: (cell?.frame.size.height)!))
            contentImageView.backgroundColor = UIColor.clear
            ImageLoader_SDWebImage.setImage(themeData[0].categoryInactive, into: contentImageView)
            let view1 = UIView()
            view1.addSubview(contentImageView)
            cell?.backgroundView = view1
            
            let contentImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width:(cell?.frame.size.width)!, height: (cell?.frame.size.height)!))
            contentImageView1.backgroundColor = UIColor.clear
            ImageLoader_SDWebImage.setImage(themeData[0].categoryActive, into: contentImageView1)
            
            let view2 = UIView()
            view2.backgroundColor = UIColor.clear
            view2.addSubview(contentImageView1)
            cell?.selectedBackgroundView = view2

            let SelectedCategories = self.listCategories[(indexPath.row)]
            let catID : Int32? = Int32(SelectedCategories.catID)
            if UserDefaults.standard.value(forKey: "id")as? Int32 != nil
            {
                if ((UserDefaults.standard.value(forKey: "id")as! Int32) == catID)
                {
                    self.GetItems(CatID: catID!)
                    cell?.isSelected = true
                    cell?.selectedBackgroundView = view2
                }
                else
                {
                    cell?.isSelected = false
                    cell?.backgroundView = view1
                }
            }

            else
            {
                    cell?.isSelected = false
                cell?.backgroundView = view1


            }
        
            
            return cell!
        }
        else{
            let cell = ItemsView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell;
            let ItemsDetail: ItemsCoreData
            cell.viewInner.layer.cornerRadius = 3.0
            cell.viewInner.layer.borderColor = UIColor.clear.cgColor
            cell.viewInner.clipsToBounds = true
            
            cell.btnfav.imageView?.contentMode = .scaleAspectFill
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

            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            ItemsDetail = self.listItems[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblPrice.text = String(format: "%@ %@",strcurrency, ItemsDetail.price!)
            cell.delegate = self
            let str1111 = themeData[0].itemBackgroundColor
            
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
            
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.ImgItem)
            
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

            cell.btnfav.tag = indexPath.row
            index = cell.btnfav.tag
            cell.btnfav.addTarget(self, action: #selector(btnFvrtItemClick(_:)), for: .touchUpInside)
            
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.ItemsView.isHidden = false
        collectionView.deselectItem(at: indexPath, animated: false)
        let SelectedCategories = self.listCategories[(indexPath.row)]
        let catID : Int32? = Int32(SelectedCategories.catID)
        let CatSeq: Int32? = Int32(SelectedCategories.catSequence)
        UserDefaults.standard.set(catID, forKey: "id")
        selectedIndex = indexPath.item
        //        UserDefaults.standard.set(CatSeq, forKey: "id")
        UserDefaults.standard.synchronize()
        self.GetItems(CatID: catID!)
        self.CategoriesView.reloadData()
        self.ItemsView.setContentOffset(.zero, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == self.CategoriesView)
        {
            
            let SelectedCategories = self.listCategories[(indexPath.row)]
            var size = CategoryName(CategoryList: SelectedCategories).size(withAttributes: nil)

//            size.width =  size.width + 150
            if size.width > 100
            {
                
                size.height =  size.height + 100

            }
           
            return CGSize(width:(self.CategoriesView.frame.size.width - 20),height:max(70,size.height))
            //return CGSize(width:300,height:70)

        }
        
        else
        {
            //return CGSize(width: 466, height: 600)
            return CGSize(width:(self.ItemsView.frame.size.width / 2) , height: (self.view.frame.size.height - 100)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
        
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
        }    }
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
            if categories.count > 0 {
                self.listCategories = categories
                self.GetItems(CatID: self.listCategories[0].catID)
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

            if self.listItems.count > 0
            {
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
        else
        {
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
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.brandLogo)
            if self.brandLogo.image == UIImage(named: "NoImage")
            {
                self.brandLogo.isHidden = true
                self.btnbrandLogo.isHidden = true

            }
            else
            {
                self.brandLogo.isHidden = false
                self.btnbrandLogo.isHidden = false

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
    func downloadThemes(ThemeID: Int32)
    {
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ItemDetails.staticThemeData = items;
            self.imgBackground.contentMode =  UIViewContentMode.scaleToFill
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: self.imgBackground)
        }
        
        
    }
    
    //MARK -GetHideData
    func GethideItems() {
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


extension ItemViewLayoutBVC: CollectionViewCellDelegate
{
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        let indexPath = self.ItemsView.indexPath(for: cell)
        let items  = self.listItems[(indexPath?.row)!]
        // Call `performSegue`
        ItemViewLayoutBVC.ItemDetails.itemPosition = indexPath!
        ItemViewLayoutBVC.ItemDetails.strCome = "layoutB"
        ItemViewLayoutBVC.ItemDetails.strPassitemId = items.itemSeq
        self.performSegue(withIdentifier: "itemsDetailViewSegue", sender: nil)
    }
}
//extension UIView {
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//}


    

