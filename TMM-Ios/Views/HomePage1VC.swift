//
//  HomePage1VC.swift
//  TMM-Ios
//  Created by Jigar  Joshi on 15/07/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class HomePage1VC: UIViewController
{
    @IBOutlet weak var imgbrandLogo: UIImageView!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnPromotion: UIButton!
    @IBOutlet weak var imgTranspent: UIImageView!
    
    var themeData = [Themes]()
    var Selectedindex:Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imgMenu.layer.cornerRadius = self.imgMenu.frame.size.width / 2
        imgMenu.layer.borderWidth = 1
        imgMenu.layer.borderColor = UIColor.clear.cgColor
        imgTranspent.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo()
        if themeData[0].fontColor == nil
        {
            btnLanguage.titleLabel?.textColor = UIColor.black
            btnPromotion.titleLabel?.textColor = UIColor.black
            btnMenu.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            btnLanguage.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnPromotion.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnMenu.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
                        
        }
        if themeData[0].promotion == "0" || themeData[0].promotion == ""
        {
            btnPromotion.isHidden = true
        }
        else
        {
            btnPromotion.isHidden = false
            
        }

        // imgMenu.image = self.GetImageFromStorage(fileName: themeData[0].categoryActive!)
        let CurrentLanguage = Language.language;
        btnLanguage.backgroundColor = self.colorWithHexString(hex: themeData[0].separatorLine!)
        imgMenu.backgroundColor = self.colorWithHexString(hex: themeData[0].separatorLine!)
        btnPromotion.backgroundColor = self.colorWithHexString(hex: themeData[0].separatorLine!)
        
        
        if (CurrentLanguage=="eng")
        {
            
            btnLanguage.setTitle("عربى", for: .normal)
        }
        else if (CurrentLanguage=="ara")
        {
            btnLanguage.setTitle("ENG", for: .normal)
        }
        btnPromotion.setTitle("Promotion", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    struct Language {
        static var language = "eng";
    }
    @IBAction func btnMenuClick(_ sender: UIButton)
    {
//        if Selectedindex == 0
//        {
//            self.performSegue(withIdentifier: "itemsViewSegue", sender: self)
//
//        }
//        else if Selectedindex == 0
//        {
//            self.performSegue(withIdentifier: "itemViewSegueB", sender: self)
//
//        }
//        else if Selectedindex == 0
//        {
//            self.performSegue(withIdentifier: "itemViewSegueC", sender: self)
//
//        }
//        else if Selectedindex == 0
//        {
//            self.performSegue(withIdentifier: "itemViewSegueD", sender: self)
//
//        }
//        else if Selectedindex == 4
//        {
            //
            self.performSegue(withIdentifier: "PortraitSegue", sender: self)
            
//        }
//        else if Selectedindex == 5
//        {
//            //
//            self.performSegue(withIdentifier: "ClassicLayoutVC", sender: self)
//            
//        }
//        
        
    }
    @IBAction func btnPromotionClick(_ sender: UIButton)
    {
        let objVC: Slideshow1Vc? = storyboard?.instantiateViewController(withIdentifier: "Slideshow1Vc") as? Slideshow1Vc
        objVC?.strIsCome = "Promotion"
        //objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true

    }
    @IBAction func btnLanguageClick(_ sender: UIButton)
    {
        let CurrentLanguage = Language.language;
        
        ImageLoader_SDWebImage.getImage(themeData[0].categoryInactive) { (image, _) in
            let placeholder = ImageLoader_SDWebImage.placeholder
            self.btnLanguage.setBackgroundImage((image ?? placeholder), for: [])
        }
        
        if (CurrentLanguage=="eng")
        {
            Language.language="ara"
            btnLanguage.setTitle("ENG", for: .normal)
            btnMenu.setTitle("Menu", for: .normal)
            btnLanguage.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        else if (CurrentLanguage == "ara")
        {
            btnLanguage.setTitle("عربى", for: .normal)
            btnLanguage.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
            btnMenu.setTitle("القائمة", for: .normal)
            Language.language = "eng"
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func downloadBrandImageLogo(){
        
        SkopelosClient.shared.read { context in
            let BrandID :Int32? = BrandViewController.Brandhelper.brandID;
            let predicate = NSPredicate(format: "brandID = \(NSNumber(value:BrandID!))")
            let items = Brands.SK_all(predicate, context: context)
            var brandData = [Brands]()
            brandData=items;
            
            ImageLoader_SDWebImage.setImage(brandData[0].brandLogo, into: self.imgbrandLogo) { (_, error) in
                self.imgbrandLogo.isHidden = (error != nil)
            }
        }
    }
    func downloadThemes(ThemeID: Int32){
        
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData=items;
            let str4 = self.themeData[0].fontColor!
            
            if str4.isEmpty  {
                self.btnLanguage.setTitleColor( UIColor.black, for: .normal)
                self.btnPromotion.setTitleColor( UIColor.black, for: .normal)
                
            }
                
            else
            {
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColor!)
                self.btnLanguage.setTitleColor( color1, for: .normal)
                self.btnPromotion.setTitleColor( color1, for: .normal)
                
            }
            self.btnLanguage.setTitle("Promotion", for: .normal)
            ImageLoader_SDWebImage.setImage(self.themeData[0].popupBackground, into: self.imgBackground)
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
    
    
}
