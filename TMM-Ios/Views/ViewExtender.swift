//
//  ViewExtender.swift
//  TMM-Ios
//
//  Created by Cisner iMac on 02/02/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import UIKit
import QuartzCore



@IBDesignable
class ViewExtender: UIView {

    var index11 = Int()
    //MARK: PROPERTIES
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0
        {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
            clipsToBounds = true
        }
    }
    
    //    @IBInspectable var section: Int = 1
    //        {
    //        didSet {
    //            self.descriptiveName = section
    //        }
    //    }
    
    //MARK: Initializers
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup()
    {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornurRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


}
