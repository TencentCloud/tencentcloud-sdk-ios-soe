#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TIWLogLevel) {
    TIW_LOG_LEVEL_DEBUG = 1,
    TIW_LOG_LEVEL_INFO,
    TIW_LOG_LEVEL_WARN,
    TIW_LOG_LEVEL_ERROR,
    TIW_LOG_LEVEL_FATAL,
};

@interface TIWLoggerConfig : NSObject
/// native版本号
@property (nonatomic, strong) NSString *nativeSdkVersion;
/// web版本号
@property (nonatomic, strong) NSString *webSdkVersion;
/// 业务唯一标识
@property (nonatomic, strong) NSString *business;
/// 学校ID
@property (nonatomic, assign) NSInteger enterId;
/// 应用唯一标识
@property (nonatomic, assign) NSInteger sdkAppId;
/// 房间号
@property (nonatomic, assign) NSInteger roomId;
/// 用户ID
@property (nonatomic, strong) NSString *userId;
/// 日志存储目录
@property (nonatomic, strong) NSString *fileDir;
/// 内部字段
@property (nonatomic, strong) NSString *bundleId;
/// 内部字段
@property (nonatomic, strong) NSString *appVersion;
@end


@interface TIWLogParam : NSObject
/// 日志级别
@property (nonatomic, assign) TIWLogLevel level;
/// 模块名
@property (nonatomic, strong) NSString *module;
/// 文件名
@property (nonatomic, strong) NSString *fileName;
/// 函数名
@property (nonatomic, strong) NSString *funcName;
/// 行号
@property (nonatomic, assign) NSInteger line;
/// action名
@property (nonatomic, strong) NSString *actionName;
/// action参数
@property (nonatomic, strong) NSString *actionParam;
/// action补充字段
@property (nonatomic, strong) NSString *actionExt;
/// 错误码
@property (nonatomic, assign) NSInteger errorCode;
/// 错误信息
@property (nonatomic, strong) NSString *errorDesc;
/// 错误堆栈
@property (nonatomic, strong) NSString *errorStack;
/// 是否上报，不上报则只写本地文件
@property (nonatomic, assign) BOOL needReport;
///  自定义上报字段
@property (nonatomic, strong) NSString *jsonExt;
@end


@interface TIWLogger : NSObject
/**
 * 设置配置
 * @param config 配置
 */
- (void)setConfig:(TIWLoggerConfig *)config;
/**
 * 日志上报
 * @param param 参数
 */
- (void)log:(TIWLogParam *)param;
/**
 * 开始上报，记录当前时间点
 * @param label 唯一标识
 */
- (void)logStart:(NSString *)label;
/**
 * 结束上报
 * @param label 调用logStart是记录的唯一标识
 * @param param 参数
 */
- (void)logEnded:(NSString *)label param:(TIWLogParam *)param;
/**
 * 会话ID
 * @return 会话ID
 */
- (NSString *)getSessionId;
/**
 * 全局ID，设备唯一标识
 * @return 全局ID
 */
- (NSString *)getGlobalRandom;
/**
 * 版本号
 * @return 版本号
 */
+ (NSString *)getVersion;
/**
 * 控制台日志开关
 * @param enable 开关控制台
 */
- (void)enableConsole:(BOOL)enable;
@end
