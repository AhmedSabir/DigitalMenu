
//
//  AppDelegate.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 6/30/18.
//  Copyright © 2018 One World United. All rights reserved.
//asdasdsßß

import UIKit
import CoreData
//import Firebase
import SDWebImage
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var listLayoutType = [LayoutType]()
    var window: UIWindow?
    var isInPortrait:Bool!
    
    // [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    var arrFeedback : NSMutableArray!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SettingViewController()
        window?.makeKeyAndVisible()
//        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        var initialViewController: UIViewController
//
//        if(GetLayout().count == 0) {
//            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "BrandViewController") as! BrandViewController
//            initialViewController = vc
//        } else{
//            initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
//        }
//
//        self.window?.rootViewController = initialViewController
//
//        self.window?.makeKeyAndVisible()
//
//
        IQKeyboardManager.sharedManager().enable = true
        ImageLoader_SDWebImage.setupImageLoader()
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug=true
//
        
        return true
      
        
        //FirebaseApp.configure()
//        Instabug.start(withToken: "c61eee0852e3989e11580978d8f8f530", invocationEvents: [.none])
        
    }
    
  
    func GetLayout() -> [LayoutType] {
       
        SkopelosClient.shared.read { context in
                   let Setting = LayoutType.SK_all(context)
                   self.listLayoutType = Setting
               }
        return listLayoutType
    }
    
    
    var myOrientation: UIInterfaceOrientationMask = .portrait
   

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

  
    func applicationDidEnterBackground(_ application: UIApplication) {
        
//        let backgroundtask = [application .beginBackgroundTask(expirationHandler: {
//          UIBackgroundTaskInvalid
//        })]
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name("applicationDidBecomeActive"),
                                        object: self, userInfo: nil)
    }
 

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        UserDefaults.standard.removeObject(forKey: "id")
//        UserDefaults.standard.synchronize()
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        let viewVC = UIApplication.topViewController()
        
        if viewVC is PortraitModeVC
        {
            return .portrait
        }
        else if viewVC is fav1vc
        {
            return .portrait
        }
        else if viewVC is ClassicLayoutVC
        {
//            return [.portrait] //,.landscapeLeft,.landscapeRight
            return [.landscapeRight] //,.landscapeLeft,.landscapeRight

        }
        else if viewVC is DetailVC
        {
            return [.landscapeLeft,.landscapeRight]
        }

        else if viewVC is Slideshow1Vc
        {
            return .portrait
        }
        else if viewVC is Promotion1VC
        {
            return .portrait
        }
        else if viewVC is HomePage1VC 
        {
            return .portrait
        }
        else if viewVC is FiniHomeVC
        {
            return [.portrait]
        }
        else if viewVC is FiniItemListVC
        {
            return .portrait
        }
        else if viewVC is FiniItemDetailVC
        {
            return .portrait
        }

        else if viewVC is FiniCatListVC
        {
            return .portrait
        }
        else if viewVC is Feedback1VC
        {
            return .portrait
        }
        else if viewVC is PortraitHideItemVC
        {
            return .portrait
        }
        return [.landscapeLeft, .landscapeRight,.portrait]
    }
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

