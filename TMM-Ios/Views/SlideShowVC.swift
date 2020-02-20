//
//  SlideShowVC.swift
//  TMM-Ios

//
//  Created by Jigar Joshi on 11/15/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
import CoreData

class SlideShowVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate
{

    @IBOutlet var collSlideShow:UICollectionView!
    @IBOutlet var btnClose:UIButton!
    @IBOutlet var Noimage:UIImageView!

    var arrSlide = [SlideShow]()
    var timer = Timer()
    var strIsCome = String()
    var selectedIndex:Int = 0

    struct slideDetail
    {
        static var imageName = String()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getImage()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        if self.strIsCome == "Promotion"
        {
        btnClose.isHidden = false
            self.collSlideShow.backgroundColor = UIColor.clear
        }
        else
        {
            btnClose.isHidden = true

        }
    }
    
    //MARK: -Collecion Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrSlide.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideShowCell", for: indexPath) as! SlideShowCell
        let slideData = self.arrSlide[indexPath.row]
        ImageLoader_SDWebImage.setImage(slideData.imageName, into: cell.imgSlide)
        cell.imgSlide.contentMode = .scaleAspectFit
        let timing = UserDefaults.standard.value(forKey: "second") as? NSString
    
           let conFloat:TimeInterval = (timing?.doubleValue)!
        timer.invalidate()

        timer = Timer.scheduledTimer(timeInterval: conFloat, target: self, selector: #selector(timerAction), userInfo: nil, repeats:true)
        return cell
    }
    
    @objc func timerAction()
    {
        
        if (collSlideShow .visibleCells.count>0) {
            let cell:UICollectionViewCell = (collSlideShow.visibleCells[0])
            let index:IndexPath = (collSlideShow!.indexPath(for: cell))!
            if (index.row+1 < arrSlide.count) {
                
                collSlideShow.scrollToItem(at: IndexPath(item:index.row+1, section: 0), at:UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                
            }else{
                
                collSlideShow.scrollToItem(at: IndexPath(item:0, section: 0), at:UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if self.strIsCome == "Promotion"
//        {
//            return CGSize(width: (self.view.frame.size.width - 80), height: (self.view.frame.size.height - 80))
//
//        }
//        else
//        {
            return CGSize(width: (self.view.frame.size.width - 30), height: (self.view.frame.size.height - 20))

//        }
    }

    @IBAction func btnCloseClick (_ sender : AnyObject)
    
    {
       // dismiss(animated: true)
        if strIsCome == "layoutB"
        {
            let objVC: ItemViewLayoutBVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutBVC") as? ItemViewLayoutBVC
                    objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true

        }
        else if strIsCome == "layoutA"
        {
            let objVC: ItemViewController? = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
       else  if strIsCome == "layoutC"
        {
            let objVC: ItemViewLayoutCVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutCVC") as? ItemViewLayoutCVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else if strIsCome == "layoutD"
        {
            let objVC: ItemViewControllerLayoutDVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewControllerLayoutDVC") as? ItemViewControllerLayoutDVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
//            Classiclayout
        else if strIsCome == "Classiclayout"
        {
            let objVC: ClassicLayoutVC? = storyboard?.instantiateViewController(withIdentifier: "ClassicLayoutVC") as? ClassicLayoutVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }

        else if strIsCome == "Promotion"
        {
            let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }

            
        else{
            
                let objVC: PortraitModeVC? = storyboard?.instantiateViewController(withIdentifier: "PortraitModeVC") as? PortraitModeVC
                objVC?.strCome = "slide"
                objVC?.selectedIndex = self.selectedIndex
                let aObjNavi = UINavigationController(rootViewController: objVC!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = aObjNavi
                aObjNavi.isNavigationBarHidden = true
                
           

        }

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) { //sender: UITapGestureRecognizer
        
        if strIsCome == "layoutB"
        {
            let objVC: ItemViewLayoutBVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutBVC") as? ItemViewLayoutBVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else if strIsCome == "layoutA"
        {
            let objVC: ItemViewController? = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController
            objVC?.strCome = "slide"
          //  objVC?.btnBrandLogo.isSelected = true
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else  if strIsCome == "layoutC"
        {
            let objVC: ItemViewLayoutCVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewLayoutCVC") as? ItemViewLayoutCVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
        else if strIsCome == "layoutD"
        {
            let objVC: ItemViewControllerLayoutDVC? = storyboard?.instantiateViewController(withIdentifier: "ItemViewControllerLayoutDVC") as? ItemViewControllerLayoutDVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
            //            Classiclayout
        else if strIsCome == "Classiclayout"
        {
            
            let objVC: ClassicLayoutVC? = storyboard?.instantiateViewController(withIdentifier: "ClassicLayoutVC") as? ClassicLayoutVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
            
        else if strIsCome == "Promotion"
        {
            let objVC: HomePageVC? = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
//            objVC?.strCome = "Promotion"
//            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
            
        }
            
        else{
            
            let objVC: PortraitModeVC? = storyboard?.instantiateViewController(withIdentifier: "PortraitModeVC") as? PortraitModeVC
            objVC?.strCome = "slide"
            objVC?.selectedIndex = self.selectedIndex
            let aObjNavi = UINavigationController(rootViewController: objVC!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = aObjNavi
            aObjNavi.isNavigationBarHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getImage()
    {
        self.view.backgroundColor = UIColor.black
        SkopelosClient.shared.read { context in
            let items = SlideShow.SK_all(context)
            self.arrSlide = items
            if self.arrSlide.count > 0
            {
                self.Noimage.isHidden = true
                self.collSlideShow.isHidden = false
                self.collSlideShow.reloadData()
            }
                
            else
            {
                self.Noimage.isHidden = false
                self.collSlideShow.isHidden = true
                self.Noimage.contentMode = .scaleAspectFit
                ImageLoader_SDWebImage.setImage(slideDetail.imageName, into: self.Noimage)
            }
        }
        

    }
    func wagaDuggu (fileName: String) -> UIImage
    {
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
