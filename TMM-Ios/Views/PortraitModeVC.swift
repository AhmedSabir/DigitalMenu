//
//  PortraitModeVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/19/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit

class PortraitModeVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate,AVPlayerViewControllerDelegate
{
    
    @IBOutlet weak var brandLogo: UIImageView!
    // @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var viewFeedBack: UIView!
//    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblFeedback: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collThumbnail: UICollectionView!
    @IBOutlet weak var imgBg: UIImageView!

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

    
    var id :Int32 = 0
    var index:Int!
    var selectItemIndex:Int = 0
    var listImages = [ItemsCoreData]()
    var isInPortrait:Bool!
    var strCome:String!
    var strCome1:String!
    var  strRate:String!
    var arrReplace:NSMutableArray = []
    var selectedIndex:Int = 0
    var arrThumbNail = [ItemsCoreData]()
    var listVideo = [[String:AnyObject]]()
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()
    var isVideo : Bool = false
    var arrCheck = [ItemsCoreData]()
    var listItems1 = [ItemsCoreData]()
    let CurrentLanguage:String = UserDefaults.standard.value(forKey: "lang") as! String

    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!
    @IBAction func btnLogoClick(_ sender: UIButton)
        
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        if self.strCome != "slide"
        {
            navigationController?.popViewController(animated: true)
            
        }
        else
        {

        let objVC: Slideshow1Vc? = storyboard?.instantiateViewController(withIdentifier: "Slideshow1Vc") as? Slideshow1Vc
        objVC?.strIsCome = "portrait"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
        }
        
    }
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnBrandLogo: UIButton!

    //MARK: -Action
    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        //self.performSegue(withIdentifier: "FeedbackSegue1", sender: nil)
        let objVC: Feedback1VC? = storyboard?.instantiateViewController(withIdentifier: "Feedback1VC") as? Feedback1VC
        objVC?.strIsCome = "Portrait"
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

    }
    @IBAction func btnHomeClick(_ sender: UIButton)
    {
//        let presentingViewController: UIViewController! = self.presentingViewController
//        self.dismiss(animated: false) {
//            presentingViewController.dismiss(animated: false, completion: nil)
//        }
        let objVC: HomePage1VC? = storyboard?.instantiateViewController(withIdentifier: "HomePage1VC") as? HomePage1VC
        objVC?.Selectedindex = 4
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    @IBAction func btnChangeLanguage(_ sender: UIButton)
    {
        print("Language Changed Button clicked");
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryActive) { (image, _) in
            self.language.setBackgroundImage(image, for: [])
        }
        
        let CurrentLanguage = Language.language;
        if (CurrentLanguage=="eng")
        {
            Language.language="ara"
            language.setTitle("ENG", for: .normal)
            language.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
        } else if (CurrentLanguage == "ara") {
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
        //static var  strCome = String()
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
    
    @IBAction func btnfavClick(_ sender: UIButton)
    {
        self.btnfav.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "fav1vc") as! fav1vc
        popOverVC.strIsCome = "portrait"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectItemIndex = 0
        self.GetCategory()
        if BrandViewController.Brandhelper.feedBack == 0
        {
            self.btnFeedBack.isHidden = true
        }
        else
        {
            self.btnFeedBack.isHidden = false
        }
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
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo();
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
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        language.addGestureRecognizer(longGesture)

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
        }
    }
    
    @IBAction func btnHideUnhideItemClick(_ sender: UIButton)
    {
        
        btnHideUnhideItem.isHidden = false
        btnHideUnhideItem.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "PortraitHideItemVC") as! PortraitHideItemVC
        popOverVC.strIsCome = "check"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool)
    {

        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
        
//        self.btnfav.isSelected = false
//        self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isInPortrait = true
        }

    }
    
    var listCategory = [ItemsCoreData]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.CategoriesView)
        {
            return listCategories.count
        }
        else if (collectionView == self.collThumbnail)
        {
            return arrThumbNail.count
        }
        else{
            
            return listVideo.count
            //return listItems.count
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
            let catID : Int32? = Int32(SelectedCategories.catID)
            if UserDefaults.standard.value(forKey: "id")as? Int32 != nil
            {
                if ((UserDefaults.standard.value(forKey: "id")as! Int32) == catID)
                {
                    self.GetItems(CatID: catID!)
                    
                    cell.isSelected = true
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
            
        else if (collectionView == collThumbnail)
        {
            
            let cell = collThumbnail.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
            let ItemsDetail: ItemsCoreData
            
            ItemsDetail = self.arrThumbNail[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblThumbnailName.text=ItemsDetail.itemName
            let str1 = themeData[0].fontColorItemName
            
            if   (str1 == nil || str1!.isEmpty)
            {
                cell.lblThumbnailName.textColor = UIColor.black
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
                cell.lblThumbnailName.textColor  = color1
            }
            
            if(CurrentLanguage == "ara")
            {
                cell.lblThumbnailName.text = ItemsDetail.itemNameAr;
            }else
            {
                cell.lblThumbnailName.text=ItemsDetail.itemName;
            }
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.imgThumbnail)
            
            if cell.isSelected
            {
                cell.viewThumbnail.layer.borderColor = UIColor.black.cgColor
                cell.viewThumbnail.layer.borderWidth = 2
                cell.viewThumbnail.layer.cornerRadius = 5
                let black = UIColor.gray // 1.0 alpha
                cell.viewThumbnail.backgroundColor = UIColor.withAlphaComponent(black)(0.8)
                
            }
            else
            {
                cell.viewThumbnail.layer.cornerRadius = 5.0
                cell.viewThumbnail.layer.borderWidth = 2
                cell.viewThumbnail.layer.borderColor = UIColor.black.cgColor
                let black = UIColor.white // 1.0 alpha
                cell.viewThumbnail.backgroundColor = UIColor.withAlphaComponent(black)(0.7)
                
            }
            
            return cell
        }
            
            
        else
        {
            let cell = ItemsView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell;
            //let ItemsDetail: ItemsCoreData
            cell.viewInner.layer.cornerRadius = 3.0
            cell.viewInner.layer.borderColor = UIColor.clear.cgColor
            cell.viewInner.clipsToBounds = true
            let ItemsDetail = self.listVideo[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblPrice.text = String(format: "%@ %@", strcurrency,(ItemsDetail["price"]as? String)!)

            cell.delegate = self
            let str = themeData[0].fontColorPrice
            if (CurrentLanguage=="eng")
            {
                cell.lblOutofstock.text = "Out Of Stock!"
            }
            else
            {
                cell.lblOutofstock.text = "إنتهى من المخزن!"
            }

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
            
            if ItemsDetail["isFav"] as? Int32 == 1
            {
                cell.btnfav.isSelected = true
            }
                
            else
            {
                cell.btnfav.isSelected = false
                
            }
            if UserDefaults.standard.value(forKey: "isDatasaved")as? String == "yes"
            {
                if ItemsDetail["isCheck"] as? Int32 == 1
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
                    if ItemsDetail["isCheck"] as? Int32 == 0
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
                    
                    if ItemsDetail["isCheck"] as? Int32 == 0
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
                cell.lblItemName.text = ItemsDetail["itemNameAr"] as? String;
                cell.lblIngredient.text = ItemsDetail["ingredientAra"] as? String;
            }else
            {
                cell.lblItemName.text = ItemsDetail["itemName"] as? String;
                cell.lblIngredient.text = ItemsDetail["ingredientEng"] as? String;
            }
            cell.ImgItem.isHidden = false
            cell.videoItem.isHidden = true
            
            if indexPath.row > 0
            {
                let ItemsPrev = self.listVideo[indexPath.row - 1]
                let seq1 = ItemsDetail ["itemSeq"] as? Int32
                let seq2 = ItemsPrev ["itemSeq"] as? Int32
                
                if seq1 == seq2
                {
                    isVideo = true
                }
                else
                {
                    isVideo = false
                }
            }
            else
            {
                isVideo = false
            }
            
            
            let str123 = ItemsDetail["video"] as? String
            if isVideo == true
            {
                //            if str123 != nil && str123 != ""
                //            {
                cell.ImgItem.isHidden = true
                cell.videoItem.isHidden = false
                avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: str123!))
                avPlayerController.player = avPlayer
                avPlayerController.view.frame = CGRect(x: 0, y: 0, width: cell.ImgItem.frame.size.width, height: cell.ImgItem.frame.size.height)
                avPlayerController.showsPlaybackControls = true
                cell.videoItem.addSubview(avPlayerController.view)
                
            }
            ImageLoader_SDWebImage.setImage((ItemsDetail["imageName"] as? String), into: cell.ImgItem)
            
            //            cell.ImgItem.image = GetImageFromStorage(fileName: ItemsDetail.imageName!)
            cell.btnfav.tag = indexPath.row
            index = cell.btnfav.tag
            cell.btnfav.addTarget(self, action: #selector(btnFvrtItemClick(_:)), for: .touchUpInside)
            if (ItemsDetail["qty"] as? Int)! > 0
            {
                cell.lblQuantity.text = String(format: "%d", (ItemsDetail["qty"] as? Int ?? 0))
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
            

            
            return cell
        }
    }
    
    @objc func btnCheckItemClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        id =  self.listVideo[btn.tag]["itemID"] as! Int32
        
        
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
        id =  self.listVideo[btn.tag]["itemID"] as! Int32
        
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
            
            self.listImages = items
            if self.listImages.count > 0
            {
                self.listVideo.removeAll()
                for i in 0..<self.listImages.count
                {
                    
                    let dict = self.listImages[i]
                    
                    if (dict.video != "" && dict.video != nil)
                    {
                        let keys = Array(dict.entity.attributesByName.keys)
                        let dic = dict.dictionaryWithValues(forKeys: keys)
                        self.listVideo.append(dic as [String : AnyObject])
                        self.listImages [i] = dict
                    }
                    
                    let keys1 = Array(dict.entity.attributesByName.keys)
                    let dic1 = dict.dictionaryWithValues(forKeys: keys1)
                    self.listVideo.append((dic1 as [String : AnyObject]))
                }
                
            }
            self.ItemsView.reloadData()
        }
    }
    
    @objc func btnminusClick(_ sender: Any)
    {
        let btn = sender as! UIButton
        id = self.listVideo[btn.tag]["itemID"] as! Int32
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:ItemDetails.CategoryID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            
            for dict in items
            {
                if dict.itemID == self.id
                {
                    var Qty : Int = Int(dict.qty)
                    Qty = Qty - 1
                    dict.qty = Int32(Qty)
                }
            }
            
            self.listImages = items
            if self.listImages.count > 0
            {
                self.listVideo.removeAll()
                for i in 0..<self.listImages.count
                {
                    
                    let dict = self.listImages[i]
                    
                    if (dict.video != "" && dict.video != nil)
                    {
                        let keys = Array(dict.entity.attributesByName.keys)
                        let dic = dict.dictionaryWithValues(forKeys: keys)
                        self.listVideo.append(dic as [String : AnyObject])
                        self.listImages [i] = dict
                    }
                    
                    let keys1 = Array(dict.entity.attributesByName.keys)
                    let dic1 = dict.dictionaryWithValues(forKeys: keys1)
                    self.listVideo.append((dic1 as [String : AnyObject]))
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
            
            self.listImages = items
            if self.listImages.count > 0
            {
                self.listVideo.removeAll()
                for i in 0..<self.listImages.count
                {
                    
                    let dict = self.listImages[i]
                    
                    if (dict.video != "" && dict.video != nil)
                    {
                        let keys = Array(dict.entity.attributesByName.keys)
                        let dic = dict.dictionaryWithValues(forKeys: keys)
                        self.listVideo.append(dic as [String : AnyObject])
                        self.listImages [i] = dict
                    }
                    
                    let keys1 = Array(dict.entity.attributesByName.keys)
                    let dic1 = dict.dictionaryWithValues(forKeys: keys1)
                    self.listVideo.append((dic1 as [String : AnyObject]))
                }
            }
            self.ItemsView.reloadData()
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
    
    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        print("Video Finished")
        //        avPlayerController.player?.play()
        
    }
    deinit {
        // Release all resources
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)
    }
    
   

    
    @objc func tap(_ sender: UITapGestureRecognizer)
    {
        
        let location = sender.location(in: self.ItemsView)
        let indexPath = self.ItemsView.indexPathForItem(at: location)
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            ItemDetails.itemPosition = indexPath!
            
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
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
                self.GetItems(CatID: ItemDetails.CategoryID)
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collThumbnail
        {
            let SelectedCategories =
                self.arrThumbNail[(indexPath.row)]
            let cell = collThumbnail.cellForItem(at: indexPath) as! ThumbnailCell
            let catID : Int32? = Int32(SelectedCategories.catID)
            let CatSeq: Int32? = Int32(SelectedCategories.itemSeq)
       //     selectedIndex = indexPath.row
            UserDefaults.standard.synchronize()
            selectItemIndex = indexPath.item
            cell.viewThumbnail.layer.borderColor = UIColor.black.cgColor
            cell.viewThumbnail.layer.borderWidth = 2
            cell.viewThumbnail.layer.cornerRadius = 5
            let black = UIColor.gray // 1.0 alpha
            cell.viewThumbnail.backgroundColor = UIColor.withAlphaComponent(black)(0.8)
            for i in 0..<self.listVideo.count
            {
                let dic = self.listVideo[i]
                let pos:Int32 = (dic["itemSeq"] as? Int32)!
                if CatSeq == pos
                {
                    self.ItemsView.scrollToItem(at:IndexPath(item:i, section: 0), at:.centeredHorizontally, animated: false)
                    break
                }
            }
            
            
        }
        else  if collectionView == CategoriesView
        {
            self.ItemsView.isHidden = false
            self.collThumbnail.isHidden = false
            let SelectedCategories =
                self.listCategories[(indexPath.row)]
            let catID : Int32? = Int32(SelectedCategories.catID)
            //            let CatSeq: Int32? = Int32(SelectedCategories.catSequence)
            UserDefaults.standard.set(catID, forKey: "id")
            UserDefaults.standard.synchronize()
            selectedIndex = indexPath.row
            //        UserDefaults.standard.set(CatSeq, forKey: "id")
            self.GetItems(CatID: catID!)
            self.CategoriesView.reloadData()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
            let cell = collThumbnail.cellForItem(at:IndexPath(row: indexPath.item, section: 0)) as? ThumbnailCell  //IndexPath(row: selectItemIndex, section: 0)
        cell?.viewThumbnail.layer.borderColor = UIColor.black.cgColor
            cell?.viewThumbnail.layer.borderWidth = 2
            cell?.viewThumbnail.layer.cornerRadius = 5
            let black = UIColor.white // 1.0 alpha
        cell?.viewThumbnail.backgroundColor = UIColor.withAlphaComponent(black)(0.7)
       
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
        else if (collectionView == self.collThumbnail)
        {
            
            let SelectedCategories =
                self.listItems[(indexPath.row)]
            var size = ItemName(ItemList: SelectedCategories).size(withAttributes: nil)
            if size.width > 100
            {

                size.height =  size.height + 120

            }
//            let  appDel = UIApplication.shared.delegate as! AppDelegate
//
//            if appDel.isInPortrait == false
//            {
//                return CGSize(width:(self.collThumbnail.frame.size.width/3.5),height: max(self.collThumbnail.frame.size.height, size.height))

//            }
//            else
//            
//            {
                return CGSize(width:(self.collThumbnail.frame.size.width/3.5),height: max(self.collThumbnail.frame.size.height, size.height))
//
//            }
            //return CGSize(width:300,height:70)
            
        }
        else
        {
           

            //return CGSize(width: 466, height: 600)
            
            return CGSize(width:(self.view.frame.size.width), height:(self.view.frame.size.height - 425))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
//        if collectionView == CategoriesView
//        {
//            return 0
//
//        }
//        else
//        {
            return 0

//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
////        return 10
//        if collectionView == CategoriesView
//        {
//            return 10
//
//        }
//        else
//        {
            return 0
            
//        }

        
    }
    func wagaDuggu (fileName: String) -> UIImage{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath)
        {
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
                self.CategoriesView.reloadData()
                
                self.CategoriesView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    func GetItems(CatID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:CatID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            ItemDetails.CategoryID = CatID;
            self.listItems = items
            self.listImages = items
            
            if self.listImages.count > 0
            {
                self.listVideo.removeAll()
                for i in 0..<self.listImages.count
                {
                    let dict = self.listImages[i]
                    
                    if (dict.video != "" && dict.video != nil)
                    {
                        let keys = Array(dict.entity.attributesByName.keys)
                        let dic = dict.dictionaryWithValues(forKeys: keys)
                        self.listVideo.append(dic as [String : AnyObject])
                        self.listImages [i] = dict
                    }
                    
                    let keys1 = Array(dict.entity.attributesByName.keys)
                    let dic1 = dict.dictionaryWithValues(forKeys: keys1)
                    self.listVideo.append((dic1 as [String : AnyObject]))
                }
                
                DispatchQueue.main.async
                    {
                        self.ItemsView.reloadData()
                        self.ItemsView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                     at: .right,
                                                     animated: false)
                        
                }
                
            }
                
            else
            {
                //self.ItemsView.reloadData()
                self.ItemsView.isHidden = true
                self.collThumbnail.isHidden = true
            }
            self.arrThumbNail = items
            
            if   self.arrThumbNail.count > 0
            {
                self.collThumbnail.reloadData()
                
                self.collThumbnail?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                 at:.centeredHorizontally,
                                                 animated: false)
                self.selectItemIndex = 0
                self.collThumbnail.selectItem(at: IndexPath(row: self.selectItemIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                
            }
                
            else
            {
               // self.collThumbnail.reloadData()
                self.ItemsView.isHidden = true
                self.collThumbnail.isHidden = true

            }
            
        }
        
    }
    //MARK: -Scrollview
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
//    {
//                    let pageWidth: CGFloat = ItemsView.frame.size.width
//                    let page : NSInteger = NSInteger(ItemsView.contentOffset.x / pageWidth)
//        
//                    if page == 0
//                    {
//                        self.collThumbnail.reloadData()
//                        self.collThumbnail.selectItem(at: IndexPath(item:0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//        
//                    }
//                   else  if page == self.listVideo.count - 1
//                    {
//                        self.collThumbnail.reloadData()
//                        self.collThumbnail.selectItem(at: IndexPath(item: self.listVideo.count - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//                    }
//        else
//        {
//                            for i in 0..<self.listVideo.count
//                            {
//                                let dic = self.listVideo[i]
//                                let pos:Int32 = (dic["itemSeq"] as? Int32)!
//                                let SelectedCategories =
//                                    self.arrThumbNail[indexPath.row]
//                                let CatSeq: Int32? = Int32(SelectedCategories.itemSeq)
//                                if CatSeq == pos
//                                {
//                                    //self.ItemsView.scrollToItem(at:IndexPath(item:i, section: 0), at:.centeredHorizontally, animated: true)
//                                    self.collThumbnail.reloadData()
//                                    //   self.collThumbnail.layoutIfNeeded()
//                                    self.collThumbnail.selectItem(at: IndexPath(item:i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//                                    break
//                                }
//                            }
//            
//
//        }
//
//        
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        DispatchQueue.main.async
        {

            if scrollView == self.ItemsView
        {
            if self.ItemsView.visibleCells.count > 0
            {
                let cell: ItemsCollectionViewCell? = self.ItemsView.visibleCells[0] as? ItemsCollectionViewCell
                var index: IndexPath? = nil

                if let aCell = cell
                {
                    index = self.ItemsView.indexPath(for: aCell)
                }


                for i in 0..<self.arrThumbNail.count
                {
                    let dic = self.listVideo[(index?.item)!]
                    let pos:Int32 = (dic["itemSeq"] as? Int32)!
                    let SelectedCategories =
                        self.arrThumbNail[i]
                    let CatSeq: Int32? = Int32(SelectedCategories.itemSeq)

                    if CatSeq == pos
                    {
                        self.collThumbnail.reloadData()
//                        self.collThumbnail.layoutIfNeeded()
                        self.collThumbnail.selectItem(at: IndexPath(item:i, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                       break
                    }
                }
            }
        }
        }

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView == ItemsView
        {
            if listVideo.count > 0
            {
                
                let cell11 = cell as? ItemsCollectionViewCell
                
                let ItemsDetail = self.listVideo[(indexPath.row)]
                
                let str123 = ItemsDetail["video"] as? String
                if cell11?.videoItem.isHidden == false
                {
                    avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: str123!))
                    avPlayerController.player = avPlayer
                    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: (cell11?.ImgItem.frame.size.width)!, height: (cell11?.ImgItem.frame.size.height)!)
                    avPlayerController.showsPlaybackControls = true
                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
                    cell11?.videoItem.addSubview(avPlayerController.view)
                }
                
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
    func ItemName (ItemList : ItemsCoreData) ->String {
        var itemName : String? = "" ;
        if(CurrentLanguage == "ara")
        {
            itemName = ItemList.itemNameAr
        }
        else {
            itemName = ItemList.itemName
        }
        return itemName!;
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
//        avPlayer.pla
        print("it is Calling")
        return true
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
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: self.imgBg)
        }
    }
    
}

extension PortraitModeVC: CollectionViewCellDelegate
{
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        let indexPath = self.ItemsView.indexPath(for: cell)
        let items  = self.arrThumbNail[(indexPath?.row)!]
        PortraitModeVC.ItemDetails.itemPosition = indexPath!
        // ItemViewControllerLayoutDVC.ItemDetails.strCome = "layoutD"
        PortraitModeVC.ItemDetails.strPassitemId = items.itemSeq
        
        //        let items  = self.listItems[(indexPath?.row)!]
        //        // Call `performSegue`
        //        ItemViewControllerLayoutDVC.ItemDetails.itemPosition = indexPath!
        //        ItemViewControllerLayoutDVC.ItemDetails.strCome = "layoutD"
        //        ItemViewControllerLayoutDVC.ItemDetails.strPassitemId = items.itemSeq
        //        self.performSegue(withIdentifier: "itemsDetailViewSegue", sender: nil)
    }
}
