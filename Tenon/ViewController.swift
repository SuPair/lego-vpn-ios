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

class ViewController: BaseViewController {
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lbNodes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TenonVPN"
        self.addNavigationView()
        self.hiddenBackBtn(bHidden: true)
        self.navigationController?.navigationBar.isHidden = true
        self.btnConnect.layer.masksToBounds = true
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        self.btnAccount.layer.masksToBounds = true
        self.btnAccount.layer.cornerRadius = 20
        self.btnChoseCountry.layer.masksToBounds = true
        self.btnChoseCountry.layer.cornerRadius = 20
        
    }
    @IBAction func clickChoseCountry(_ sender: Any) {
        let choseCountry = ChoseCountryViewController()
        choseCountry.title = "Chose Country"
        choseCountry.callBackBlk = {(str,icon,nodes) in
            NSLog(str + "+" + icon)
            self.btnChoseCountry.setTitle(str, for: UIControl.State.normal)
            self.imgCountryIcon.image = UIImage(named:icon)
            self.lbNodes.text = nodes+" nodes"
        }
        self.navigationController?.pushViewController(choseCountry, animated: true)
    }
    
    @IBAction func clickAccountSetting(_ sender: Any) {
        NSLog("account setting")
        let acountSet = AcountSetViewController()
        acountSet.title = "Account Setting"
        self.navigationController?.pushViewController(acountSet, animated: true)
        
    }
    
    
}
