//
//  ViewController.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
import NetworkExtension
import Eureka

//import TenonVPNConnection

class ViewController: BaseViewController {
    @IBOutlet weak var vwHub: UIView!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lbNodes: UILabel!
    var isHub:Bool = false
    var popMenu:FWPopMenu!
    var isClick:Bool = false
    var timer:Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TenonVPN"
        self.addNavigationView()
        self.hiddenBackBtn(bHidden: true)
        self.navigationController?.navigationBar.isHidden = true
        self.btnConnect.layer.masksToBounds = true
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        
        self.vwHub.layer.masksToBounds = true
        self.vwHub.layer.cornerRadius = self.vwHub.width/2
        
        self.btnAccount.layer.masksToBounds = true
        self.btnAccount.layer.cornerRadius = 20
        self.btnChoseCountry.layer.masksToBounds = true
        self.btnChoseCountry.layer.cornerRadius = 4
        self.playAnimotion()
//        let test = VpnClient()
//        test.printSocket("123123123")
//        VpnClient.GetSocket()
    }
    @IBAction func clickConnect(_ sender: Any) {
        if self.timer == nil{
            self.playAnimotion()
        }else{
            self.stopAnimotion()
        }
    }
    @IBAction func clickChoseCountry(_ sender: Any) {
        if self.isClick == true {
            self.popMenu.removeFromSuperview()
        }else{
            var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England"]
            var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb"]
            
            self.popMenu = FWPopMenu.init(frame:CGRect(x: self.btnChoseCountry.left, y: self.btnChoseCountry.bottom, width: self.btnChoseCountry.width, height: SCREEN_HEIGHT/2))
            self.popMenu.loadCell("CountryTableViewCell", countryCode.count)
            self.popMenu.callBackBlk = {(cell,indexPath) in
                let tempCell:CountryTableViewCell = cell as! CountryTableViewCell
                tempCell.backgroundColor = APP_COLOR
                tempCell.lbNodeCount.text = "123 nodes"
                tempCell.lbCountryName.text = countryCode[indexPath.row]
                tempCell.imgIcon.image = UIImage(named:iCon[indexPath.row])
                return tempCell
            }
            self.popMenu.clickBlck = {(idx) in
                if idx != -1{
                    self.btnChoseCountry.setTitle(countryCode[idx], for: UIControl.State.normal)
                    self.imgCountryIcon.image = UIImage(named:iCon[idx])
                    self.lbNodes.text = "155 nodes"
                }
                
                self.popMenu.removeFromSuperview()
                self.isClick = !self.isClick
            }
            self.view.addSubview(self.popMenu)
        }
        
        self.isClick = !self.isClick
    }
    
    @IBAction func clickAccountSetting(_ sender: Any) {
        NSLog("account setting")
        let acountSet = AcountSetViewController()
        acountSet.title = "Account Setting"
        self.navigationController?.pushViewController(acountSet, animated: true)
        
    }
    
    func stopAnimotion() {
        self.timer.invalidate()
        self.timer = nil
    }
    func playAnimotion() {
        if self.timer == nil {
            self.timer = Timer(timeInterval: 0.8, target: self, selector: #selector(startAnimotion), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        }
    }
    @objc func startAnimotion() {
        let offsetX:CGFloat = 0.0
        let offsetY:CGFloat = 0.0
        if self.isHub == false {
            self.vwHub.transform = __CGAffineTransformMake(0.8, 0, 0, 0.8, offsetX, offsetY)
            UIView.animate(withDuration: 0.7, animations: {
                self.vwHub.alpha = 1.0
                self.vwHub.transform = CGAffineTransform.identity
            }) { (Bool) in
                self.isHub = true
            }
        }
        else{
            self.vwHub.transform = __CGAffineTransformMake(1, 0, 0, 1, offsetX, offsetY)
            UIView.animate(withDuration: 0.7, animations: {
                self.vwHub.transform = CGAffineTransform.init(a: 0.8, b: 0, c: 0, d: 0.8, tx: offsetX, ty: offsetY)
            }) { (Bool) in
                self.isHub = false
            }
        }
        //        if (self.imgHand.alpha == 0.99f) {
        //            // 动画由小变大
        //            self.imgHand.transform = CGAffineTransformMake(0.8, 0, 0, 0.8, offsetX, offsetY);
        //
        //            [UIView animateWithDuration:0.8f animations:^{
        //                self.imgHand.alpha = 1.0f;
        //                self.imgHand.transform = CGAffineTransformIdentity;
        //
        //                } completion:^(BOOL finished) {
        //
        //                }];
        //        } else {
        //            // 动画由大变小
        //            self.imgHand.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        //            [UIView animateWithDuration:0.8f animations:^{
        //                self.imgHand.transform = CGAffineTransformMake(0.8, 0, 0, 0.8, offsetX, offsetY);
        //                self.imgHand.alpha = 0.99f;
        //                } completion:^(BOOL finished) {
        //                self.imgHand.transform = CGAffineTransformIdentity;
        //
        //                }];
        //        }
    }
}
