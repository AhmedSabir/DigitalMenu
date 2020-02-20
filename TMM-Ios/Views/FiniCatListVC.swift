//
//  FiniCatListVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 8/1/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import AVKit
import CoreData

class FiniCatListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var id :Int32 = 0
    var index:Int!
    var strCome:String!
    var strCome1:String!
    var isfeedBack :Int32!
    var strRate:String!
    var arrReplace:NSMutableArray = []
    var selectedIndex:Int = 0
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()
    var strcurrency:String!
    
    var arrCategories = [CategoryCoreData]()
    var themeData = [Themes]()
    var arrItems = [ItemsCoreData]()
    //var listCategories = [CategoryCoreData]()
    //var listImages = [ItemsCoreData]()
    //var listVideo = [[String:AnyObject]]()
    
    //MARK:  -Outlets
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var collClassic: UICollectionView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var imgBack: UIImageView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        let getValue = UserDefaults.standard.value(forKey: "lang") as? String
        switch  getValue
        {
        case "eng": self.btnHome.setTitle("< BACK", for: .normal)
        case "ara": self.btnHome.setTitle("الى الخلف", for: .normal)
        case "cha":self.btnHome.setTitle("<返回", for: .normal)
        case "ira":self.btnHome.setTitle("<Ar ais", for: .normal)
        case "ita":self.btnHome.setTitle("<Indietro", for: .normal)
        case "fra":self.btnHome.setTitle("<Retour", for: .normal)
        case "ger":self.btnHome.setTitle("<Zurück", for: .normal)
        case "ban": self.btnHome.setTitle("<পিছনে", for: .normal)
        case "hin":self.btnHome.setTitle("< वापस", for: .normal)
        case "phil":self.btnHome.setTitle("<Balik", for: .normal)
        case "urd":self.btnHome.setTitle("<واپس", for: .normal)
        case "kor":self.btnHome.setTitle("<뒤로", for: .normal)
        case "spa":self.btnHome.setTitle("<Volver", for: .normal)
        case "sri":self.btnHome.setTitle("<ආපසු", for: .normal)
        case "tur":self.btnHome.setTitle("<Geri", for: .normal)
        default:self.btnHome.setTitle("< BACK", for: .normal)
            
        }

        self.btnHome.layer.cornerRadius = 8
//        self.btnHome.layer.borderWidth = 1
    self.btnHome.titleLabel?.font = UIFont(name: "Calibri", size: 25)
    self.btnHome.isHidden = false
    UserDefaults.standard.synchronize()
        
        
        //        --============ NEW ===========--
        
        
        if (themeData[0].englishButton != nil)
        {
            self.btnHome.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            self.btnHome.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            self.btnHome.backgroundColor = UIColor.lightGray
            self.btnHome.setTitleColor(UIColor.black, for: .normal)
        }
        
        if themeData[0].fontColor == nil {
            btnHome.setTitleColor(UIColor.black, for: .normal)
        } else {
            btnHome.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
        }
        
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
        self.collClassic.collectionViewLayout.invalidateLayout()
    }
    //MARK: -Long Press
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
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
    @IBAction func btnLogoClick(_ sender: UIButton)
    {
        print("logo clickedfsdfkjklsdjfklj asdklfjdklsjfklsdjfajksflkadjsf")
    }
    
    @IBAction func btnHomeClick(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:     -Collectionview Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassicCollCell", for: indexPath) as! ClassicCollCell

        let CategoryDetails = self.arrCategories[indexPath.row]
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
        cell.lblPrice.text  = String(format:"%@ %@",strcurrency,"3.300")
        cell.lblPrice.textColor = cell.lblCatname.textColor
        cell.lblPrice.backgroundColor = UIColor.clear.withAlphaComponent(0.7)
        let txtfont  = UIFont(name:"Calibri-Bold",size: 30)
        let strNSAtt = NSAttributedString(string: cell.lblCatname.text!, attributes: [.font:txtfont!])
        let getHeight = strNSAtt.height(withConstrainedWidth: cell.lblCatname.frame.size.width)
        let intHeight = Int(getHeight)
        if intHeight > 60
        {
            cell.conlblCatHeight.constant = CGFloat(Float(getHeight) + 20)
        }
        else
        {
            cell.conlblCatHeight.constant = 40
        }
        cell.lblCatname.layoutIfNeeded()
        cell.lblCatname.updateConstraintsIfNeeded()
        
        let ItemsDetail = self.arrItems[indexPath.row]
        cell.imgCatName.layer.cornerRadius = 5
        cell.imgCatName.layer.borderWidth = 1
        cell.imgCatName.layer.borderColor = UIColor.clear.cgColor
        
        ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.imgCatName) { (_, error) in
            if error != nil {
                let placeholder = ImageLoader_SDWebImage.placeholder
                cell.imgCatName.image = placeholder
            }
            cell.imgCatName.isHidden = (error != nil)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: ((self.view.frame.size.width - 16) / 3) - 8  , height: self.collClassic.frame.size.height / 3.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let CategoryDetails: CategoryCoreData
        let cell = collectionView.cellForItem(at: indexPath) as! ClassicCollCell
        
        CategoryDetails = self.arrCategories[indexPath.row]
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FiniItemListVC") as! FiniItemListVC
        popOverVC.getCatId = CategoryDetails.catID
        popOverVC.strEngTitle = cell.lblCatname.text!
        //popOverVC.getCatName = CategoryDetails.catNameAra!
        navigationController?.pushViewController(popOverVC, animated: true)
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
    
    func downloadBrandImageLogo() {
        
        SkopelosClient.shared.read { context in
            let BrandID :Int32? = BrandViewController.Brandhelper.brandID;
            let predicate = NSPredicate(format: "brandID = \(NSNumber(value:BrandID!))")
            let items = Brands.SK_all(predicate, context: context)
            var brandData = [Brands]()
            brandData = items;
            if brandData[0].currency == ""
            {
                self.strcurrency = "KD"
            }
            else
            {
                self.strcurrency = brandData[0].currency
            }
            brandData = items;
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.brandLogo) { (image, error) in
                self.brandLogo.isHidden = (image == nil)
            }
        }
    }
    func downloadThemes(ThemeID: Int32) {
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: self.imgBack)
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


            }
        else{
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

