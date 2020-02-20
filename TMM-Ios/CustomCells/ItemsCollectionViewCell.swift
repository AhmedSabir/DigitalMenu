//
//  ItemsCollectionViewCell.swift
//  TMM-Ios
//
//  Created by Hussain Kanch on 7/24/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit

class ItemsCollectionViewCell: UICollectionViewCell {
    weak var delegate: CollectionViewCellDelegate?
    @IBOutlet weak var lblIngredient: UILabel!
    
    @IBOutlet weak var button: UIButton!
    @IBAction func imageClicked(_ sender: UIButton)
    {
         self.delegate?.collectionViewCell(self, buttonTapped: button)
    }
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var ImgItem: UIImageView!
    @IBOutlet weak var videoItem: UIView!
  //  @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnImageItem: UIButton!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var txtIngrident: UITextView!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var conimgMinusWidth: NSLayoutConstraint!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var viewOutofStock: UIView!
    @IBOutlet weak var lblOutofstock: UILabel!
    @IBOutlet weak var btnChoice: UIButton!
    @IBOutlet weak var conbtnchoiceWidth: NSLayoutConstraint!
    @IBOutlet weak var contxtDescHeight: NSLayoutConstraint!
    @IBOutlet weak var btnReadmore: UIButton!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var conViewDestHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblNameHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnFav: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if txtIngrident.text != nil
//        {
//            txtIngrident?.scrollRangeToVisible(NSRange(location: 0, length: 0))
//
//        }
//        viewInner.layer.cornerRadius = 3.0
//        viewInner.layer.borderColor = UIColor.clear.cgColor
//        viewInner.clipsToBounds = true
        
    }
    

    
}
protocol CollectionViewCellDelegate: class {
    // Declare a delegate function holding a reference to `UICollectionViewCell` instance
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

