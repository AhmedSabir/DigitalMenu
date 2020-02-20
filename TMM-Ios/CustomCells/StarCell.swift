//
//  StarCell.swift
//  TMM-Ios
//
//  Created by Jigar Joshi on 10/24/18.
//  Copyright © 2018 One World United. All rights reserved.
//

import UIKit
protocol PassAttributeData: class
{
    func starSelected(strAttr: String,setTag:Int)
}

class StarCell: UITableViewCell {

    @IBOutlet var viewStar:DXStarRatingView!
    @IBOutlet var lblQue:UILabel!
    @IBOutlet var viewCell:UIView!
    weak var delegate: PassAttributeData?
    var setIndex:Int!
    
    var starRate = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        viewStar.setStars(0, callbackBlock: { newRating in
            if let aRating = newRating {
                self.starRate = "\(aRating)"
            }
            if let aRating = newRating {
                print("\(aRating)")
            }
            self.delegate?.starSelected(strAttr: self.starRate, setTag: self.setIndex)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
