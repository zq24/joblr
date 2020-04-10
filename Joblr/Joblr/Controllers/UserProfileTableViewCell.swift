//
//  UserProfileTableViewCell.swift
//  Joblr
//
//  Created by Jingru Gao on 11/15/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import Foundation

class UserProfileCell: UITableViewCell {

    var content: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(ProfileDetailedLabel)
        ProfileDetailedLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ProfileDetailedLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ProfileDetailedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    
    
    let ProfileDetailedLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  UIColor.darkGray
//        label.backgroundColor =  UIColor.init(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
//        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let content = content {
            ProfileDetailedLabel.text = content
        }
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
