//
//  ItemDetailsViewController.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 10/2/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVKit
import AVFoundation
import MediaPlayer

@available(iOS 11.0, *)
class ItemDetailsViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate
{
    var listItems = [ItemsCoreData]()
    var DummyItems = [[String:AnyObject]]()
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()
    var listCategories = [CategoryCoreData]()
    var Categories = [CategoryViewData]()
    var themeData = [Themes]()
    var listImages = [ItemsCoreData]()
    var listExtra = [Extra]()
    var listVideo = [[String:AnyObject]]()
    var chengeArr = [[String:AnyObject]]()
    var getPage:Int = 0
    var getIp = String()
    var getPort = Int32()
    var CategoryID :Int32!
    var getfetchItemId:Int32!
    var getfetchBrandId:Int32!
    var getItemID = Int32()
    var getId:Int32!
    
    
    struct slideDetail {
        static var imageName = String()
        
    }
    struct Language {
        static var language = "eng";
    }

     @IBOutlet weak var itemsDetail: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var collExtra: UICollectionView!
    @IBOutlet weak var conCollExtraWidth: NSLayoutConstraint!
    @IBOutlet weak var viewExtra: UIView!
    @IBOutlet weak var viewTap: UIView!

    var arrSlide = [SlideShow]()
    var timer = Timer()

    @IBAction func closeBtn(_ sender: Any) {
        
            navigationController?.popViewController(animated: true)
    }
     @IBAction func btnSlideShowClick(_ sender: Any)
     {
        self.performSegue(withIdentifier: "SlideSegue", sender: nil)

    }
    

    @IBAction func btnNextClick(_ sender: Any)
    {
        
        if itemsDetail.visibleCells.count > 0
        {
            
            avPlayer.pause()
            avPlayerController.player = nil
            let cell: ItemsCollectionViewCell? = itemsDetail.visibleCells[0] as! ItemsCollectionViewCell

            var index: IndexPath? = nil
            
            if let aCell = cell {
                index = itemsDetail.indexPath(for: aCell)
            }

            if (index?.row ?? 0) + 1 < self.listVideo.count
            {
                itemsDetail.scrollToItem(at: IndexPath(row: (index?.row ?? 0) + 1, section: 0), at: .right, animated: true)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView == collExtra
        {
            
        }
        else
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
                fetchExtraData(passid: ItemsDetail["itemSeq"] as! Int32, completion: {(success) in
                    if self.listExtra.count > 0
                    {
                        DispatchQueue.main.async {
                            cell11?.btnChoice.isHidden = false
                            cell11?.conbtnchoiceWidth.constant = 130
                        }
                        
                    }
                    else
                    {
                        // self.listExtra = items
                        cell11?.btnChoice.isHidden = true
                        
                    }
                    
                })
                
            }
        }
       
    }
    
