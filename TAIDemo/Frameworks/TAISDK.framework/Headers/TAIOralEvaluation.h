//
//  TAIOralEvaluation.h
//  TAISDK
//
//  Created by kennethmiao on 2018/12/25.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAICommonParam.h"
#import "TAIError.h"

typedef NS_ENUM(NSInteger, TAIOralEvaluationWorkMode)
{
    //流式传输
    TAIOralEvaluationWorkMode_Stream = 0,
    //一次性传输
    TAIOralEvaluationWorkMode_Once = 1,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationTextMode)
{
    //普通文本
    TAIOralEvaluationTextMode_Noraml = 0,
    //音素结构文本
    TAIOralEvaluationTextMode_Phoneme = 1,
    //音素注册模式
    TAIOralEvaluationTextMode_Phoneme_Register = 2,
};


typedef NS_ENUM(NSInteger, TAIOralEvaluationEvalMode)
{
    //单词模式
    TAIOralEvaluationEvalMode_Word = 0,
    //句子模式
    TAIOralEvaluationEvalMode_Sentence = 1,
    //段落模式
    TAIOralEvaluationEvalMode_Paragraph = 2,
    //自由模式
    TAIOralEvaluationEvalMode_Free = 3,
    //单词纠错模式
    TAIOralEvaluationEvalMode_Word_Fix = 4,
    //情景评测模式
    TAIOralEvaluationEvalMode_Scene = 5,
    //多分支评测模式
    TAIOralEvaluationEvalMode_Multi_Branch = 6,
    //单词实时模式
    TAIOralEvaluationEvalMode_Word_RealTime = 7,
    //拼音模式
    TAIOralEvaluationEvalMode_Spelling = 8,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationFileType)
{
    //pcm
    TAIOralEvaluationFileType_Raw = 1,
    //wav
    TAIOralEvaluationFileType_Wav = 2,
    //mp3
    TAIOralEvaluationFileType_Mp3 = 3,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationStorageMode)
{
    //关闭存储
    TAIOralEvaluationStorageMode_Disable = 0,
    //开启存储
    TAIOralEvaluationStorageMode_Enable = 1,
    //永久存储（请提工单备案）
    TAIOralEvaluationStorageMode_Permanent = 2,
    //自定义存储（请提工单备案）
    TAIOralEvaluationStorageMode_Custom = 3,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationServerType)
{
    //英文
    TAIOralEvaluationServerType_English = 0,
    //中文
    TAIOralEvaluationServerType_Chinese = 1,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationHostType)
{
    //国内
    TAIOralEvaluationHostType_Common = 0,
    //海外
    TAIOralEvaluationHostType_Overseas = 1,
};

typedef NS_ENUM(NSInteger, TAIOralEvaluationAudioPermission)
{
    //不容许SDK对AVAudioSession 进行更改, 由App进行SetActive和SetCategory
    TAIOralEvaluationAudioPermissionNone = 1 << 0,
    //容许SDK对AVAudioSession进行SetCategory和Options。
    TAIOralEvaluationAudioPermissionSetCategoryOptions = 1 << 1,
    //容许SDK对AVAudioSession进行SetActive。
    TAIOralEvaluationAudioPermissionSetActive = 1 << 2,
    //容许SDK对AVAudioSession同时进行SetCategory和SetActive，默认值
    TAIOralEvaluationAudioPermissionAll = TAIOralEvaluationAudioPermissionSetCategoryOptions | TAIOralEvaluationAudioPermissionSetActive,
};

@interface TAIOralEvaluationParam : TAICommonParam
//业务应用id（默认为default）
@property (nonatomic, strong) NSString *soeAppId;
//唯一标识一次评测
@property (nonatomic, strong) NSString *sessionId;
//传输模式
@property (nonatomic, assign) TAIOralEvaluationWorkMode workMode;
//评估模式
@property (nonatomic, assign) TAIOralEvaluationEvalMode evalMode;
//数据类型（内部录制仅支持mp3）
@property (nonatomic, assign) TAIOralEvaluationFileType fileType;
//音频存储
@property (nonatomic, assign) TAIOralEvaluationStorageMode storageMode;
//语言类型
@property (nonatomic, assign) TAIOralEvaluationServerType serverType;
//host类型
@property (nonatomic, assign) TAIOralEvaluationHostType hostType;
//文本模式
@property (nonatomic, assign) TAIOralEvaluationTextMode textMode;
//苛刻指数[1.0-4.0]
@property (nonatomic, assign) float scoreCoeff;
//被评估的文本
@property (nonatomic, strong) NSString *refText;
//输出断句中间结果
@property (nonatomic, assign) BOOL sentenceInfoEnabled;
//本地音频路径，只支持 mp3 格式，如果此值有效，stopRecordAndEvaluation 后将保存本次录制的音频数据到此路径下，如（aaa/bbb/ccc.mp3）
@property (nonatomic, strong) NSString *audioPath;

