//
//  FiniItemDetailVC.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 8/1/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit

class FiniItemDetailVC: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate,AVPlayerViewControllerDelegate
{
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collThumbnail: UICollectionView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var collDetail: UICollectionView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewPlayVideo: UIView!
    @IBOutlet weak var btnfav: UIButton!

    var btnplayTag:Int = 0
    var strPlay:String!
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
    var timer = Timer()
//    var arrThumbNail = [[String:AnyObject]]()
    var listVideo = [[String:AnyObject]]()
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()
    var isVideo : Bool = false
    var arrCheck = [ItemsCoreData]()
    var listItems1 = [ItemsCoreData]()
    var getCatId:Int32!

    var strfb:String!
    var strinsta:String!
    var strcurrency:String!
    var strcall:String!
    
    @IBAction func btnLogoClick(_ sender: UIButton)
        
    {
        //self.performSegue(withIdentifier: "SlideSegue", sender: nil)
        let objVC: Slideshow1Vc? = storyboard?.instantiateViewController(withIdentifier: "Slideshow1Vc") as? Slideshow1Vc
        objVC?.strIsCome = "portrait"
        objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }

    @IBAction func btnCloseClick(_ sender: UIButton)
    {
        avPlayer.pause()
        self.viewVideo.isHidden = true
        //DispatchQueue.main.async {
            self.collDetail.layoutIfNeeded()
            self.collThumbnail.layoutIfNeeded()
        //}
    }
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
    

