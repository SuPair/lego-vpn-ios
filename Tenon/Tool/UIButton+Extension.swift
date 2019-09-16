//
//  UIButton+Extension.swift
//  TenonVPN
//
//  Created by friend on 2019/9/9.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
class EXButton:UIButton{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let zqmargin:CGFloat = -30
        let clickArea = bounds.insetBy(dx: zqmargin, dy: zqmargin)
        return clickArea.contains(point)
    }
}
