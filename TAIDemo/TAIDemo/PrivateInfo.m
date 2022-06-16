//
//  PrivateInfo.m
//  TAIDemo
//
//  Created by kennethmiao on 2019/2/26.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//

#import "PrivateInfo.h"

@implementation PrivateInfo

+ (instancetype)shareInstance
{
    static PrivateInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        自行传入appId, secretId, secretKey参数
        instance = [[PrivateInfo alloc] init];
        instance.appId = @"";
        instance.secretId = @"";
        instance.secretKey = @"";
        instance.token = @"";
        instance.soeAppId = @"";
        instance.hcmAppId = @"";
    });
    return instance;
}
@end
