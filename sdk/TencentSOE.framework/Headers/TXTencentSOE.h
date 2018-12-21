//
//  TXTencentSOE.h
//  RLAudioRecord
//
//  Created by lc on 2018/10/15.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXTencentSOE : NSObject

@property (nonatomic, copy)   NSString *VoiceSecretID;
@property (nonatomic, copy)   NSString *VoiceSecretKey;
@property (nonatomic, assign)   int isVoiceVerifyInit;
@property (nonatomic, copy)   NSString *sessionID;
@property (nonatomic, assign) int seqID;
@property (nonatomic, copy)   NSString *Region;
@property (nonatomic, copy)   NSString *SoeAppId;
@property (nonatomic, copy)   NSString *isLongLifesession;
@property (nonatomic, copy)   NSString *requestDomain;


+ (instancetype)shareTencentSOE;

@end
