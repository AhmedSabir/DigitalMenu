//
//  ClassicLayoutVC.swift
//  TMM-Ios
//
//  Created by Cisner iMac on 08/02/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import AVKit
class ClassicLayoutVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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

    
    
    var arrCategories = [CategoryCoreData]()
    var themeData = [Themes]()
    var listItems = [ItemsCoreData]()
    var listCategories = [CategoryCoreData]()
    var listImages = [ItemsCoreData]()
    var listVideo = [[String:AnyObject]]()

    
    //MARK:  -Outlets
    @IBOutlet weak var viewInsta: UIView!
    @IBOutlet weak var viewFb: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblfb: UILabel!
    @IBOutlet weak var lblInsta: UILabel!
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var btnlanguage: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnHideUnhideItem: UIButton!
    @IBOutlet weak var collClassic: UICollectionView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnBrandLogo: UIButton!
    @IBOutlet var viewFav: UIView!
    
    let currentLanguage = UserDefaults.standard.value(forKey: "lang") as? String

    override func viewDidLoad()
    {
        super.viewDidLoad()
    //    NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.GetCategory()
        if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
        {
            UserDefaults.standard.set(1, forKey: "id")
            UserDefaults.standard.synchronize()
        }
        else
        {
            if strCome1 == "fav"  ||  strCome == "check"
            {
                self.collClassic.selectItem(at: IndexPath(row:selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            else
            {
                UserDefaults.standard.set(1, forKey: "id")
                UserDefaults.standard.synchronize()
            }
        }
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo()
        if themeData[0].fontColor == nil
        {
            btnlanguage.titleLabel?.textColor = UIColor.black
        }
        else
        {
            btnlanguage.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            
        }
        
        self.btnfav.isSelected = false
        if UserDefaults.standard.value(forKey:"strTackingOrder") as? String == "yes"
        {
            self.btnfav.setImage(UIImage(named:"cart"), for: .normal)
            self.btnfav.setImage(UIImage(named:"cart"), for: .selected)
        }
        else
        {
            self.btnfav.setBackgroundImage(UIImage(named: "unfav"), for: .normal)
        }
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))  //Long function will call when user long press on button.
        btnlanguage.addGestureRecognizer(longGesture)
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.btnlanguage.setBackgroundImage((image ?? placeholder), for: [])
        }
        self.btnHome.isHidden = false
        
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
    @objc func rotated() {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                print("Landscape")
            }
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
                print("Portrait")
            }

    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            } else {
                print("Portrait")
            }
            self.collClassic.reloadData()
}
    //MARK: -Structure
    struct Language
    {
        static var language = "eng";
    }
    struct ItemDetails
    {
        static var CategoryID = Int32();
        static var FavID = Int32();
        static var itemPosition = IndexPath() ;
        static var staticThemeData = [Themes]()
        static var itemId = Int32();
        static var strPassitemId = Int32();
    }

    override func viewWillAppear(_ animated: Bool)
    {
    }
    //MARK: -Long Press
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            btnHideUnhideItem.isHidden = false
            UserDefaults.standard.removeObject(forKey: "isDatasaved")
            UserDefaults.standard.synchronize()