//是否开启字母映射，纠错模式下
@property (nonatomic, assign) BOOL isFixOn;

//主题词和关键词
@property (nonatomic, strong) NSString *keyword;
- (NSDictionary *)toJsonObj;
- (NSString *)toJsonStr;
@end


@interface TAIOralEvaluationPhoneInfo : NSObject
//当前音节语音起始时间点，单位为ms
@property (nonatomic, assign) int beginTime;
//当前音节语音终止时间点，单位为ms
@property (nonatomic, assign) int endTime;
//音节发音准确度，取值范围[-1, 100]，当取-1时指完全不匹配
@property (nonatomic, assign) float pronAccuracy;
//当前音节是否检测为重音
@property (nonatomic, assign) BOOL detectedStress;
//当前音节
@property (nonatomic, strong) NSString *phone;
//当前音节是否应为重音
@property (nonatomic, assign) BOOL stress;
//参考音素，在单词诊断模式下，代表标准音素
@property (nonatomic, strong) NSString *referencePhone;
//音素对应的字母
@property (nonatomic, strong) NSString *rLetter;
//当前词与输入语句的匹配情况，0：匹配单词、1：新增单词、2：缺少单词、3：错读的词、4：未录入单词。
@property (nonatomic, assign) int matchTag;

- (NSDictionary *)toJsonObj;
- (NSString *)toJsonStr;

@end



@interface TAIOralEvaluationWord : NSObject
//当前单词语音起始时间点，单位为ms
@property (nonatomic, assign) int beginTime;
//当前单词语音终止时间点，单位为ms
@property (nonatomic, assign) int endTime;
//单词发音准确度，取值范围[-1, 100]，当取-1时指完全不匹配
@property (nonatomic, assign) float pronAccuracy;
//单词发音流利度，取值范围[0, 1]
@property (nonatomic, assign) float pronFluency;
//当前词
@property (nonatomic, strong) NSString *word;
//当前词与输入语句的匹配情况，0:匹配单词、1：新增单词、2：缺少单词
@property (nonatomic, assign) int matchTag;
//音节评估详情
@property (nonatomic, strong) NSArray<TAIOralEvaluationPhoneInfo *> *phoneInfos;
//参考词
@property (nonatomic, strong) NSString *referenceWord;

- (NSDictionary *)toJsonObj;
- (NSString *)toJsonStr;
@end


@interface TAIOralEvaluationSentenceInfo : NSObject
//句子序号，在段落、自由说模式下有效，表示断句序号，最后的综合结果的为-1.
@property (nonatomic, assign) int sentenceId;
//详细发音评估结果
@property (nonatomic, strong) NSArray<TAIOralEvaluationWord *> *words;
//发音精准度，取值范围[-1, 100]，当取-1时指完全不匹配，当为句子模式时，是所有已识别单词准确度的加权平均值，在reftext中但未识别出来的词不计入分数中
@property (nonatomic, assign) float pronAccuracy;
//发音流利度，取值范围[0, 1]，当为词模式时，取值无意义；当为流式模式且请求中IsEnd未置1时，取值无意义
@property (nonatomic, assign) float pronFluency;
//发音完整度，取值范围[0, 1]，当为词模式时，取值无意义；当为流式模式且请求中IsEnd未置1时，取值无意义
@property (nonatomic, assign) float pronCompletion;
//建议评分，取值范围[0,100]，评分方式为建议评分 = 准确度（pronAccuracyfloat） 完整度（pronCompletionfloat）（2 - 完整度（pronCompletionfloat）），如若评分策略不符合请参考Words数组中的详细分数自定义评分逻辑
@property (nonatomic, assign) float suggestedScore;

- (NSDictionary *)toJsonObj;
- (NSString *)toJsonStr;

@end


@interface TAIOralEvaluationRet : NSObject
//唯一标识一次评测
@property (nonatomic, strong) NSString *sessionId;
//唯一请求ID
@property (nonatomic, strong) NSString *requestId;
//单词发音准确度，取值范围[-1, 100]，当取-1时指完全不匹配
@property (nonatomic, assign) float pronAccuracy;
//单词发音流利度，取值范围[0, 1]
@property (nonatomic, assign) float pronFluency;
//发音完整度，取值范围[0, 1]，当为词模式时，取值无意义
@property (nonatomic, assign) float pronCompletion;
//保存语音音频文件的下载地址（TAIOralEvaluationStorageMode_Enable有效）
@property (nonatomic, strong) NSString *audioUrl;
//详细发音评估结果
@property (nonatomic, strong) NSArray<TAIOralEvaluationWord *> *words;
//建议评分，取值范围[0,100]
//评分方式为建议评分 = 准确度（PronAccuracyfloat）× 完整度（PronCompletionfloat）×（2 - 完整度（PronCompletionfloat））
//如若评分策略不符合请参考Words数组中的详细分数自定义评分逻辑。
@property (nonatomic, assign) float suggestedScore;
//断句中间结果
@property (nonatomic, strong) NSArray<TAIOralEvaluationSentenceInfo*> *sentenceInfoSet;

