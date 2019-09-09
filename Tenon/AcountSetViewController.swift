//
//  AcountSetViewController.swift
//  TenonVPN
//
//  Created by friend on 2019/9/6.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class AcountSetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var vwMiddle: UIView!
    
    @IBOutlet weak var lbPrivateKey: UILabel!
    @IBOutlet weak var lbAccountAddress: UILabel!
    @IBOutlet weak var lbBanlanceLego: UILabel!
    @IBOutlet weak var lbBalanceMoney: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var array: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lbPrivateKey.text = "e16b61208d000580805cfd62d6247563208b50510ee241d18f7ef36d280df213"
        self.lbAccountAddress.text = "1E79BfxiDFMXRGSsX2sx2v1vEoc5H4QtE6"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.loadCell("AccountSetTableViewCell")
        self.vwMiddle.layer.masksToBounds = true
        self.vwMiddle.layer.cornerRadius = 8
        self.array.append("123")
        self.array.append("123")
        self.array.append("123")
        self.tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AccountSetTableViewCell = tableView.reUseCell("AccountSetTableViewCell") as! AccountSetTableViewCell
        if indexPath.row%2 != 0 {
            cell.backgroundColor = UIColor(red: 9, green: 222, blue: 202, alpha: 1)
        }else{
            cell.backgroundColor = UIColor.white
        }
        cell.lbDateTime.text = "20190905 11:01:20"
        cell.lbType.text = "TRAN"
        cell.lbAccount.text = "6DCASDLKJQWIOEDANSLDJLKJQWLDNALSJD37"
        cell.lbAmount.text = "4"
        return cell
    }
}
