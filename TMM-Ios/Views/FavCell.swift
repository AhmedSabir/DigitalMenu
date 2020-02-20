//
//  FavCell.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 10/20/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit

class FavCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var imgFav:UIImageView!
    @IBOutlet weak var lblItemname:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var viewFav:UIView!
    @IBOutlet weak var btnFav:UIButton!
    
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var lblunitPrice:UILabel!
    @IBOutlet weak var lbltotalPrice:UILabel!
    @IBOutlet weak var txtcomment:UITextView!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Please enter comment"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
