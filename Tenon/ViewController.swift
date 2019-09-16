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
import NEKit
import libp2p

class ViewController: BaseViewController {
    @IBOutlet weak var imgConnect: UIImageView!
    @IBOutlet weak var lbConnect: UILabel!
    @IBOutlet weak var vwBackHub: CircleProgress!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lbNodes: UILabel!
    var isHub:Bool = false
    var popMenu:FWPopMenu!
    var isClick:Bool = false
    var timer:Timer!
    var isNetChange:Bool = false
    
    var popBottomView:FWBottomPopView!
    var local_country: String = ""
    var local_private_key: String = ""
    var local_account_id: String = ""
    var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England"]
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb"]
    var local_choose_method = "aes-128-cfb"
    var local_choose_method_ex = "AES128CFB"
    
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
        self.btnChoseCountry.layer.cornerRadius = 4
        self.vwBackHub.proEndgress = 0.0
        self.vwBackHub.proStartgress = 0.0

        let url = URL(string:"https://www.baidu.com");
        URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
            (data, rsp, error) in
            //do some thing
            print("visit network ok.");
        }).resume()
        
        // test for p2p library
        
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        local_country = res.local_country
        local_private_key = res.prikey
        local_account_id = res.account_id
        print("local country:" + res.local_country)
        print("private key:" + res.prikey)
        print("account id:" + res.account_id)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
 
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func onVPNStatusChanged(){
        isNetChange = true
        if VpnManager.shared.vpnStatus == .on{
            self.btnConnect.backgroundColor = APP_COLOR
            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xA1FDEE))
            imgConnect.image = UIImage(named: "connected")
            lbConnect.text = "Connect"
        }else{
            self.btnConnect.backgroundColor = UIColor(rgb: 0xDAD8D9)
            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xE4E2E3))
            imgConnect.image = UIImage(named: "connect")
            lbConnect.text = "Connected"
        }
    }
    @IBAction func clickConnect(_ sender: Any) {
        if VpnManager.shared.vpnStatus == .off {
            self.vwBackHub.proEndgress = 0.0
            self.vwBackHub.proStartgress = 0.0
            self.playAnimotion()
            
            let choosed_country = "US"
            var route_node = getOneRouteNode(country: local_country)
            if (route_node.ip.isEmpty) {
                route_node = getOneRouteNode(country: choosed_country)
                if (route_node.ip.isEmpty) {
                    for country in self.iCon {
                        route_node = getOneRouteNode(country: country)
                        if (!route_node.ip.isEmpty) {
                            break
                        }
                    }
                    
                }
            }
            
            if (route_node.ip.isEmpty) {
                return
            }
            VpnManager.shared.ip_address = route_node.ip
            VpnManager.shared.port = Int(route_node.port) as! Int
            
            var vpn_node = getOneVpnNode(country: choosed_country)
            if (vpn_node.ip.isEmpty) {
                for country in self.iCon {
                    vpn_node = getOneVpnNode(country: country)
                    if (!vpn_node.ip.isEmpty) {
                        break
                    }
                }
            }
            
            if (vpn_node.ip.isEmpty) {
                return
            }
            print("rotue: \(route_node.ip):\(route_node.port)")
            print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
            print("transactions:" + TenonP2pLib.sharedInstance.GetTransactions())
            let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
            VpnManager.shared.public_key = LibP2P.getPublicKey() as String
            VpnManager.shared.enc_method = local_choose_method + "," + String(vpn_ip_int) + "," + vpn_node.port
            VpnManager.shared.password = vpn_node.passwd
            VpnManager.shared.algorithm = local_choose_method_ex;
            VpnManager.shared.connect()
        } else {
            self.vwBackHub.proEndgress = 0.0
            self.vwBackHub.proStartgress = 0.0
            VpnManager.shared.disconnect()
            self.playAnimotion()
        }
    }
    @IBAction func clickChoseCountry(_ sender: Any) {
        if self.isClick == true {
            self.popMenu.removeFromSuperview()
        }else{
            self.popMenu = FWPopMenu.init(frame:CGRect(x: self.btnChoseCountry.left, y: self.btnChoseCountry.bottom, width: self.btnChoseCountry.width, height: SCREEN_HEIGHT/2))
            self.popMenu.loadCell("CountryTableViewCell", countryCode.count)
            self.popMenu.callBackBlk = {(cell,indexPath) in
                let tempCell:CountryTableViewCell = cell as! CountryTableViewCell
                tempCell.backgroundColor = APP_COLOR
                tempCell.lbNodeCount.text = "123 nodes"
                tempCell.lbCountryName.text = self.countryCode[indexPath.row]
                tempCell.imgIcon.image = UIImage(named:self.iCon[indexPath.row])
                return tempCell
            }
            self.popMenu.clickBlck = {(idx) in
                if idx != -1{
                    self.btnChoseCountry.setTitle(self.countryCode[idx], for: UIControl.State.normal)
                    self.imgCountryIcon.image = UIImage(named:self.iCon[idx])
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
        if self.btnAccount.isUserInteractionEnabled == true{
            self.popBottomView = FWBottomPopView.init(frame:CGRect(x: 0, y: SCREEN_HEIGHT - (SCREEN_HEIGHT/3*2), width: SCREEN_WIDTH, height: SCREEN_HEIGHT/3*2))
            self.popBottomView.loadCell("AccountSetTableViewCell","AccountSetHeaderTableViewCell", 3)
            self.popBottomView.callBackBlk = {(cell,indexPath) in
                if indexPath.section == 0 {
                    let tempCell:AccountSetHeaderTableViewCell = cell as! AccountSetHeaderTableViewCell
                    tempCell.tfPrivateKeyValue.text = "e16b61208d000580805cfd62d6247563208b50510ee241d18f7ef36d280df213"
                    tempCell.lbAccountAddress.text = "1E79BfxiDFMXRGSsX2sx2v1vEoc5H4QtE6"
                    return tempCell
                }
                else{
                    let tempCell:AccountSetTableViewCell = cell as! AccountSetTableViewCell
                    tempCell.layer.masksToBounds = true
                    tempCell.layer.cornerRadius = 8
                    tempCell.lbDateTime.text = "20190905 11:01:20"
                    tempCell.lbType.text = "TRAN"
                    tempCell.lbAccount.text = "6DCASDLKJQWIOEDANSLDJLKJQWLDNALSJD37"
                    tempCell.lbAmount.text = "4"
                    return tempCell
                }
            }
            
            self.popBottomView.clickBlck = {(idx) in
                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                UIView.animate(withDuration: 0.4, animations: {
                    self.popBottomView.top = SCREEN_HEIGHT
                }, completion: { (Bool) in
                    self.popBottomView.removeFromSuperview()
                })
            }
            self.popBottomView.top = self.popBottomView.height
            self.view.addSubview(self.popBottomView)
            UIView.animate(withDuration: 0.4, animations: {
                self.popBottomView.top = 0
            }, completion: { (Bool) in
                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
            })
        }
    }
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    func getOneRouteNode(country: String) -> (ip: String, port: String) {
        let res_str = LibP2P.getVpnNodes(country, true) as String
        if (res_str.isEmpty) {
            return ("", "")
        }
        
        let node_arr: Array = res_str.components(separatedBy: ",")
        if (node_arr.count <= 0) {
            return ("", "")
        }
        
        let rand_pos = randomCustom(min: 0, max: node_arr.count)
        let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
        if (node_info_arr.count < 5) {
            return ("", "")
        }
        
        return (node_info_arr[0], node_info_arr[2])
    }
    
    func getOneVpnNode(country: String) -> (ip: String, port: String, passwd: String) {
        let res_str = LibP2P.getVpnNodes(country, false) as String
        if (res_str.isEmpty) {
            return ("", "", "")
        }
        
        let node_arr: Array = res_str.components(separatedBy: ",")
        if (node_arr.count <= 0) {
            return ("", "", "")
        }
        
        let rand_pos = randomCustom(min: 0, max: node_arr.count)
        let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
        if (node_info_arr.count < 5) {
            return ("", "", "")
        }
        
        return (node_info_arr[0], node_info_arr[1], node_info_arr[3])
    }
    
    func stopAnimotion() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    @objc func playAnimotion() {
        if self.timer == nil {
            self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(startAnimotion), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        }
    }
    @objc func startAnimotion() {
        if self.vwBackHub.proStartgress == 0.0 {
            self.vwBackHub.proEndgress += 0.1
            if self.vwBackHub.proEndgress > 1{
                self.vwBackHub.proEndgress = 1
                self.vwBackHub.proStartgress += 0.1
            }
        }else{
            self.vwBackHub.proStartgress += 0.1
            if self.vwBackHub.proStartgress > 1.0{
                if isNetChange == true{
                    stopAnimotion()
                    isNetChange = false
                }else{
                    self.vwBackHub.proEndgress = 0.0
                    self.vwBackHub.proStartgress = 0.0
                }
            }
        }
    }
}