//单词发音流利度，取值范围[0, 1]
@property (nonatomic, assign) NSInteger refTextId;
/**
* 主题词命中标志，0表示没命中，1表示命中
* 注意：此字段可能返回 null，表示取不到有效值。
*/
@property (nonatomic, strong) NSArray<NSNumber *> *keyWordHits;

/**
* 负向主题词命中标志，0表示没命中，1表示命中
* 注意：此字段可能返回 null，表示取不到有效值。
*/
@property (nonatomic, strong) NSArray<NSNumber *> *unKeyWordHits;

- (NSDictionary *)toJsonObj;
- (NSString *)toJsonStr;

@end

@interface TAIOralEvaluationData : NSObject
//数据seq，从1开始
@property (nonatomic, assign) NSInteger seqId;
//属否是最后分片数据
@property (nonatomic, assign) BOOL bEnd;
//音频数据
@property (nonatomic, strong) NSData *audio;
@end

@interface TAIRecorderParam : NSObject
//是否开启分片，默认YES
@property (nonatomic, assign) BOOL fragEnable;
//分片大小，默认1024，建议为1024的整数倍，范围【1k-10k】
@property (nonatomic, assign) NSInteger fragSize;
//是否开启静音检测，默认NO
@property (nonatomic, assign) BOOL vadEnable;
//静音检测时间间隔，单位【ms】
@property (nonatomic, assign) NSInteger vadInterval;
//静音检测分贝阈值
@property (nonatomic, assign) NSInteger db;

@end

@class TAIOralEvaluation;
@protocol TAIOralEvaluationDelegate <NSObject>
/**
 * 评估结果回调
 * @param oralEvaluation 评测对象
 * @param data 音频数据
 * @param result 评估结果（最后一个分片返回，其他分片为nil）
 * @param error 错误信息
 */
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation
        onEvaluateData:(TAIOralEvaluationData *)data
                result:(TAIOralEvaluationRet *)result
                 error:(TAIError *)error;
/**
 * 静音检测回调
 * @param oralEvaluation 评测对象
 * @brief 检测到静音内部不会停止录制，业务层可以根据此回调主动停止录制或提示用户
 */
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation  onEndOfSpeechInOralEvaluation:(BOOL)isSpeak;
/**
 * 音量分贝变化
 * @param oralEvaluation 评测对象
 * @param volume 分贝大小
 * @brief volume范围【0-120】
 */
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onVolumeChanged:(NSInteger)volume;
@end


typedef void (^TAIOralEvaluationCallback)(TAIError *error);


@interface TAIOralEvaluation : NSObject
/**
 * 录制数据回调
 */
@property (nonatomic, weak) id<TAIOralEvaluationDelegate> delegate;

@property (nonatomic, assign)TAIOralEvaluationAudioPermission avAudioSessionPermission; // 默认值TAIOralEvaluationAudioPermissionAll
/**
 * 开始录制和评测
 * @param param 参数（内部录制仅支持mp3）
 * @param callback 回调
 */
- (void)startRecordAndEvaluation:(TAIOralEvaluationParam *)param callback:(TAIOralEvaluationCallback)callback;
/**
 * 结束录制和评测
 * @param callback 回调
 */
- (void)stopRecordAndEvaluation:(TAIOralEvaluationCallback)callback;

- (void)resetAvAudioSession:(BOOL)isResetAVAudioSession;

/**
 * 属否正在录制
 * @return BOOL 是否录制
 */
- (BOOL)isRecording;

/**
 * 设置分片大小，建议为1024的整数倍，范围【1k-10k】，默认为1024*1
 * @param size 分片大小
 */
- (void)setFragSize:(NSInteger)size DEPRECATED_MSG_ATTRIBUTE("Please usee setRecordParam:");

/**
 * 设置录制参数
 * @param param 录制参数
 */
- (void)setRecorderParam:(TAIRecorderParam *)param;
/**
 * 口语评测（外部录制）
 * @param param 参数
 * @param data 音频数据（三种格式目前仅支持16k采样率16bit编码单声道，如有不一致可能导致评估不准确或失败）
 * @param callback 回调
 */
- (void)oralEvaluation:(TAIOralEvaluationParam *)param data:(TAIOralEvaluationData *)data callback:(TAIOralEvaluationCallback)callback;
/**
 * 获取签名所需字符串
 * @param timestamp 时间戳
 * @return NSString 签名
 */
- (NSString *)getStringToSign:(NSInteger)timestamp;
@end
