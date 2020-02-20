//
//  File.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 6/30/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
class SettingScreenController: UIViewController {
    
    @IBOutlet weak var txtIP: UITextField!
    @IBOutlet weak var txtPASSWORD: UITextField!
    @IBOutlet weak var txtport: UITextField!
    @IBAction func SaveSetting(_ sender: Any) {
        
        var Ip: String = "";
        Ip = txtIP.text!
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("VIew Has loaded");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
