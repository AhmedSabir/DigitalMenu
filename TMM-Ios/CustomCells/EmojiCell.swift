//
//  EmojiCell.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 11/28/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit

class EmojiCell: UITableViewCell {

    @IBOutlet var lblQue:UILabel!
    @IBOutlet var btn1:UIButton!
    @IBOutlet var btn2:UIButton!
    @IBOutlet var btn3:UIButton!
    @IBOutlet var btn4:UIButton!
    @IBOutlet var btn5:UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
