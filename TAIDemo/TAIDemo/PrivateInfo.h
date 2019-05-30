//
//  PrivateInfo.h
//  TAIDemo
//
//  Created by kennethmiao on 2019/2/26.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateInfo : NSObject
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *secretId;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *soeAppId;
@property (nonatomic, strong) NSString *hcmAppId;
+ (instancetype)shareInstance;
@end
