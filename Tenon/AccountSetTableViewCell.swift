//
//  AccountSetTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/9.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class AccountSetTableViewCell: UITableViewCell {
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbAccount: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
