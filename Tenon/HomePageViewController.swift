//
//  HomePageViewController.swift
//  TenonVPN
//
//  Created by friend on 2019/9/6.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var tfIpAddress: UITextField!
    @IBOutlet weak var tfPort: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCrypto: UITextField!
    let defaultStand = UserDefaults.init(suiteName: "group.com.zly.BearSS")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func clickConnect(_ sender: Any) {
        VpnManager.shared.ip_address = self.tfIpAddress.text ?? "";
        VpnManager.shared.port = Int(self.tfPort.text ?? "0")!
        VpnManager.shared.password = self.tfPassword.text ?? ""
        VpnManager.shared.algorithm = self.tfCrypto.text ?? "AES256CFB"
        if VpnManager.shared.vpnStatus == .on{
            VpnManager.shared.disconnect()
        }
        else{
            VpnManager.shared.connect()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