    @IBAction func btnPreClick(_ sender: Any)
    {
        if itemsDetail.visibleCells.count > 0
        {
            avPlayer.pause()
            avPlayerController.player = nil
            var cell: ItemsCollectionViewCell? = itemsDetail.visibleCells[0] as! ItemsCollectionViewCell
            var index: IndexPath? = nil
            if let aCell = cell {
                index = itemsDetail.indexPath(for: aCell)
            }

            if (index?.row ?? 0) < self.listVideo.count
            {
                itemsDetail.scrollToItem(at: IndexPath(row: (index?.row ?? 0) - 1, section: 0), at: .left, animated: true)
            }
        }

    }
    func setCollectionArrow()
    {
     avPlayer.pause()

        let pageWidth: CGFloat
        pageWidth  = itemsDetail.frame.size.width
        btnPre.isHidden = true
        let page : NSInteger  = NSInteger(itemsDetail.contentOffset.x / pageWidth)
        let CurrentLanguage =  UserDefaults.standard.value(forKey: "lang") as? String


        pageView.currentPage = page
        getPage = page
        if page == 0
        {
            if CurrentLanguage == "ara"
            {
                btnPre.isHidden = false
                btnNext.isHidden = true
            }
            else
            {
                btnPre.isHidden = true
                btnNext.isHidden = false
            }
        }
        else if page == self.listVideo.count - 1
        {
            if CurrentLanguage == "ara"
            {
                btnPre.isHidden = true
                btnNext.isHidden = false
            }
            else
            {
                btnPre.isHidden = false
                btnNext.isHidden = true
            }
        }
        else
        {
            btnPre.isHidden = false
            btnNext.isHidden = false
        }
        
    }
    func getSettingData()
    {
        
        SkopelosClient.shared.read { context in
            let Setting = SettingDataCore.SK_all(context)
            self.getIp = Setting[0].ipAddress!
            self.getPort = Setting[0].port
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       if collectionView == collExtra
       {
        return  listExtra.count
        }
     else
       {
        return  listVideo.count  //self.listItems.count

        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collExtra
        {
             var  language  = String()
            let cell = collExtra.dequeueReusableCell(withReuseIdentifier:"ThumbnailCell" , for: indexPath) as! ThumbnailCell
            let extraDetail:Extra
                  extraDetail = listExtra[indexPath.item]
            let CurrentLanguage =  UserDefaults.standard.value(forKey: "lang") as? String


                if CurrentLanguage == "eng"
                {
                    cell.lblThumbnailName.text = extraDetail.extraName
                }
                else
                {
                    cell.lblThumbnailName.text = extraDetail.extraNameArabic
                }
                cell.lblTotalPrice.text = String(format: "%@ KD", extraDetail.price!)
            
            ImageLoader_SDWebImage.setImage(extraDetail.imageName, into: cell.imgThumbnail) { (_, error) in
                if error != nil {
                    let placeholder = ImageLoader_SDWebImage.placeholder
                    cell.imgThumbnail.image = placeholder
                }
                cell.imgThumbnail.isHidden = (error != nil)
            }
                cell.viewThumbnail.layer.cornerRadius = 5
                cell.viewThumbnail.layer.borderColor  = UIColor.clear.cgColor
                cell.viewThumbnail.layer.borderWidth = 1
                return cell
            }
        else
        {
            let cell = itemsDetail.dequeueReusableCell(withReuseIdentifier: "ItemDetailsCell", for: indexPath) as! ItemsCollectionViewCell;
            //        let ItemsDetail: ItemsCoreData
            let ItemsDetail = self.listVideo[indexPath.row]
            cell.viewInner.clipsToBounds = true
            cell.btnChoice.isHidden = true

        if ItemsDetail["isCheck"] as? Int == 0
        {
            cell.viewOutofStock.isHidden = true
        }
        else
        {
            cell.viewOutofStock.isHidden = false
            cell.viewOutofStock.layer.cornerRadius = 4
            cell.viewOutofStock.layer.borderWidth = 2
            cell.viewOutofStock.clipsToBounds = true

        }
      //  cell.btnPlay.addTarget(self, action: #selector(btnVideoPlay(_:)), for: .touchUpInside)
        
            if ItemViewLayoutBVC.ItemDetails.strCome ==  "layoutB"
            {
                themeData = ItemViewLayoutBVC.ItemDetails.staticThemeData;
                
            }
            else if ItemViewLayoutCVC.ItemDetails.strCome ==  "layoutC"
            {
                themeData = ItemViewLayoutCVC.ItemDetails.staticThemeData;
                
            }
            else
            {
                themeData = ItemViewController.ItemDetails.staticThemeData;

            }
            let str4 = themeData[0].fontColorItemName
            
            if  (str4 == nil || str4!.isEmpty)
            {
                cell.lblItemName.textColor = UIColor.black
            }
                
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorItemName!)
                cell.lblItemName.textColor  = color1
                
            }
            
            let str5 = themeData[0].fontColorIngName
            
            if  (str5 == nil || str5!.isEmpty)
            {
                cell.txtIngrident.textColor  =  UIColor.black
            }
                
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorIngName!)
                cell.txtIngrident.textColor  = color1
            }
            
            let str6 = themeData[0].fontColorPrice
            
            if  (str6 == nil || str5!.isEmpty)
            {
                cell.lblPrice.textColor = UIColor.black
            }
            else
            {
                let color1 = colorWithHexString(hex: themeData[0].fontColorPrice!)
                cell.lblPrice.textColor  = color1
            }
            
        let imageView:UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
            ImageLoader_SDWebImage.setImage(self.themeData[0].popupBackground, into: imageView)
        cell.viewInner.addSubview(imageView)
        cell.viewInner.sendSubview(toBack: imageView)
            
