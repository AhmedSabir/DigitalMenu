//
//  Promotion1VC.swift
//  TMM-Ios
//
//  Created by HTNaresh on 8/8/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import AVFoundation

class Promotion1VC: UIViewController , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{

    @IBOutlet var collPromotion:UICollectionView!
    @IBOutlet var btnClose:UIButton!
    @IBOutlet var Noimage:UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var pageView: UIPageControl!

    var getPage:Int = 0
    var arrSlide = [SlideShow]()
    var timer = Timer()
    var strIsCome = String()
    var selectedIndex:Int = 0
    var strIsComefromView = String()
    var avPlayer = AVPlayer()
    let avPlayerController = AVPlayerViewController()

    struct slideDetail
    {
        static var imageName = String()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getImage()
        
        
    }
    

    //MARK: -Collecion Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrSlide.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemsCollectionViewCell
        let slideData = self.arrSlide[indexPath.row]
        ImageLoader_SDWebImage.setImage(slideData.imageName, into: cell.ImgItem)
        cell.ImgItem.contentMode = .scaleAspectFit
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collPromotion.frame.size.width, height:(self.collPromotion.frame.size.height))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.setCollectionArrow()
    }

    
    @IBAction func btnCloseClick (_ sender : AnyObject)
    {
        let objVC: FiniHomeVC? = storyboard?.instantiateViewController(withIdentifier: "FiniHomeVC") as? FiniHomeVC
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    @IBAction func btnNextClick(_ sender: Any)
    {
        
        if collPromotion.visibleCells.count > 0
        {
            
            //avPlayer.pause()
           // avPlayerController.player = nil
            let cell: ItemsCollectionViewCell? = collPromotion.visibleCells[0] as! ItemsCollectionViewCell
            
            var index: IndexPath? = nil
            
            if let aCell = cell {
                index = collPromotion.indexPath(for: aCell)
            }
            
            if (index?.row ?? 0) + 1 < self.arrSlide.count
            {
                collPromotion.scrollToItem(at: IndexPath(row: (index?.row ?? 0) + 1, section: 0), at: .right, animated: true)
            }
        }
        
    }
    @IBAction func btnPreClick(_ sender: Any)
    {
        if collPromotion.visibleCells.count > 0
        {
            //avPlayer.pause()
            //avPlayerController.player = nil
            var cell: ItemsCollectionViewCell? = collPromotion.visibleCells[0] as! ItemsCollectionViewCell
            var index: IndexPath? = nil
            if let aCell = cell {
                index = collPromotion.indexPath(for: aCell)
            }
            
            if (index?.row ?? 0) < self.arrSlide.count
            {
                collPromotion.scrollToItem(at: IndexPath(row: (index?.row ?? 0) - 1, section: 0), at: .left, animated: true)
            }
        }
        
    }
    func setCollectionArrow()
    {
        avPlayer.pause()
        
        //var cell: ItemsCollectionViewCell? = itemsDetail.cellForItem(at: <#T##IndexPath#>)
        let pageWidth: CGFloat
        pageWidth  = collPromotion.frame.size.width
        btnPre.isHidden = true
        let page : NSInteger  = NSInteger(collPromotion.contentOffset.x / pageWidth)
        
        pageView.currentPage = page
        getPage = page
        let language = UserDefaults.standard.value(forKey: "lang") as! String

        if page == 0
        {
            if language == "ara"
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
        else if page == self.arrSlide.count - 1
        {
            if language == "ara"
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
    override func viewDidLayoutSubviews() {
        if getPage == 0
        {
            self.btnPre.isHidden = true
        }
        else
        {
            pageView.currentPage = getPage
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getImage()
    {
        SkopelosClient.shared.read { context in
            let items = SlideShow.SK_all(context)
            self.arrSlide = items
            if self.arrSlide.count > 0
            {
                self.Noimage.isHidden = false
                self.Noimage.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
                self.collPromotion.isHidden = false
                self.collPromotion.reloadData()
            }
                
            else
            {
                self.Noimage.isHidden = false
                self.collPromotion.isHidden = true
                self.Noimage.contentMode = .scaleAspectFit
                ImageLoader_SDWebImage.setImage(slideDetail.imageName, into: self.Noimage)
            }
        }
    }
    func wagaDuggu (fileName: String) -> UIImage
    {
        print(fileName)
        if (fileName == "")
        {
            return UIImage(named: "NoImage")!
            
        }
        else
        {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(fileName)").path
            if FileManager.default.fileExists(atPath: filePath)
            {
                
                var image = UIImage(contentsOfFile: filePath)!
                return UIImage(contentsOfFile: filePath)!
                
            }else
            {
                return UIImage(named: "NoImage")!
            }
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
    
    


}
