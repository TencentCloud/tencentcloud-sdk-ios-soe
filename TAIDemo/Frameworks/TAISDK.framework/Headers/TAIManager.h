//
//  TAIManager.h
//  TAISDK
//
//  Created by kennethmiao on 2018/11/27.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TIWLogger/TIWLogger.h>

@interface TAIManager : NSObject

/*
 获取版本号
 */
+ (NSString *)getVersion;

+ (instancetype)sharedInstance;

- (TIWLogger *)getTiwLog:(NSString *)appId;

- (TIWLogger *)getTiwLog;
@end
