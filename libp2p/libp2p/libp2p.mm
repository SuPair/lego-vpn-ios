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
@end
