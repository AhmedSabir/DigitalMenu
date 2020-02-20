//
//  BrandCollectionViewCell.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 2/19/20.
//  Copyright © 2020 One World United. All rights reserved.
//

import UIKit
import SDWebImage

class BrandsCollectionViewCell: UICollectionViewCell {
    let titleLable = UILabel()
    let detailsLablel = UILabel()
    let myCellImage = UIImageView()
    let deleteRowbtn = UIButton()
    var cellDelegate: YourCellDelegate!
    var cellData : Brands!
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    
    func createCell( data: Brands ){
        cellData = data
        
        
        setUpView()
        
        titleLable.text=cellData.brandName
        detailsLablel.text = cellData.brandNameAra
        detailsLablel.sizeToFit()
        
        var myOptions = SDWebImageOptions.fromCacheOnly
        
        let url = URL(string: "http://37.34.173.73:705/images/\(cellData.brandLogo ?? "")")
        
        myCellImage.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"), options: myOptions) { (image, error, _, url) in
            
        }
        
    }
    func setUpView(){
        let mainView = UIView()
        
        mainView.myBorder()
        self.contentView.addSubview(mainView)
        mainView.addSubview(titleLable)
        mainView.addSubview(detailsLablel)
        mainView.addSubview(myCellImage)
        mainView.addSubview(deleteRowbtn)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        mainView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        mainView.backgroundColor = UIColor(red: 244/255, green: 200/255, blue: 244/255, alpha: 1.0)
        
        
        myCellImage.translatesAutoresizingMaskIntoConstraints = false
        myCellImage.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 0).isActive = true
        myCellImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        myCellImage.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        myCellImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        myCellImage.contentMode = .scaleAspectFit
        
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.topAnchor.constraint(equalTo: mainView.topAnchor).isActive=true
        titleLable.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        titleLable.leadingAnchor.constraint(equalTo: myCellImage.trailingAnchor, constant: 5).isActive = true
        titleLable.textColor = .black
        titleLable.font = UIFont (name: "HelveticaNeue-UltraLight", size: 35)
        titleLable.textAlignment=NSTextAlignment.left
        
        
        
        
        detailsLablel.translatesAutoresizingMaskIntoConstraints = false
        detailsLablel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10).isActive=true
        //detailsLablel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive=true
        detailsLablel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,constant: -10).isActive = true
        detailsLablel.leadingAnchor.constraint(equalTo: myCellImage.trailingAnchor,constant: 10).isActive = true
        
        detailsLablel.textColor = .black
        detailsLablel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        detailsLablel.textAlignment = NSTextAlignment.left
        detailsLablel.numberOfLines = 0
        
        
        detailsLablel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        deleteRowbtn.translatesAutoresizingMaskIntoConstraints = false
        deleteRowbtn.topAnchor.constraint(equalTo: detailsLablel.bottomAnchor, constant: 10).isActive=true
        deleteRowbtn.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive=true
        deleteRowbtn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        deleteRowbtn.leadingAnchor.constraint(equalTo: myCellImage.trailingAnchor,constant: 10).isActive = true
        
        
        deleteRowbtn.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        deleteRowbtn.setTitle("Delete Row", for: .normal)
        
        deleteRowbtn.myBorder()
        deleteRowbtn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside);        mainView.layer.cornerRadius=10
    }
    
    @objc func doneButtonTapped() {
       
        cellDelegate.didPressButton(forTeam: cellData)
    }
    
}
extension UIView{
    func myBorder(){
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        self.layer.borderWidth = 2
        self.layer.borderColor=UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1).cgColor
    }
}
protocol YourCellDelegate  {
    func didPressButton(forTeam: Brands)
}
