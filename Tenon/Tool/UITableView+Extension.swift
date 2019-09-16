//
//  UITableView+Extension.swift
//  TenonVPN
//
//  Created by friend on 2019/9/9.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
extension UITableView {
    func loadCell(_ cellName:String) -> Void {
        NSLog(cellName)
        self.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    func reUseCell(_ cellname:String) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellname)!
    }
}
