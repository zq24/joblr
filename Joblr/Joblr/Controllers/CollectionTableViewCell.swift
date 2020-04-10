//
//  CollectionTableViewCell.swift
//  Joblr
//
//  Created by 王锴文 on 11/12/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Company: UILabel!
    @IBOutlet weak var JobType: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Created_at: UILabel!
    @IBOutlet weak var Logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
