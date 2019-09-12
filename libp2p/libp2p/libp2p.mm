//
//  libp2p.m
//  libp2p
//
//  Created by actantion on 2019/9/11.
//  Copyright © 2019 actantion. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "libp2p.h"
#include "vpn_client.h"

@implementation LibP2P

+(void)SayHello {
    NSLog(@"hello framework world.");
}

+(NSString*) InitP2pNetwork:(NSString*) local_ip : (NSInteger)local_port : (NSString*)bootstrap : (NSString*)conf_path : (NSString*)log_path : (NSString*) log_conf_path {
    std::string tmp_local_ip = std::string([local_ip UTF8String]);
    uint16_t tmp_local_port = (uint16_t)local_port;
    std::string tmp_bootstarp = std::string([bootstrap UTF8String]);
    std::string tmp_conf_path = std::string([conf_path UTF8String]);
    std::string tmp_log_path = std::string([log_path UTF8String]);
    std::string tmp_log_conf_path = std::string([log_conf_path UTF8String]);
    std::string res = lego::client::VpnClient::Instance()->Init(tmp_local_ip, tmp_local_port, tmp_bootstarp, tmp_conf_path, tmp_log_path, tmp_log_conf_path);
    lego::client::VpnClient::Instance();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(NSInteger) GetSocketId {
    return lego::client::VpnClient::Instance()->GetSocket();
}

+(NSString*) GetVpnNodes:(NSString*) country: (Boolean) route {
    std::vector<lego::client::VpnServerNodePtr> nodes;
    std::string tmp_country = std::string([country UTF8String]);
    lego::client::VpnClient::Instance()->GetVpnServerNodes(tmp_country, 16, route, nodes);
    std::string vpn_svr = "";
    for (uint32_t i = 0; i < nodes.size(); ++i) {
        vpn_svr += nodes[i]->ip + ":";
        vpn_svr += std::to_string(nodes[i]->svr_port) + ":";
        vpn_svr += std::to_string(nodes[i]->route_port) + ":";
        vpn_svr += nodes[i]->seckey + ":";
        vpn_svr += nodes[i]->pubkey + ":";
        vpn_svr += nodes[i]->dht_key + ":";
        if (i != nodes.size() - 1) {
            vpn_svr += ",";
        }
    }
    NSString *res_str = [NSString stringWithCString:vpn_svr.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(NSString*) GetTransactions {
    std::string res = lego::client::VpnClient::Instance()->Transactions(0, 64);
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

+(UInt64) GetBalance {
    return lego::client::VpnClient::Instance()->GetBalance();
}

+(void) ResetTransport:(NSString*) local_ip: (NSInteger)local_port {
    std::string tmp_local_ip = std::string([local_ip UTF8String]);
    lego::client::VpnClient::Instance()->ResetTransport(tmp_local_ip, local_port);
}

+(NSString*) GetPublicKey {
    std::string res = lego::client::VpnClient::Instance()->GetPublicKey();
    NSString *res_str = [NSString stringWithCString:res.c_str() encoding:[NSString defaultCStringEncoding]];
    return res_str;
}

@end