            ImageLoader_SDWebImage.getImage(themeData[0].categoryActive) { (image, _) in
                let placeholder = ImageLoader_SDWebImage.placeholder
                cell.btnChoice.setBackgroundImage((image ?? placeholder), for: [])
            }
            
        cell.lblPrice.text = String(format: "%@ %@", UserDefaults.standard.value(forKey: "cur") as! String ,(ItemsDetail["price"] as? String)!)
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                cell.lblItemName.text = ItemsDetail["itemName"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientEng"] as? String;
                
            }
                
            else
            {
               let  getValue = UserDefaults.standard.value(forKey: "lang") as? String
                switch  getValue
                {
                  
                case "eng": cell.lblItemName.text = ItemsDetail["itemName"] as? String
               cell.txtIngrident.text = ItemsDetail["ingredientEng"] as? String;
                cell.btnChoice.setTitle("Choice", for: .normal)
               cell.lblOutofstock.text = "Out Of Stock!"

                case "ara": cell.lblItemName.text = ItemsDetail["itemNameAr"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientAra"] as? String
                cell.btnChoice.setTitle("خيار", for: .normal)
                cell.lblOutofstock.text = "إنتهى من المخزن!"

                case "cha": cell.lblItemName.text = ItemsDetail["itemNameChinese"]  as? String
                cell.txtIngrident.text = ItemsDetail["ingredientChinese"]  as? String
                cell.btnChoice.setTitle("選擇", for: .normal)
                cell.lblOutofstock.text = "缺貨！"
                    
                case "ira":cell.lblItemName.text = ItemsDetail["itemNameIranian"]  as? String
                cell.txtIngrident.text = ItemsDetail["ingredientIranian"]  as? String
                cell.btnChoice.setTitle("Rogha", for: .normal)
                cell.lblOutofstock.text = "As stoc!"
                    
                case "ita":cell.lblItemName.text = ItemsDetail["itemNameItalian"]  as? String
                cell.txtIngrident.text = ItemsDetail["ingredientItalian"]  as? String
                cell.btnChoice.setTitle("Scelta", for: .normal)
                cell.lblOutofstock.text = "Esaurito!"

                case "fra":cell.lblItemName.text = ItemsDetail["itemNameFrench"]  as? String
                cell.txtIngrident.text = ItemsDetail["ingridentFrench"]  as? String
                cell.btnChoice.setTitle("Choix", for: .normal)
                cell.lblOutofstock.text = "En rupture de stock!"

                case "ger":cell.lblItemName.text = ItemsDetail["itemNameGermany"] as? String
                cell.txtIngrident.text = ItemsDetail["ingridentGermany"] as? String
                cell.btnChoice.setTitle("Wahl", for: .normal)
                cell.lblOutofstock.text = "Ausverkauft!"

                case "ban": cell.lblItemName.text = ItemsDetail["itemNamebangladeshi"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientBangladeshi"] as? String
                cell.btnChoice.setTitle("পছন্দ", for: .normal)
                cell.lblOutofstock.text = "স্টক আউট!"

                case "hin":cell.lblItemName.text = ItemsDetail["itemNameHindi"] as? String
                cell.txtIngrident.text = ItemsDetail["ingridentHindi"] as? String ?? ""
                cell.btnChoice.setTitle("पसंद", for: .normal)
                cell.lblOutofstock.text = "अप्राप्य!"

                case "phil":cell.lblItemName.text = ItemsDetail["itemNamePhilippines"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientPhilippines"] as? String
                cell.btnChoice.setTitle("Pagpipilian", for: .normal)
                cell.lblOutofstock.text = "Sa labas ng Stock!"

                case "urd":cell.lblItemName.text = ItemsDetail["itemNameUrdu"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientUrdu"] as? String
                cell.btnChoice.setTitle("چوائس۔", for: .normal)
                cell.lblOutofstock.text = "زخیرے سے باہر!"

                case "kor":cell.lblItemName.text = ItemsDetail["itemNameKorean"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientKorean"] as? String
                cell.btnChoice.setTitle("선택", for: .normal)
               cell.lblOutofstock.text = "품절!"

                case "spa":cell.lblItemName.text = ItemsDetail["itemNameSpain"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientSpain"] as? String
                cell.btnChoice.setTitle("Elección", for: .normal)
                cell.lblOutofstock.text = "¡Agotado!"
                    
                case "sri":cell.lblItemName.text = ItemsDetail["itemNameSrilanka"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientSrilanka"] as? String
                cell.btnChoice.setTitle("තේරීම", for: .normal)
                cell.lblOutofstock.text = "තොග අවසන්!"

                case "tur":cell.lblItemName.text = ItemsDetail["itemNameTurkish"]as? String
                cell.txtIngrident.text = ItemsDetail["ingredientTurkish"] as? String
                cell.btnChoice.setTitle("Seçim", for: .normal)
                cell.lblOutofstock.text = "Stoklar tükendi!"
                    
                default:cell.lblItemName.text = ItemsDetail["itemName"] as? String
                cell.txtIngrident.text = ItemsDetail["ingredientEng"]as? String
                cell.btnChoice.setTitle("Choice", for: .normal)
                cell.lblOutofstock.text = "Out of stock!"

                }
                
            }


            let txtfont = UIFont.systemFont(ofSize: 22)
            cell.contxtDescHeight.constant = 55
            cell.conViewDestHeight.constant = 111
            
            cell.btnReadmore.isHidden = true

            let strNSAtt = NSAttributedString(string: cell.txtIngrident.text, attributes: [.font:txtfont])
            let getHeight = strNSAtt.height(withConstrainedWidth: cell.txtIngrident.frame.size.width)
            let intHeight = Int(getHeight)
//            if intHeight > 50
//            {
//                cell.btnReadmore.isHidden = false
//            }
//            else
//            {
//                cell.btnReadmore.isHidden = true
//            }
            cell.ImgItem.isHidden = false
            cell.videoItem.isHidden = true
//           cell.btnPlay.isHidden = true

            var isVideo : Bool = false
            var dict = [String:AnyObject] ()
            if indexPath.row > 0
            {
                let ItemsPrev = self.listVideo[indexPath.row - 1]
                dict = self.listVideo[indexPath.row - 1]
                let seq1 = ItemsDetail["itemSeq"] as? Int32
                let seq2 = ItemsPrev["itemSeq"] as? Int32
                
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
                cell.ImgItem.isHidden = true
                cell.videoItem.isHidden = false
//                cell.btnPlay.isHidden = true
                avPlayer = AVPlayer(url: GetVideoFromStorage(fileName: str123!))
                avPlayerController.player = avPlayer
                avPlayerController.view.frame = CGRect(x: 0, y: 0, width: cell.ImgItem.frame.size.width, height: cell.ImgItem.frame.size.height)
                avPlayerController.showsPlaybackControls = true
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
                cell.videoItem.addSubview(avPlayerController.view)
                 //rtavPlayerController.player?.play()
            }
            
            ImageLoader_SDWebImage.setImage((ItemsDetail["imageName"] as? String), into: cell.ImgItem) { (_, error) in
                if error != nil {
                    let placeholder = ImageLoader_SDWebImage.placeholder
                    cell.ImgItem.image = placeholder
                }
                cell.ImgItem.isHidden = (error != nil)
            }

            cell.contxtDescHeight.constant = 50
            if cell.btnReadmore.isSelected == false
            {
                cell.contxtDescHeight.constant = 50
                cell.conViewDestHeight.constant = 120
                cell.btnReadmore.setTitle("Read More", for: .normal)
            }
          else
            {
                cell.contxtDescHeight.constant = CGFloat(ceil(Double(getHeight)))
                cell.conViewDestHeight.constant = cell.contxtDescHeight.constant  + 10
                cell.btnReadmore.setTitle("Read Less", for: .normal)
            }
            cell.txtIngrident.updateConstraintsIfNeeded()
            cell.txtIngrident.layoutIfNeeded()
            cell.viewDesc.updateConstraintsIfNeeded()
            cell.viewDesc.layoutIfNeeded()
        //cell.txtIngrident.scrollRangeToVisible(NSMakeRange(0, 0))
            cell.btnChoice.tag = indexPath.item
            cell.btnReadmore.tag = indexPath.item
            cell.txtIngrident.isScrollEnabled = false
            cell.btnChoice.addTarget(self, action: #selector(btnChoiceClick(_:)), for:.touchUpInside)
            cell.btnReadmore.addTarget(self, action: #selector(btnReadmoreClick(_:)), for:.touchUpInside)
           
            return cell

        }
    }
    
    @objc func btnReadmoreClick(_ sender: UIButton)
    {
        let btn = sender
        let cell = itemsDetail.cellForItem(at: IndexPath(item: btn.tag, section: 0)) as! ItemsCollectionViewCell
        if btn.isSelected == true
        {
            cell.btnReadmore.isSelected = false

        }
        else
        {
            cell.btnReadmore.isSelected = true
        }
        self.itemsDetail.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == collExtra
        {
//            if listExtra.count > 0
//            {
//                let SelectedCategories =
//                    self.listExtra[(indexPath.row)]
//                var size = ItemName1(ItemList: SelectedCategories).size(withAttributes: nil)
//                if size.width > 100
//                {
//
//                    size.height =  size.height + 120
//
//                }
//                return CGSize(width:350,height: max(300,size.height))
//
//            }
//
//            else
//            {
                return CGSize(width:350,height: max(300,120))

//            }
            
        }
        else
        {
            return CGSize(width: self.itemsDetail.frame.size.width, height:(self.itemsDetail.frame.size.height))
        }

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
    return itemName!
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
        return itemName!
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
    
    @objc func btnChoiceClick(_ sender: Any)
    {
        let btn = sender as! UIButton
//        let cell = self.itemsDetail.cellForItem(at: IndexPath(item: btn.tag, section: 0)) as? ItemsCollectionViewCell
        let detail = self.listVideo[btn.tag]
        let id = detail["itemSeq"] as! Int32
        if btn.isSelected == true
        {
            
        }
        else
        {
            self.viewExtra.isHidden = false
            self.setView(view: viewExtra, hidden: false,passid: id)

        }
    }
    func setView(view: UIView, hidden: Bool,passid:Int32) {
        self.viewTap.isHidden = false

        UIView.transition(with: collExtra,
                          duration: 0.6,
                          options: [.transitionCurlDown],
                          animations: {
                            self.fetchExtraData1(passid:passid)
                            
                            ImageLoader_SDWebImage.getImage(self.themeData[0].popupBackground) { (image, _) in
                                if let img = image {
                                    self.view.backgroundColor = UIColor(patternImage: img)
                                } else {
                                    self.view.backgroundColor = UIColor.white
                                }
                            }

                            let str1111 = self.themeData[0].itemBackgroundColor
                            
                            if  (str1111 == nil || str1111!.isEmpty)
                            {
                                 self.collExtra.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                                
                            }
                                
                            else
                            {
                                let color1 = self.colorWithHexString(hex: self.themeData[0].background!)
                                let getAlpha = Float(Float(self.themeData[0].rightTop!)!/100.00)
                                self.collExtra.backgroundColor  = color1.withAlphaComponent(CGFloat(getAlpha))
                                
                                
                            }

        },
                          completion: nil)

    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collExtra
        {
            self.viewExtra.isHidden = false

        }
    }
    @objc func btnVideoPlay(_ sender: Any)
    {
        let btn = sender as! UIButton
    }
    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.setCollectionArrow()
    }

   
    override func viewDidLoad()
    {
        getSettingData()
        //self.viewTap.isHidden = false
        self.viewExtra.isHidden = true
        self.viewTap.isHidden = true
        if ItemViewLayoutBVC.ItemDetails.strCome == "layoutB"
        {
            CategoryID = ItemViewLayoutBVC.ItemDetails.CategoryID;
            getId = ItemViewLayoutBVC.ItemDetails.strPassitemId;
        }
       else  if ItemViewLayoutCVC.ItemDetails.strCome == "layoutC"
        {
            CategoryID = ItemViewLayoutCVC.ItemDetails.CategoryID;
            getId = ItemViewLayoutCVC.ItemDetails.strPassitemId;
        }
        else
        {
            CategoryID = ItemViewController.ItemDetails.CategoryID;
            getId = ItemViewController.ItemDetails.strPassitemId;
        }
        fetchExtraData(passid: 0, completion: {(success) in
            if self.listExtra.count > 0
            {
                self.viewExtra.isHidden = false
                self.viewTap.isHidden = false
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
                tap.delegate = self
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                self.viewTap.addGestureRecognizer(tap)
            }
            else
            {
                self.viewExtra.isHidden = true
                self.viewTap.isHidden = true
            }
        })
        pageView.currentPageIndicatorTintColor = UIColor.white
        self.itemsDetail.isPagingEnabled = true;
        self.GetItems(CatID: CategoryID)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        self.viewTap.isHidden = true
        self.viewExtra.isHidden = true
    }
    override func viewDidLayoutSubviews()
    {
        if getPage == 0
        {
            self.btnPre.isHidden = true
        }
        if ItemViewLayoutBVC.ItemDetails.strCome ==  "layoutB"
        {
            self.pageView.currentPage = getPage
        }
        else if ItemViewLayoutCVC.ItemDetails.strCome ==  "layoutC"
        {
            self.pageView.currentPage = getPage
        }
        else
        {
            pageView.currentPage = getPage
        }
    }

    func fetchExtraData (passid:Int32,completion:@escaping (_ success:[Extra]) -> Void)
    {
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "itemID = %d",passid)
            let items = Extra.SK_all(predicate, context: context)
            if items.count > 0
            {
                self.listExtra = items
                completion(self.listExtra)
            }
            else
            {
                self.listExtra = items
                completion(self.listExtra)
            }
        }
    }
    
    func fetchExtraData1 ( passid:Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "itemID = %d",passid)
            let items = Extra.SK_all(predicate, context: context)
            self.listExtra = [Extra]()
            if items.count > 0
            {
                self.listExtra = items
                DispatchQueue.main.async
                    {
                        self.collExtra.reloadData()
                }
            }
            else
            {
                self.listExtra = items
            }
        }
    }

    func colorWithHexString (hex:String) -> UIColor
    {
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

    func GetItems(CatID: Int32){
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "catID = \(NSNumber(value:CatID))")
            let items = ItemsCoreData.SK_all(context, predicate: predicate, sortTerm: "catSeq", ascending: true)
            self.listItems = items
            self.pageView.numberOfPages = self.listVideo.count
            self.pageView.currentPageIndicatorTintColor = UIColor.white
            
            self.listImages = items
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
            self.pageView.numberOfPages = self.listVideo.count
            var background = UIImage()
            self.itemsDetail.reloadData()
            self.itemsDetail.layoutIfNeeded()
            
            if ItemViewLayoutBVC.ItemDetails.strCome ==  "layoutB"
            {
                
                self.themeData = ItemViewLayoutBVC.ItemDetails.staticThemeData;
                for j in 0..<self.listVideo.count
                {
                    let dic = self.listVideo[j]
                    let pos:Int32 = (dic["itemSeq"] as? Int32)!
                    
                    if ItemViewLayoutBVC.ItemDetails.strPassitemId == pos
                    {
                        self.itemsDetail.scrollToItem(at:IndexPath(item:j, section: 0), at:.centeredHorizontally, animated: true)
                        break
                    }
                }
            }
            else if ItemViewLayoutCVC.ItemDetails.strCome ==  "layoutC"
            {
                self.themeData = ItemViewLayoutCVC.ItemDetails.staticThemeData
                for k in 0..<self.listVideo.count
                {
                    let dic = self.listVideo[k]
                    let pos:Int32 = (dic["itemSeq"] as? Int32)!
                    if ItemViewLayoutCVC.ItemDetails.strPassitemId == pos
                    {
                        self.itemsDetail.scrollToItem(at:IndexPath(item:k, section: 0), at:.centeredHorizontally, animated: true)
                        break
                    }
                }
                
            }
            else
            {
                self.themeData = ItemViewController.ItemDetails.staticThemeData;
                
                for m in 0..<self.listVideo.count
                {
                    // let dic = self.listVideo[m]
                    let pos:Int32 = (self.listVideo[m]["itemSeq"] as? Int32)!
                    if ItemViewController.ItemDetails.strPassitemId == pos
                    {
                        self.itemsDetail.scrollToItem(at:IndexPath(item:m, section: 0), at:.centeredHorizontally, animated: true)
                        self.itemsDetail.layoutSubviews()
                        break
                    }
                }
            }
        }
    }
}
    
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
}