    @IBAction func btnBackClick(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //selectItemIndex = Int(self.getCatId)
        self.viewVideo.isHidden = true
       self.btnClose.isHidden = true
    
        
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
        self.btnBack.titleLabel?.font = UIFont(name: "Calibri", size: 25)
        
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
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo();
        self.GetItems(CatID: self.getCatId)
        

    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)

    }
    
    var listCategory = [ItemsCoreData]()
    //MARK:- Collection Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if (collectionView == self.collThumbnail)
        {
            return arrThumbNail.count
        }
        else{
            return listItems.count //listVideos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if (collectionView == collThumbnail)
        {
            
            let cell = collThumbnail.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
         //   let ItemsDetail: ItemsCoreData
           let  ItemsDetail = self.arrThumbNail[indexPath.row]
            ItemDetails.itemPosition = indexPath
            cell.lblThumbnailName.text! = (ItemsDetail.itemName!)
            let str1 = themeData[0].fontColorIngName
            if   (str1 == nil || str1!.isEmpty)
            {
                cell.lblThumbnailName.textColor = UIColor.black
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorIngName!)
                cell.lblThumbnailName.textColor  = color1
            }
  let currentLanguage = UserDefaults.standard.value(forKey: "lang") as? String
            if(currentLanguage == "ara")
            {
                cell.lblThumbnailName.text! = ItemsDetail.itemNameAr!
            }else
            {
                cell.lblThumbnailName.text = ItemsDetail.itemName!
            }
            
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.imgThumbnail)
            
            if cell.isSelected
            {
                cell.viewThumbnail.layer.borderColor = UIColor.black.cgColor
                cell.viewThumbnail.layer.borderWidth = 2
                cell.viewThumbnail.layer.cornerRadius = 5
            }
            else
            {
                cell.viewThumbnail.layer.cornerRadius = 5.0
                cell.viewThumbnail.layer.borderWidth = 2
                cell.viewThumbnail.layer.borderColor = UIColor.clear.cgColor
            }
            return cell
        }
            
            //MARK:- Second Cell
        else
         {
                        let cell = collDetail.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell;
                        let ItemsDetail = self.listItems[indexPath.row]
                        ItemDetails.itemPosition = indexPath
                        cell.lblPrice.text = String(format: "%@ %@", strcurrency,(ItemsDetail.price)!)
                        let str = themeData[0].fontColorIngName
                        let str12345 = themeData[0].fontColorIngName!
                        if   (str == nil || str!.isEmpty)
                        {
                            cell.lblPrice.textColor = UIColor.black
                        }
                        else
                        {
                            let color1 = colorWithHexString(hex: themeData[0].fontColorIngName!)
                            cell.lblPrice.textColor  = color1
                        }
                        if   (str12345 == nil || str12345.isEmpty)
                        {
                            cell.txtIngrident.textColor = UIColor.black
                            cell.lblItemName.textColor = UIColor.black
                        }
                        else
                        {
                            let color1 = colorWithHexString(hex: themeData[0].fontColorIngName!)
                            cell.txtIngrident.textColor  = color1
                            cell.lblItemName.textColor  = color1
                        }
            if UserDefaults.standard.value(forKey:"strTackingOrder") as? String == "yes"
            {
                cell.btnFav.isHidden = true
                cell.viewQuantity.isHidden = false
            }
            else
            {
                cell.btnFav.isHidden = false
                cell.viewQuantity.isHidden = true
            }
            if ItemsDetail.qty > 0
            {
                cell.lblQuantity.text = String(format: "%d", ItemsDetail.qty)
            }
            else
            {
                cell.lblQuantity.text = "ADD"
            }
            var getValue : String!
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                cell.lblItemName.text = ItemsDetail.itemName
                cell.txtIngrident.text = ItemsDetail.ingredientEng

            }
                
            else
            {
                
                getValue = UserDefaults.standard.value(forKey: "lang") as? String
                switch  getValue
                {
                case "eng":cell.lblItemName.text = ItemsDetail.itemName
                cell.txtIngrident.text = ItemsDetail.ingredientEng

                case "ara": cell.lblItemName.text = ItemsDetail.itemNameAr
                cell.txtIngrident.text = ItemsDetail.ingredientAra

                case "cha":cell.lblItemName.text = ItemsDetail.itemNameChinese
                cell.txtIngrident.text = ItemsDetail.ingredientChinese
                    
                case "ira":cell.lblItemName.text = ItemsDetail.itemNameIranian
                cell.txtIngrident.text = ItemsDetail.ingredientIranian
                    
                case "ita":cell.lblItemName.text = ItemsDetail.itemNameItalian
                cell.txtIngrident.text = ItemsDetail.ingredientItalian
                    
                case "fra":cell.lblItemName.text = ItemsDetail.itemNameFrench
                cell.txtIngrident.text = ItemsDetail.ingridentFrench
                    
                case "ger":cell.lblItemName.text = ItemsDetail.itemNameGermany
                cell.txtIngrident.text = ItemsDetail.ingridentGermany
                    
                case "ban": cell.lblItemName.text = ItemsDetail.itemNamebangladeshi
                cell.txtIngrident.text = ItemsDetail.ingredientBangladeshi
                    
                case "hin":cell.lblItemName.text = ItemsDetail.itemNameHindi
                cell.txtIngrident.text = ItemsDetail.ingridentHindi
                    
                case "phil":cell.lblItemName.text = ItemsDetail.itemNamePhilippines
                cell.txtIngrident.text = ItemsDetail.ingredientPhilippines
                    
                case "urd":cell.lblItemName.text = ItemsDetail.itemNameUrdu
                cell.txtIngrident.text = ItemsDetail.ingredientUrdu
                    
                case "kor":cell.lblItemName.text = ItemsDetail.itemNameKorean
                cell.txtIngrident.text = ItemsDetail.ingredientKorean
                    
                case "spa":cell.lblItemName.text = ItemsDetail.itemNameSpain
                cell.txtIngrident.text = ItemsDetail.ingredientSpain
                    
                case "sri":cell.lblItemName.text = ItemsDetail.itemNameSrilanka
                cell.txtIngrident.text = ItemsDetail.ingredientSrilanka
                    
                case "tur":cell.lblItemName.text = ItemsDetail.itemNameTurkish
                cell.txtIngrident.text = ItemsDetail.ingredientTurkish
                    
                default:cell.lblItemName.text = ItemsDetail.itemName
                cell.txtIngrident.text = ItemsDetail.ingredientEng
                    
                }
            
        }
                        cell.txtIngrident.font = UIFont(name: "Calibri", size: 22)
                        //cell.viewDesc.backgroundColor = self.colorWithHexString(hex: )
                        cell.ImgItem.isHidden = false
                        cell.videoItem.isHidden = true
                        cell.lblPrice.font  = UIFont(name:"Calibri-Bold",size: 27)
                        cell.lblItemName.font  = UIFont(name:"Calibri-Bold",size: 30)
                        let strNSAtt = NSAttributedString(string: cell.txtIngrident.text, attributes: [.font:cell.txtIngrident.font!])
                        let strNSAtt1 = NSAttributedString(string: cell.lblItemName.text!, attributes: [.font:cell.lblItemName.font!])
            
                        let getHeight = strNSAtt.height(withConstrainedWidth: cell.txtIngrident.frame.size.width)
                        let getHeight1 = strNSAtt1.height(withConstrainedWidth: cell.lblItemName.frame.size.width)
                        let intHeight1 = Int(getHeight1)
            
                        let intHeight = Int(getHeight)
                        if intHeight1 > 30
                        {
                            cell.conlblNameHeight.constant = getHeight1 + 10
            
                        }
                        else
                        {
                            cell.conlblNameHeight.constant = 30
            
                        }
                        if intHeight > 41
                        {
                            cell.contxtDescHeight.constant = getHeight + 20
                        }
                        else
                        {
                             cell.contxtDescHeight.constant = 120
                        }
                        cell.conViewDestHeight.constant = cell.contxtDescHeight.constant + cell.conlblNameHeight.constant + 30
                        let str123 = ItemsDetail.video
                        for i in 0..<self.listItems.count
                        {
                            let dict1 = self.listItems[i]
                            if ItemsDetail.itemID  == dict1.itemID
                            {
                                if (str123 != ""  && str123 != "" )
                                {
                                    strPlay = str123
                                    cell.imgPlay.isHidden = false
                                    avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: strPlay!))
                                    avPlayerController.player = avPlayer
                                    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: cell.videoItem.frame.size.width, height: cell.videoItem.frame.size.height)
                                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
                                    avPlayerController.showsPlaybackControls = true
                                    cell.videoItem.addSubview(avPlayerController.view)

                                }
                                else
                                {
                                    cell.imgPlay.isHidden = true
                                    cell.videoItem.isHidden = true

                                }
                            }
                            else
                            {
                                cell.imgPlay.isHidden = true
                                cell.videoItem.isHidden = true

                            }
                        }
            
            ImageLoader_SDWebImage.setImage(ItemsDetail.imageName, into: cell.ImgItem)
            cell.txtIngrident.layoutIfNeeded()
            cell.txtIngrident.updateConstraintsIfNeeded()
            cell.viewDesc.layoutIfNeeded()
            cell.viewDesc.updateConstraintsIfNeeded()
            cell.btnPlay.tag = indexPath.item
            cell.btnFav.tag = indexPath.item
            cell.btnPlus.tag = indexPath.item
            cell.btnMinus.tag = indexPath.item

            cell.btnPlay.addTarget(self, action: #selector(btnPlay(_:)), for: .touchUpInside)
            cell.btnPlus.addTarget(self, action: #selector(btnplusClick(_:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(btnminusClick(_:)), for: .touchUpInside)
            cell.btnFav.addTarget(self, action: #selector(btnFavClick(_:)), for: .touchUpInside)

            return cell

        }

    }
    @objc func btnFavClick(_ sender: UIButton)
    {
        let btn = sender
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
    
    @IBAction func btnFavouriteClick(_ sender: UIButton)
    {
        self.btnfav.isSelected = true
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "fav1vc") as! fav1vc
        popOverVC.strIsCome = "fini"
        popOverVC.selectedIndex = self.selectedIndex
        navigationController?.pushViewController(popOverVC, animated: true)
        
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
            
            self.listImages = items
            if self.listImages.count > 0
            {
                // listVideo.removeAll()
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
                }
            }
            
            self.collDetail.reloadData()
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
                    Qty = Qty - 1
                    dict.qty = Int32(Qty)
                }
            }
            
            self.listImages = items
            if self.listImages.count > 0
            {
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
                }
            }
            
            self.collDetail.reloadData()
        }
    }

    @objc func btnPlay(_ sender: UIButton)
    {
        let btn = sender
        btnplayTag = sender.tag
        let cell = self.collDetail.cellForItem(at: IndexPath(item: btn.tag, section: 0)) as! ItemsCollectionViewCell
        cell.videoItem.isHidden = false
        cell.imgPlay.isHidden = true
     //   self.viewVideo.isHidden = false
        avPlayer.play()
    }

    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        let cell = self.collDetail.cellForItem(at: IndexPath(item: btnplayTag, section: 0)) as! ItemsCollectionViewCell
        cell.videoItem.isHidden = true
        cell.imgPlay.isHidden = false
        //   self.viewVideo.isHidden = false
        avPlayer.pause()
        avPlayer = AVPlayer()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collThumbnail.collectionViewLayout.invalidateLayout()

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
        
        let location = sender.location(in: self.collDetail)
        let indexPath = self.collDetail.indexPathForItem(at: location)
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            ItemDetails.itemPosition = indexPath!
            
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let orientationValue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationValue, forKey: "orientation")
       // self.GetItems(CatID: ItemDetails.CategoryID)

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
                self.GetItems(CatID: ItemDetails.CategoryID)
                //self.GetItems(CatID: self.getCatId)
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

            //let catID : Int32? = Int32(SelectedCategories.catID)
            let CatSeq: Int32? = Int32(SelectedCategories.itemSeq)
            UserDefaults.standard.synchronize()
            selectItemIndex = indexPath.item
                    cell.viewThumbnail.layer.borderColor = UIColor.black.cgColor
                    cell.viewThumbnail.layer.borderWidth = 2
                    cell.viewThumbnail.layer.cornerRadius = 5
            for i in 0..<self.listItems.count
            {
                let dic = self.listItems[i]
                let pos:Int32 = dic.itemSeq

                if CatSeq == pos
                {
                    
                    self.collDetail.scrollToItem(at:IndexPath(item:i, section: 0), at:.centeredHorizontally, animated: false)
                    avPlayer.pause()
                    //cell1.videoItem.isHidden = true
                    break
                }
            }

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collThumbnail.cellForItem(at:IndexPath(row: indexPath.item, section: 0)) as? ThumbnailCell  //IndexPath(row: selectItemIndex, section: 0)
        cell?.viewThumbnail.layer.borderColor = UIColor.clear.cgColor
        cell?.viewThumbnail.layer.borderWidth = 2
        cell?.viewThumbnail.layer.cornerRadius = 5
        //let black = UIColor.white // 1.0 alpha
      //  cell?.viewThumbnail.backgroundColor = UIColor.withAlphaComponent(black)(0.7)

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if (collectionView == self.collThumbnail)
        {
            
            let SelectedCategories =
                self.listItems[(indexPath.row)]
            let strName  = SelectedCategories.itemName
            var size = strName!.size(withAttributes: nil)
          //  var size = ItemName(ItemList: SelectedCategories).size(withAttributes: nil)
            if size.width > 100
            {
                
                size.height =  size.height + 100
                
            }
            return CGSize(width:(self.collThumbnail.frame.size.width/3.5) - 8,height: max(self.collThumbnail.frame.size.height, size.height))
        }
        else
        {
            
            
            //return CGSize(width: 466, height: 600)
            
            return CGSize(width:(self.view.frame.size.width), height:self.view.frame.size.height - 260)
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
    
    
    func GetItems(CatID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:CatID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            ItemDetails.CategoryID = CatID;
            self.listItems = items
            self.arrThumbNail = items
            self.listImages = items
            self.collDetail.layoutIfNeeded()
            if self.listItems.count > 0
            {
                self.collThumbnail.isHidden = false
                self.collThumbnail.reloadData()
                self.collThumbnail.layoutIfNeeded()

                for i in 0..<self.listItems.count
                {
                    let dic = self.listItems[i]
                    let pos:Int32 = dic.itemSeq
                    if self.selectedIndex == pos
                    {
                        self.collDetail.scrollToItem(at:IndexPath(item:i, section: 0), at:.centeredHorizontally, animated: false)
                        self.collThumbnail.scrollToItem(at:IndexPath(item:i, section: 0), at:.centeredHorizontally, animated: false)
                        self.collThumbnail.selectItem(at: IndexPath(item:i, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                        break
                    }
                }
                if UserDefaults.standard.value(forKey:"strTackingOrder") as?String == "yes"
                {
                    self.btnfav.isHidden = false
                    self.btnfav.backgroundColor = UIColor.white
                    self.btnfav.setImage(UIImage(named:"cart"), for: .normal)
                    self.btnfav.setImage(UIImage(named:"cart"), for: .selected)
                    
                }
                else
                {
                    self.btnfav.isHidden = true
                    self.btnfav.backgroundColor = UIColor.clear
                    self.btnfav.setBackgroundImage(UIImage(named: "fav"), for: .normal)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        avPlayer.pause()

//        DispatchQueue.main.async
//            {
                
                                if scrollView == self.collDetail
                                {
                                    if self.collDetail.visibleCells.count > 0
                                    
                                    {
                                        let cell: ItemsCollectionViewCell? = self.collDetail.visibleCells[0] as? ItemsCollectionViewCell
                                        var index: IndexPath? = nil
                                        if let aCell = cell
                                        {
                                            index = self.collDetail.indexPath(for: aCell)
                                        }
                
                                        for i in 0..<self.listItems.count
                                        {
                                            let dic = self.listItems[(index?.item)!]
                                            let pos:Int32 = (dic.itemSeq)
                                            let SelectedCategories =
                                                self.arrThumbNail[i]
                                            let CatSeq: Int32? = Int32(SelectedCategories.itemSeq)//SelectedCategories.itemSeq
                
                                            if CatSeq == pos
                                            {
                                                self.collThumbnail.reloadData()
                                                //self.collThumbnail.layoutIfNeeded()
                                                self.collThumbnail.selectItem(at: IndexPath(item:i, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                                                break
                                            }
                                        }
                                    }
                                }

       // }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collDetail
        {
            avPlayer.pause()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView == collDetail
        {
            if listItems.count > 0
            {

                let cell11 = cell as? ItemsCollectionViewCell

                let ItemsDetail = self.listItems[indexPath.row]

                let str123 = ItemsDetail.video!
                cell11?.videoItem.isHidden = true
                
                        for i in 0..<self.listItems.count
                        {
                            let dict1 = self.listItems[i]
                            if ItemsDetail.itemID  == dict1.itemID
                            {
                                if (str123 != ""  && str123 != "" )
                                {
                                    strPlay = str123
                                    cell11?.imgPlay.isHidden = false
                                    avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: strPlay!))
                                    avPlayerController.player = avPlayer
                                    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: (cell11?.videoItem.frame.size.width)!, height: (cell11?.videoItem.frame.size.height)!)
                                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
                                    avPlayerController.showsPlaybackControls = false
                                    cell11?.videoItem.addSubview(avPlayerController.view)
                
                                }
                                else
                                {
                                    cell11?.imgPlay.isHidden = true
                                    cell11?.videoItem.isHidden = true
                
                                }
                            }
                
//                if cell11?.videoItem.isHidden == false
//                {
//                    avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: str123))
//                    avPlayerController.player = avPlayer
//                    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: (cell11?.ImgItem.frame.size.width)!, height: (cell11?.ImgItem.frame.size.height)!)
//                    avPlayerController.showsPlaybackControls = true
//                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
//                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
//                    cell11?.videoItem.addSubview(avPlayerController.view)
//                }

            }
        }
        
        }
//        let str123 = ItemsDetail.video
        
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
    func ItemName (ItemList : ItemsCoreData) ->String
    {
        var itemName : String? = "" ;
        var getValue : String!
        if UserDefaults.standard.value(forKey: "lang") as?  String == nil
        {
            itemName = ItemList.itemName
            return itemName!;
            
        }
            
        else
        {
            
            getValue = UserDefaults.standard.value(forKey: "lang") as? String
            switch  getValue
            {
            case "eng": itemName = ItemList.itemName
            case "ara": itemName = ItemList.itemNameAr
            case "cha":itemName = ItemList.itemNameChinese
            case "ira":itemName = ItemList.itemNameIranian
            case "ita":itemName = ItemList.itemNameItalian
            case "fra":itemName = ItemList.itemNameFrench
            case "ger":itemName = ItemList.itemNameGermany
            case "ban": itemName = ItemList.itemNamebangladeshi
            case "hin":itemName = ItemList.itemNameHindi
            case "phil":itemName = ItemList.itemNamePhilippines
            case "urd":itemName = ItemList.itemNameUrdu
            case "kor":itemName = ItemList.itemNameKorean
            case "spa":itemName = ItemList.itemNameSpain
            case "sri":itemName = ItemList.itemNameSrilanka
            case "tur":itemName = ItemList.itemNameTurkish
            default:itemName = ItemList.itemName
                
            }
            if itemName == "" || itemName == nil
            {
                itemName = ""
                return itemName!
            }
            else
            {
                return itemName!;
                
            }
            
        }

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
            
            let str1  = self.themeData[0].itemBackgroundColor!
            let btnfont = UIFont(name: "Calibri", size: 25)
            self.btnBack.titleLabel?.font = btnfont
            
            
//            --===== NEW =====--
            
            
            if (self.themeData[0].englishButton != nil)
            {
                self.btnBack.backgroundColor = self.colorWithHexString(hex: self.themeData[0].englishButton!)
                self.btnfav.backgroundColor = self.colorWithHexString(hex: self.themeData[0].englishButton!)
            }
            else
            {
                self.btnBack.backgroundColor = UIColor.lightGray
                self.btnBack.titleLabel?.textColor = UIColor.black
                self.btnfav.backgroundColor = UIColor.lightGray
                
            }
            
            let strGet  = (self.themeData[0].fontColor)
            
            
            //            --===== OLD =====--
            if strGet != nil
            {
                
                self.btnBack.setTitleColor(self.colorWithHexString(hex: self.themeData[0].fontColor!), for: .normal)
            }
            else
            {
                //                self.btnBack.layer.borderColor = UIColor.black.cgColor
                self.btnBack.setTitleColor(UIColor.black, for: .normal)
                
            }
            
            
            if !(str1.isEmpty)
            {
                self.imgBg.backgroundColor = self.colorWithHexString(hex: self.themeData[0].itemBackgroundColor!)
            }
            else
            {
                ImageLoader_SDWebImage.setImage(self.themeData[0].background, into: self.imgBg)
            }
            self.btnBack.layer.cornerRadius = 8
//            self.btnBack.layer.borderWidth = 1

        }
        
        
    }
    
}

//extension FiniItemDetailVC: CollectionViewCellDelegate
//{
//    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
//        // You have the cell where the touch event happend, you can get the indexPath like the below
//        let indexPath = self.collDetail.indexPath(for: cell)
//        let items  = self.arrThumbNail[(indexPath?.row)!]
//        PortraitModeVC.ItemDetails.itemPosition = indexPath!
//        // ItemViewControllerLayoutDVC.ItemDetails.strCome = "layoutD"
//        PortraitModeVC.ItemDetails.strPassitemId = items.itemSeq
//
//        //        let items  = self.listItems[(indexPath?.row)!]
//        //        // Call `performSegue`
//        //        ItemViewControllerLayoutDVC.ItemDetails.itemPosition = indexPath!
//        //        ItemViewControllerLayoutDVC.ItemDetails.strCome = "layoutD"
//        //        ItemViewControllerLayoutDVC.ItemDetails.strPassitemId = items.itemSeq
//        //        self.performSegue(withIdentifier: "itemsDetailViewSegue", sender: nil)
//    }
//}
