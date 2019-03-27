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
        instance = [[PrivateInfo alloc] init];
        自行传入appId, secretId, secretKey等参数
        instance.appId = @"";
        instance.soeAppId = @"";
        instance.hcmAppId = @"";
        instance.secretId = @"";
        instance.secretKey = @"";
    });
    return instance;
}
@end
