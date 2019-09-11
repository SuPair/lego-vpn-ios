//
//  CountryTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/6.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbCountryName: UILabel!
    @IBOutlet weak var lbNodeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.lbNodeCount.textColor = APP_COLOR
//        self.lbCountryName.textColor = APP_COLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
