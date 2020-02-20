//
//  FiniItemListVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 7/31/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import AVKit

class FiniItemListVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate,AVPlayerViewControllerDelegate
{
    
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collThumbnail: UICollectionView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblCatname: UILabel!
    
    
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
    
    var strEngTitle:String!
    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!
    var getCatId = Int32()
    var getCatName = String()
    @IBAction func btnLogoClick(_ sender: UIButton)
        
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        
        
//        MITESH
//        let objVC: Slideshow1Vc? = storyboard?.instantiateViewController(withIdentifier: "Slideshow1Vc") as? Slideshow1Vc
//        objVC?.strIsCome = "Classiclayout"
//        objVC?.selectedIndex = self.selectedIndex
//        let aObjNavi = UINavigationController(rootViewController: objVC!)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = aObjNavi
//        aObjNavi.isNavigationBarHidden = true
        
        
    }
    
    
    struct Language {
        static var language = "";
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
    var themeData = [Themes]()
    var arrFeedBack :NSMutableArray!
    var arrStarFeedBack :NSMutableArray!
    var arrRadioFeedBack :NSMutableArray!
    var arrTextFeedBack :NSMutableArray!
    
    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
    }
    @IBAction func btnbackClick(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectItemIndex = 0
        self.GetItems(CatID: getCatId)
                UserDefaults.standard.set(1, forKey: "id")
                UserDefaults.standard.synchronize()
            self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo();
  let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as? String
        self.btnBack.titleLabel?.font = UIFont(name: "Calibri", size: 25)

        lblCatname.text = strEngTitle
        let getValue = UserDefaults.standard.value(forKey: "lang") as? String
        switch  getValue
        {
        case "eng": self.btnBack.setTitle("< BACK", for: .normal)
        case "ara": self.btnBack.setTitle("الى الخلف", for: .normal)
        case "cha":self.btnBack.setTitle("<返回", for: .normal)
        case "ira":self.btnBack.setTitle("<Ar ais", for: .normal)
        case "ita":self.btnBack.setTitle("<Indietro", for: .normal)
        case "fra":self.btnBack.setTitle("<Retour", for: .normal)
        case "ger":self.btnBack.setTitle("<Zurück", for: .normal)
        case "ban": self.btnBack.setTitle("<পিছনে", for: .normal)
        case "hin":self.btnBack.setTitle("< वापस", for: .normal)
        case "phil":self.btnBack.setTitle("<Balik", for: .normal)
        case "urd":self.btnBack.setTitle("<واپس", for: .normal)
        case "kor":self.btnBack.setTitle("<뒤로", for: .normal)
        case "spa":self.btnBack.setTitle("<Volver", for: .normal)
        case "sri":self.btnBack.setTitle("<ආපසු", for: .normal)
        case "tur":self.btnBack.setTitle("<Geri", for: .normal)
        default:self.btnBack.setTitle("< BACK", for: .normal)
            
        }

        //Feedback
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
        
        if (themeData[0].englishButton != nil)
        {
            self.btnBack.backgroundColor  = self.colorWithHexString(hex: themeData[0].englishButton!)
            self.btnBack.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            self.btnBack.backgroundColor = UIColor.lightGray
            self.btnBack.setTitleColor(UIColor.black, for: .normal)
        }
        
        let str4 = themeData[0].fontColor
        
        btnBack.layer.cornerRadius = 8
        
        if  (str4 == nil || str4!.isEmpty)
        {
            lblCatname.textColor  = UIColor.black
            
        }
            
        else
        {
            let color1 = colorWithHexString(hex: themeData[0].fontColor!)
            lblCatname.textColor = color1
            btnBack.setTitleColor(color1, for: .normal)
            btnBack.layer.borderColor = color1.cgColor
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        
        let CurrentLanguage = Language.language;
        

    }
    
    var listCategory = [ItemsCoreData]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return  listItems.count //listVideo
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell = collThumbnail.dequeueReusableCell(withReuseIdentifier: "ClassicCollCell", for: indexPath) as! ClassicCollCell
                cell.layer.cornerRadius = 3.0
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.clipsToBounds = true
        
                let ItemsDetail = self.listItems[indexPath.row]
                ItemDetails.itemPosition = indexPath
                cell.lblPrice.text = String(format: "%@ %@", strcurrency,ItemsDetail.price!)
              
                let str = themeData[0].fontColorPrice
                let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as? String
                let str1111 = themeData[0].itemBackgroundColor
                
                if  (str1111 == nil || str1111!.isEmpty)
                {
                    cell.lblCatname.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                    cell.lblPrice.backgroundColor = UIColor.white.withAlphaComponent(0.7)

                }
                    
                else
                {
                    let color1 = colorWithHexString(hex: themeData[0].itemBackgroundColor!)
                    cell.lblCatname.backgroundColor  = color1.withAlphaComponent(0.6)
                    cell.lblPrice.backgroundColor  = color1.withAlphaComponent(0.6)

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
            let txtfont = UIFont(name: "Calibri-Bold", size: 22)!
                let str1 = themeData[0].fontColorItemName
                
                if   (str1 == nil || str1!.isEmpty)
                {
                    cell.lblCatname.textColor = UIColor.black
                }
                else
                {
                    let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
                    cell.lblCatname.textColor  = color1
                }
        var getValue : String!

        if UserDefaults.standard.value(forKey: "lang") as?  String == nil
        {
            cell.lblCatname.text=ItemsDetail.itemName;
            
        }
            
        else
        {
            getValue = UserDefaults.standard.value(forKey: "lang") as? String
            switch  getValue
            {
            case "eng": cell.lblCatname.text = ItemsDetail.itemName
                
            case "ara": cell.lblCatname.text = ItemsDetail.itemNameAr
                
            case "cha": cell.lblCatname.text = ItemsDetail.itemNameChinese
                
            case "ira":cell.lblCatname.text = ItemsDetail.itemNameIranian
                
            case "ita":cell.lblCatname.text = ItemsDetail.itemNameItalian
                
            case "fra":cell.lblCatname.text = ItemsDetail.itemNameFrench
                
            case "ger":cell.lblCatname.text = ItemsDetail.itemNameGermany
                
            case "ban": cell.lblCatname.text = ItemsDetail.itemNamebangladeshi
                
            case "hin":cell.lblCatname.text = ItemsDetail.itemNameHindi
                
            case "phil":cell.lblCatname.text = ItemsDetail.itemNamePhilippines
                
            case "urd":cell.lblCatname.text = ItemsDetail.itemNameUrdu
                
            case "kor":cell.lblCatname.text = ItemsDetail.itemNameKorean
                
            case "spa":cell.lblCatname.text = ItemsDetail.itemNameSpain
                
            case "sri":cell.lblCatname.text = ItemsDetail.itemNameSrilanka
                
            case "tur":cell.lblCatname.text = ItemsDetail.itemNameTurkish
                
            default:cell.lblCatname.text = ItemsDetail.itemName
                
            }
            
        }
            cell.imgCatName.isHidden = false
            cell.viewVideoItem.isHidden = true
        let strNSAtt = NSAttributedString(string: cell.lblCatname.text!, attributes: [.font:txtfont])
        let getHeight = strNSAtt.height(withConstrainedWidth: cell.lblCatname.frame.size.width)
        let intHeight = Int(getHeight)
        if intHeight > 27
        {
            cell.conlblCatHeight.constant = CGFloat(Float(getHeight) + 45)
        }
        else
        {
            cell.conlblCatHeight.constant = 50
        }
        cell.lblCatname.layoutIfNeeded()
        cell.lblCatname.updateConstraintsIfNeeded()
        
        ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.imgCatName) { (_, error) in
            cell.imgCatName.isHidden = (error != nil)
        }
        return cell
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let CategoryDetails = self.listItems[indexPath.row]
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "FiniItemDetailVC") as! FiniItemDetailVC
        popOverVC.selectedIndex = Int(CategoryDetails.itemSeq)
        popOverVC.strCome = "item"
        popOverVC.getCatId = self.getCatId
        navigationController?.pushViewController(popOverVC, animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (self.collThumbnail.frame.size.width / 3) - 10, height: self.collThumbnail.frame.size.height / 3.5)
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
            
            return UIImage(named: "NoImage")!
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
            
            //DispatchQueue.main.async {
                self.collThumbnail.reloadData()
           // }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
            if listVideo.count > 0
            {
                
                let cell11 = cell as? ClassicCollCell
                
                let ItemsDetail = self.listVideo[(indexPath.row)]
                
                let str123 = ItemsDetail["video"] as? String
                if cell11?.viewVideoItem.isHidden == false
                {
                    avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: str123!))
                    avPlayerController.player = avPlayer
                    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: (cell11?.imgCatName.frame.size.width)!, height: (cell11?.imgCatName.frame.size.height)!)