//            self.ItemsView.reloadData()
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began
        {
            print("UIGestureRecognizerStateBegan.")
            //            btnHideUnhideItem.isHidden = false
            //Do Whatever You want on Began of Gesture
        }
    }

    
     //MARK: -Action Method
    @IBAction func btnChangeLanguage(_ sender: UIButton)
    {

        let CurrentLanguage:String = UserDefaults.standard.value(forKey: "lang") as! String
        if (CurrentLanguage == "eng")
        {
            
            Language.language = "ara"
            btnlanguage.setTitle("ENG", for: .normal)
            btnlanguage.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
        }else if (CurrentLanguage == "ara")
        {
            btnlanguage.setTitle("عربى", for: .normal)
            btnlanguage.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            Language.language="eng"
            
        }
        UserDefaults.standard.set(Language.language, forKey: "lang")
        UserDefaults.standard.synchronize()
        self.GetCategory()
        
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
    @IBAction func btnHideUnhideItemClick(_ sender: UIButton)
    {
        btnHideUnhideItem.isHidden = false
        btnHideUnhideItem.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "HideItemVC") as! HideItemVC
        popOverVC.strIsCome = "check"
//        popOverVC.getCatId = ItemDetails.CategoryID
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
    }

    @IBAction func btnLogoClick(_ sender: UIButton)
    {
        if self.strCome != "slide"
        {
            navigationController?.popViewController(animated: true)
            
        }
        else
        {

        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        let objVC: SlideShowVC? = storyboard?.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
        objVC?.strIsCome = "Classiclayout"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    }

    @IBAction func btnHomeClick(_ sender: UIButton)
    {
//        let presentingViewController: UIViewController! = self.presentingViewController
//        self.dismiss(animated: false) {
//            presentingViewController.dismiss(animated: false, completion: nil)
//    }
        if self.strCome != "slide"
        {
            self.dismiss(animated: false)
            {
                
            }
            
        }
        else
        {

        let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
        objVC?.Selectedindex = 5
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }

    }
    @IBAction func btnFeedbackClick(_ sender: UIButton)
    {
        let objVC: FeedBackVC? = storyboard?.instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
        objVC?.strIsCome = "Classiclayout"
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
    
    //MARK:     -Collectionview Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassicCollCell", for: indexPath) as! ClassicCollCell
        let CategoryDetails: CategoryCoreData
        CategoryDetails = self.arrCategories[indexPath.row]
        cell.lblCatname.text = CategoryName(CategoryList: CategoryDetails)
        
        let str4 = themeData[0].fontColor
        
        if  (str4 == nil || str4!.isEmpty)
        {
            cell.lblCatname.textColor = UIColor.black
            
        }
            
        else
        {
            let color1 = colorWithHexString(hex: themeData[0].fontColor!)
            cell.lblCatname.textColor  = color1
            
        }
        let str1111 = themeData[0].itemBackgroundColor
        
        if  (str1111 == nil || str1111!.isEmpty)
        {
            cell.lblCatname.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            cell.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor

        }
            
        else
        {
            let color1 = colorWithHexString(hex: themeData[0].itemBackgroundColor!)
            cell.lblCatname.backgroundColor  = color1.withAlphaComponent(0.6)
            cell.layer.borderColor = color1.withAlphaComponent(0.6).cgColor
        }
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.8
        
        let SelectedCategories = self.arrCategories[(indexPath.row)]

        let catID : Int32? = Int32(SelectedCategories.catID)
        
        SkopelosClient.shared.read { context in
            self.listItems.removeAll()
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:catID!))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            self.listItems = items
            self.listItems = (self.listItems as NSArray).sortedArray(using: [NSSortDescriptor(key: "itemSeq", ascending: true)]) as! [ItemsCoreData]
            let ItemsDetail: ItemsCoreData
            if self.listItems.count > 0
            {
                ItemsDetail = self.listItems[0]
                ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.imgCatName)
            }
            cell.imgCatName.layer.cornerRadius = 5
            cell.imgCatName.layer.borderWidth = 1
            cell.imgCatName.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            return CGSize(width: (self.collClassic.frame.size.width / 3) - 15, height: self.collClassic.frame.size.height / 2.5)
        }
      else
        {
            return CGSize(width: ((self.view.frame.size.width - 20) / 3) - 10, height: (self.view.frame.size.height - 160 ) / 3.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let CategoryDetails: CategoryCoreData
        CategoryDetails = self.arrCategories[indexPath.row]
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        popOverVC.getCatId = CategoryDetails.catID
            popOverVC.strEngTitle = CategoryDetails.catNameEng!
           popOverVC.getCatName = CategoryDetails.catNameAra!
        navigationController?.pushViewController(popOverVC, animated: true)
    }
    
    
    //GetData
    func GetCategory(){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID != %i", 0)
            let categories = CategoryCoreData.SK_all(context, predicate: predicate, sortTerm: "catSequence", ascending: true)
            if categories.count > 0 {
                self.arrCategories = categories
                let BrandID :Int32? = BrandViewController.Brandhelper.brandID
                self.collClassic.reloadData()
                self.GetItems(CatID: BrandID!)
                self.selectedIndex = 0
                self.collClassic.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }

    
    func CategoryName (CategoryList : CategoryCoreData) ->String {
        var CategoryName : String? = "" ;
        if(currentLanguage=="ara")
        {
            CategoryName = CategoryList.catNameAra
        }
        else {
            CategoryName = CategoryList.catNameEng
        }
        
        return CategoryName!;
    }
    
    func GetItems(CatID: Int32) {
        SkopelosClient.shared.read { context in
            self.listItems = ItemsCoreData.SK_all(context)
        }
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

            if brandData[0].facebook == "" {
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
            let imageView : UIImageView!
            imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode =  UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: imageView)
            self.view.addSubview(imageView)
            self.view.sendSubview(toBack: imageView)
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
    func wagaDuggu (fileName: String) -> UIImage{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath){
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

    
}
