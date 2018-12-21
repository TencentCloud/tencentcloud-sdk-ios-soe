//
//  TXVoiceVerification.h
//  Voice
//
//  Created by lc on 2018/9/18.
//  Copyright © 2018年 lc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXVoiceVerification;

typedef NS_ENUM(NSUInteger, TXVoiceVerificationWorkMode) {
    TXVoiceVerificationWorkModeStreaming,      // 流式传输
    TXVoiceVerificationWorkModeNoneStreaming,  // 非流式
};

typedef NS_ENUM(NSUInteger, TXVoiceVerificationEvaluationMode) {
    TXVoiceVerificationEvaluationModeWord,     // 单词
    TXVoiceVerificationEvaluationModeSentence, // 语句
};

typedef NS_ENUM(NSUInteger, TXVoiceVerificationFileType) {
    TXVoiceVerificationFileTypeRaw,     // raw
    TXVoiceVerificationFileTypeWav,     // wav(默认)
    TXVoiceVerificationFileTypeMp3,     // mp3
};

typedef void (^TXResultBlock)(TXVoiceVerification *voiceVerification, NSDictionary * _Nullable result, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface TXVoiceVerification : NSObject

// 发音评估初始化接口
- (void)oralProcessInitWithSessionID:(NSString *)sessionID
                             RefText:(NSString *)RefText
                            workMode:(TXVoiceVerificationWorkMode)workMode
                      evaluationMode:(TXVoiceVerificationEvaluationMode)evaluationMode
                          ScoreCoeff:(float)ScoreCoeff
                              result:(TXResultBlock)block;

// 上传语音并校验
- (void)oralProcessTransmitWithVoiceFileType:(TXVoiceVerificationFileType)voiceFileType
                               userVoiceData:(NSArray<NSString *> *)userVoiceDataArray
                                   sessionID:(NSString *)sessionID
                                       isEnd:(int)isEnd
                                      result:(TXResultBlock)block;

@end
