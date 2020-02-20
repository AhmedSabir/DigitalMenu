
//
//  RadioCell.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 10/24/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit

class RadioCell: UITableViewCell {

    @IBOutlet var imgRadio:UIImageView!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblQue:UILabel!
    @IBOutlet var btnYes:UIButton!
    @IBOutlet var btnNo:UIButton!
    @IBOutlet var lblNo:UILabel!
    @IBOutlet var imgNo:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
