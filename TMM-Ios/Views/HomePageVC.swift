//
//  HomePageVC.swift
//  TMM-Ios
//  Created by Jigar  Joshi on 15/07/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class HomePageVC: UIViewController
{
    @IBOutlet weak var imgbrandLogo: UIImageView!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnPromotion: UIButton!
    @IBOutlet weak var imgTranspent: UIImageView!
    @IBOutlet weak var imgLanguage: UIImageView!

    var btnFeedBack = UIButton()
    var themeData = [Themes]()
    var Selectedindex:Int!
    var strSelLang = String()
    var strIsotherLang = String()
  var listLayoutType = [LayoutType]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnMenu.isHidden = false
        //let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapCharacter:")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(btnMenuDoubleTap(_:)))
        gesture.numberOfTapsRequired = 3
       btnMenu.addGestureRecognizer(gesture)
        if BrandViewController.Brandhelper.feedBack == 1
        {
            createFeedbackButton()
        }
        //btnMenu.addGestureRecognizer(doubleTapRecognizer)
        CreateMenuButtons()
//        imgTranspent.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.downloadThemes(ThemeID: BrandViewController.Brandhelper.themeID)
        self.downloadBrandImageLogo()
        if themeData[0].fontColor == nil
        {
            btnLanguage.titleLabel?.textColor = UIColor.black
            btnFeedBack.titleLabel?.textColor = UIColor.black
            btnPromotion.titleLabel?.textColor = UIColor.black
            btnMenu.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            btnLanguage.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnPromotion.titleLabel?.textColor = colorWithHexString(hex: themeData[0].fontColor!)
            btnMenu.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
            btnLanguage.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)
            btnFeedBack.setTitleColor(colorWithHexString(hex: themeData[0].fontColor!), for: .normal)


        }
        if themeData[0].promotion == "" || themeData[0].promotion == "0"
        {
            btnPromotion.isHidden = true
        }
        else
        {
            btnPromotion.isHidden = false
        }
        if (themeData[0].englishButton != nil)
        {
            btnLanguage.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            btnFeedBack.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            
            imgMenu.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
            btnPromotion.backgroundColor = self.colorWithHexString(hex: themeData[0].englishButton!)
        }
        else
        {
            btnLanguage.backgroundColor = UIColor.lightGray
            btnFeedBack.backgroundColor = UIColor.lightGray
            btnPromotion.backgroundColor = UIColor.lightGray
            imgMenu.backgroundColor = UIColor.lightGray
        }
        if UserDefaults.standard.value(forKey: "IsOtherLanguages") as?  String == "1"
        {
            var getValue : String!
            btnLanguage.setTitle("", for: .normal)
            btnFeedBack.setTitle("", for: .normal)
            btnLanguage.setTitle("", for: .selected)
            btnLanguage.titleLabel?.text = ""
            imgLanguage.isHidden = false
            if UserDefaults.standard.value(forKey: "lang") as?  String == nil
            {
                self.btnMenu.setTitle("Menu", for: .normal)
                self.strSelLang = "eng"
            }
                
            else
            {
                getValue = UserDefaults.standard.value(forKey: "lang") as? String
                self.strSelLang  = getValue
                switch  getValue
                {
                case "eng": self.btnMenu.setTitle("Menu", for: .normal)
                case "ara": self.btnMenu.setTitle("القائمة", for: .normal)
                case "cha":self.btnMenu.setTitle("菜單", for: .normal)
                case "ira":self.btnMenu.setTitle("Clár", for: .normal)
                case "ita":self.btnMenu.setTitle("Menu", for: .normal)
                case "fra":self.btnMenu.setTitle("Menu", for: .normal)
                case "ger":self.btnMenu.setTitle("Speisekarte", for: .normal)
                case "ban": self.btnMenu.setTitle("মেনু", for: .normal)
                case "hin":self.btnMenu.setTitle("भोजनसूची", for: .normal)
                case "phil":self.btnMenu.setTitle("Menu", for: .normal)
                case "urd":self.btnMenu.setTitle("مینو", for: .normal)
                case "kor":self.btnMenu.setTitle("메뉴", for: .normal)
                case "spa":self.btnMenu.setTitle("Menú", for: .normal)
                case "sri":self.btnMenu.setTitle("මෙනු", for: .normal)
                case "tur":self.btnMenu.setTitle("Menü", for: .normal)
                default: print(self.strSelLang)
                    
                }
                
            }
            UserDefaults.standard.set(strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()

        }
        else
        {
            btnLanguage.setImage(nil, for: .normal)
            imgLanguage.isHidden = true
            let CurrentLanguage = UserDefaults.standard.value(forKey: "lang") as?  String
                    if (CurrentLanguage == "eng")
                    {
        
                        btnLanguage.setTitle("عربى", for: .normal)
                        self.btnMenu.setTitle("Menu", for: .normal)
                        self.strSelLang = "eng"
                    }
        
                    else {
                        btnLanguage.setTitle("ENG", for: .normal)
                        self.btnMenu.setTitle("القائمة", for: .normal)
                        self.strSelLang = "ara"

                    }
            UserDefaults.standard.set(strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()

        }

        btnPromotion.setTitle("Promotion", for: .normal)
        btnMenu.isHidden = false
        // Do any additional setup after loading the view.
    }
   
    func createFeedbackButton (){
        
        self.view.addSubview(btnFeedBack)
        btnFeedBack.translatesAutoresizingMaskIntoConstraints = false
        btnFeedBack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
      //  btnFeedBack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        btnFeedBack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        btnFeedBack.widthAnchor.constraint(equalToConstant: 130).isActive = true
        btnFeedBack.heightAnchor.constraint(equalToConstant: 65).isActive = true
        btnFeedBack.setTitle("Feedback", for: .normal)
        btnFeedBack.titleLabel?.textColor = UIColor.black
        btnFeedBack.titleLabel?.font = .init(.boldSystemFont(ofSize: 18))
        btnFeedBack.layer.cornerRadius=5
        btnFeedBack.layer.borderColor = UIColor.white.cgColor
      //  btnFeedBack.enableDebug(color: .red)
        btnFeedBack.addTarget(self, action: #selector(getfeedbackLayout), for: .touchUpInside)
       
        
        
        
        
    }
    
    func CreateMenuButtons(){
        imgMenu.layer.cornerRadius = self.imgMenu.frame.size.width / 2
        imgMenu.layer.borderWidth = 0
        imgMenu.layer.borderColor = UIColor.clear.cgColor
        let somegif = UIImage.gifImageWithName("Menu_Animation6")
        imgMenu.image = somegif
        imgMenu.contentMode = .scaleAspectFit
    }
    @objc func getfeedbackLayout(){
        
        let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "Feedback1VC") as! Feedback1VC
         //popOverVC.selectedIndex = self.Selectedindex
         navigationController?.pushViewController(popOverVC, animated: true)
        
        
//        let objVC: Feedback1VC? = storyboard?.instantiateViewController(withIdentifier: "Feedback1VC") as? Feedback1VC
//               objVC?.strIsCome = "fini"
//               let aObjNavi = UINavigationController(rootViewController: objVC!)
//               let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               appDelegate.window?.rootViewController = aObjNavi
//               aObjNavi.isNavigationBarHidden = true
    }
    
   
    
    func goBackToMainPage(password: String){
        
        let LayoutData = GetLayout()
        
        if(LayoutData[0].password == password){
            
            SkopelosClient.shared.writeSync { context in
                self.listLayoutType.removeAll();
                let settings = LayoutType.SK_all(context)
                settings.forEach { setting in
                    setting.SK_remove(context)
                }
                
            }
            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandViewController")
            self.navigationController?.pushViewController(destVC, animated: true)
        }else{
            ToastView.shared.long(self.view, txt_msg: "Invalid Password")
        }

    }
    func GetLayout() -> [LayoutType] {
       
        SkopelosClient.shared.read { context in
                   let Setting = LayoutType.SK_all(context)
                   self.listLayoutType = Setting
               }
        return listLayoutType
    }
    
    
    @objc func btnMenuDoubleTap(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Login",
                                      message: "Please Enter server password to go back to Main Menu",
                                      preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            
            UserDefaults.standard.removeObject(forKey: "lang")
            UserDefaults.standard.synchronize()
            print("Menu")
            self.viewWillAppear(true)
            self.goBackToMainPage(password: alert.textFields![0].text ?? "TestKosar")
            
            
        })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
            
            textField.placeholder = "Password"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Calibri", size: 15)
        }
        alert.addAction(loginAction)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            //
        })
        alert.addAction(cancel)

                  present(alert, animated: true, completion: nil)
        print("tapped")
    }

    @IBAction func btnMenuClick(_ sender: UIButton) {

        if Selectedindex == 0
        {
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
            popOverVC.selectedIndex = self.Selectedindex
            navigationController?.pushViewController(popOverVC, animated: true)
        }
         else if Selectedindex == 1
        {
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ItemViewLayoutBVC") as! ItemViewLayoutBVC
            popOverVC.selectedIndex = self.Selectedindex
            navigationController?.pushViewController(popOverVC, animated: true)

        }
        else if Selectedindex == 2
        {
            
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ItemViewLayoutCVC") as! ItemViewLayoutCVC
            popOverVC.selectedIndex = 2
            navigationController?.pushViewController(popOverVC, animated: true)

        }
         else if Selectedindex == 3
        {
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ItemViewControllerLayoutDVC") as! ItemViewControllerLayoutDVC
            popOverVC.selectedIndex = 3
            navigationController?.pushViewController(popOverVC, animated: true)

        }
        else if Selectedindex == 4
        {
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ClassicLayoutVC") as! ClassicLayoutVC
            popOverVC.selectedIndex = self.Selectedindex
            navigationController?.pushViewController(popOverVC, animated: true)
        }
        else if Selectedindex == 5
        {
            let popOverVC = self.storyboard!.instantiateViewController(withIdentifier: "ClassicLayoutVC") as! FiniItemListVC
            popOverVC.selectedIndex = self.Selectedindex
            navigationController?.pushViewController(popOverVC, animated: true)
        }
        
        
    }
    @IBAction func btnPromotionClick(_ sender: UIButton)
    {
        let objVC: SlideShowVC? = storyboard?.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
        objVC?.strIsCome = "Promotion"
        //objVC?.selectedIndex = self.selectedIndex
        let aObjNavi = UINavigationController(rootViewController: objVC!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = aObjNavi
        aObjNavi.isNavigationBarHidden = true
    }
    @IBAction func btnLanguageClick(_ sender: UIButton)
    {

        if UserDefaults.standard.value(forKey: "IsOtherLanguages") as?  String == "1"
        {
            var SelIndex = Int()
            imgLanguage.isHidden = false

            self.btnLanguage.titleLabel?.text = ""
            let arr = ["English","عربى","中文","Gaeilge","Italiana","Française","Deutsche","বাংলাদেশী","हिंदी","Pilipinas","اردو","한국어","Española","සිංහල","Türk"]
            let cellConfi1 = FTCellConfiguration()
            cellConfi1.textColor = UIColor.red
            cellConfi1.textAlignment = .center
            FTPopOverMenu.showForSender(sender: sender, with: arr, done: { (selectedIndex) in
                SelIndex  = selectedIndex
                var checkSelection = Int()
                checkSelection = SelIndex
                switch  checkSelection
                {
                case 0: self.strSelLang = "eng"
                case 1: self.strSelLang = "ara"
                case 2: self.strSelLang = "cha"
                case 3:self.strSelLang = "ira"
                case 4:self.strSelLang = "ita"
                case 5:self.strSelLang = "fra"
                case 6:self.strSelLang = "ger"
                case 7: self.strSelLang = "ban"
                case 8:self.strSelLang = "hin"
                case 9:self.strSelLang = "phil"
                case 10:self.strSelLang = "urd"
                case 11:self.strSelLang = "kor"
                case 12:self.strSelLang = "spa"
                case 13:self.strSelLang = "sri"
                case 14:self.strSelLang = "tur"
                default: print(self.strSelLang)
                }
                UserDefaults.standard.set(self.strSelLang, forKey: "lang")
                UserDefaults.standard.synchronize()
                
                if UserDefaults.standard.value(forKey: "lang") == nil
                {
                    self.btnMenu.setTitle("Menu", for: .normal)
                }
                else
                {
                    var getValue = String()
                    getValue = UserDefaults.standard.value(forKey: "lang") as! String
                    switch  getValue
                    {
                    case "eng": self.btnMenu.setTitle("Menu", for: .normal)
                    case "ara": self.btnMenu.setTitle("القائمة", for: .normal)
                    case "cha":self.btnMenu.setTitle("菜單", for: .normal)
                    case "ira":self.btnMenu.setTitle("Clár", for: .normal)
                    case "ita":self.btnMenu.setTitle("Menu", for: .normal)
                    case "fra":self.btnMenu.setTitle("Menu", for: .normal)
                    case "ger":self.btnMenu.setTitle("Speisekarte", for: .normal)
                    case "ban": self.btnMenu.setTitle("মেনু", for: .normal)
                    case "hin":self.btnMenu.setTitle("भोजनसूची", for: .normal)
                    case "phil":self.btnMenu.setTitle("Menu", for: .normal)
                    case "urd":self.btnMenu.setTitle("مینو", for: .normal)
                    case "kor":self.btnMenu.setTitle("메뉴", for: .normal)
                    case "spa":self.btnMenu.setTitle("Menú", for: .normal)
                    case "sri":self.btnMenu.setTitle("මෙනු", for: .normal)
                    case "tur":self.btnMenu.setTitle("Menü", for: .normal)
                    default: print(self.strSelLang)
                    }
                    
                }
                
                
            }) {
                
            }
            

        }
        else
        {
            self.btnLanguage.setImage(nil, for: .normal)
            imgLanguage.isHidden = true

            if UserDefaults.standard.value(forKey: "lang")as? String == "eng"
            {
                self.btnLanguage.setTitle("ENG", for: .normal)
                self.btnMenu.setTitle("القائمة", for: .normal)
                self.strSelLang = "ara"
            }
            else
            {
                self.btnLanguage.setTitle("عربى", for: .normal)
                self.strSelLang = "eng"
                self.btnMenu.setTitle("Menu", for: .normal)

            }
            UserDefaults.standard.set(self.strSelLang, forKey: "lang")
            UserDefaults.standard.synchronize()

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
            return UIImage(named: "NoImage")!
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
    func downloadThemes(ThemeID: Int32)
    {
        SkopelosClient.shared.read { context in
            let predicate = NSPredicate(format: "themeID = \(NSNumber(value:ThemeID))")
            let items = Themes.SK_all(predicate, context: context)
            self.themeData = items
            let str4 = self.themeData[0].fontColor!
            
            if  ( str4.isEmpty)
            {
                self.btnPromotion.setTitleColor( UIColor.black, for: .normal)
            }
            else
            {
                let color1 = self.colorWithHexString(hex: self.themeData[0].fontColor!)
                self.btnPromotion.setTitleColor( color1, for: .normal)
            }
            
            ImageLoader_SDWebImage.setImage(self.themeData[0].popupBackground, into: self.imgBackground) { (_, error) in
                if error != nil {
                    let placeholder = ImageLoader_SDWebImage.placeholder
                    self.imgBackground.image = placeholder
                }
                self.imgBackground.isHidden = (error != nil)
            }
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
extension UIView{
       func enableDebug(color : UIColor){
           self.layer.borderWidth = 2
           self.layer.borderColor = color.cgColor
       }
   }
