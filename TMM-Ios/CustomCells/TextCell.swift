//
//  TextCell.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 10/24/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
protocol PasstextData: class
{
    func textChange(strText: String,setTag:Int)
}

class TextCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet var lblQue:UILabel!

    @IBOutlet var txtMessage:UITextView!
    var setInd:Int!
    weak var delegete:PasstextData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func textViewDidChange(_ textView: UITextView)
    {
        delegete?.textChange(strText: txtMessage.text, setTag: setInd)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
