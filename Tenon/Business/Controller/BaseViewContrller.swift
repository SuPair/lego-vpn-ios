//
//  BaseViewContrller.swift
//  TenonVPN
//
//  Created by friend on 2019/9/9.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
import YYKit

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let APP_COLOR = UIColor(red: 9.0/255.0, green: 222.0/255.0, blue: 202.0/255.0, alpha: 1)
let NAVIGATION_HEIGHT = 44.0;

class BaseViewController: UIViewController {
    var btnBack:EXButton!
    var vwNavigation:UIView!
    func hiddenBackBtn(bHidden:Bool){
        self.btnBack.isHidden = bHidden;
        
    }
    func IS_IPHONE_X() -> Bool {
        return self.isIphoneX()
    }
    func STATUS_BAR_HEIGHT() -> Double {
        if self.IS_IPHONE_X() == true {
            return 44.0
        }else{
            return 20.0
        }
    }
    @objc func clickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func addNavigationView(){
        self.vwNavigation = UIView.init(frame: CGRect.init(x: 0, y: 0, width:SCREEN_WIDTH , height:CGFloat(NAVIGATION_HEIGHT + self.STATUS_BAR_HEIGHT())))
        self.vwNavigation.backgroundColor = APP_COLOR;
        
        let lbTitle:UILabel = UILabel.init(frame: CGRect.init())
        lbTitle.text = self.title
        lbTitle.sizeToFit()
        lbTitle.bottom = self.vwNavigation.bottom - 11.0
        lbTitle.centerX = SCREEN_WIDTH/2.0
        lbTitle.textColor = UIColor.white
        
        self.btnBack = EXButton.init(frame: CGRect.init(x: 16, y: 0, width: 10, height: 18))
        self.btnBack.setImage(UIImage(named: "nav_btn_w_back"), for: UIControl.State.normal)
        self.btnBack.addTarget(nil, action: #selector(clickBack), for: UIControl.Event.touchUpInside)
        self.btnBack.centerY = lbTitle.centerY
        self.vwNavigation.addSubview(self.btnBack)
        self.vwNavigation.addSubview(lbTitle)
        self.view.addSubview(self.vwNavigation)
    }
    
    public func isIphoneX()->Bool{
        if #available(iOS 11.0, *){
            let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!;
            if (window.safeAreaInsets.bottom > 0.0){
                return true
            }else{
                return false
            }
        }
        else{
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
