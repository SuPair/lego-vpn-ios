//
//  TenonP2pLib.swift
//  TenonVPN
//
//  Created by actantion on 2019/9/12.
//  Copyright © 2019 zly. All rights reserved.
//

import Foundation
import libp2p

class TenonP2pLib {
    static let sharedInstance = TenonP2pLib()
    
    func InitP2pNetwork (
            _ local_ip: String,
            _ local_port: Int) -> (local_country: String, prikey: String, account_id: String) {
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = file!
        let conf_path = path + "/lego.conf"
        let log_path = path + "/lego.log"
        let log_conf_path = path + "/log4cpp.properties"
        LibP2P.sayHello();
        let res = LibP2P.initP2pNetwork(
                local_ip,
                local_port,
                "id:122.112.234.133:9001,id:119.3.15.76:9001,id:119.3.73.78:9001",
                conf_path,
                log_path,
                log_conf_path) as String;

        let array : Array = res.components(separatedBy: ",")
        print("\(array)")
        if (array.count != 3) {
            return ("", "", "")
        }
        return (array[0], array[1], array[2]);
    }
    
    private init() {
        
    }
}