//                    avPlayerController.showsPlaybackControls = true
                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
                    cell11?.viewVideoItem.isUserInteractionEnabled  = false
                    cell11?.viewVideoItem.addSubview(avPlayerController.view)
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
        if(Language.language=="ara")
        {
            CategoryName = CategoryList.catNameAra
        }
        else if (Language.language=="eng"){
            CategoryName = CategoryList.catNameEng
        }
        else {
            CategoryName = CategoryList.catNameEng
        }
        return CategoryName!;
    }
    func ItemName (ItemList : ItemsCoreData) ->String {
        var itemName : String? = "" ;
        if(Language.language=="ara")
        {
            itemName = ItemList.itemNameAr
        }
        else if (Language.language=="eng"){
            itemName = ItemList.itemName
        }
        else {
            itemName = ItemList.itemName
        }
        return itemName!;
    }
    func ItemName1 (ItemList : Extra) ->String {
        var itemName : String? = "" ;
        if(Language.language=="ara")
        {
            itemName = ItemList.extraNameArabic
        }
        else if (Language.language=="eng"){
            itemName = ItemList.extraName
        }
        else {
            itemName = ItemList.extraName
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
            
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.brandLogo) { (image, _) in
                if let img = image {
                    self.brandLogo.image = img
                } else {
                    self.brandLogo.isHidden = true
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
            ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: self.imgBack)
        }
    }
    
}
//extension FiniItemListVC: CollectionViewCellDelegate
//{
//    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
//        // You have the cell where the touch event happend, you can get the indexPath like the below
//        let indexPath = self.collThumbnail.indexPath(for: cell)
//        let items  = self.listVideo[(indexPath?.row)!]
//        PortraitModeVC.ItemDetails.itemPosition = indexPath!
//        // ItemViewControllerLayoutDVC.ItemDetails.strCome = "layoutD"
//        PortraitModeVC.ItemDetails.strPassitemId = items["itemSeq"] as! Int32
//    }
//}
