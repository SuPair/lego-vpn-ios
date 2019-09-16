//
//  TenonP2pLib.swift
//  TenonVPN
//
//  Created by actantion on 2019/9/12.
//  Copyright © 2019 zly. All rights reserved.
//

import Foundation
import libp2p
import NEKit

class TenonP2pLib {
    static let sharedInstance = TenonP2pLib()
    
    func InitP2pNetwork (
            _ local_ip: String,
            _ local_port: Int) -> (local_country: String, prikey: String, account_id: String) {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file!
        let conf_path = path + "/lego.conf"
        let log_path = path + "/lego.log"
        let log_conf_path = path + "/log4cpp.properties"
        let res = LibP2P.initP2pNetwork(
                local_ip,
                local_port,
                "id:122.112.234.133:9001,id:119.3.15.76:9001,id:119.3.73.78:9001",
                conf_path,
                log_path,
                log_conf_path) as String

        let array : Array = res.components(separatedBy: ",")
        if (array.count != 3) {
            return ("", "", "")
        }
        
        return (array[0], array[2], array[1])
    }
    
    func GetSocketId() -> Int {
        return LibP2P.getSocketId()
    }
    
    func GetVpnNodes(_ country: String, _ route: Bool) -> String {
        let res = LibP2P.getVpnNodes(country, route) as String
        return res
    }
    
    func GetTransactions() -> String {
        let res = LibP2P.getTransactions() as String
        return res
    }
    
    func GetBalance() -> UInt64 {
        let res = LibP2P.getBalance() as UInt64
        return res
    }
    
    func ResetTransport(_ local_ip: String, _ local_port: Int) {
        LibP2P.resetTransport(local_ip, local_port)
    }
    
    func GetPublicKey() -> String {
        let res = LibP2P.getPublicKey()as String
        return res
    }
    
    private init() {
        
    }
}
