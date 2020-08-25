//
//  TAIMathCorrection.h
//  TAISDK
//
//  Created by kennethmiao on 2018/12/25.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TAICommonParam.h"
#import "TAIError.h"


@interface TAIMathCorrectionItem : NSObject
/**
 *  计算结果
 */
@property (nonatomic, assign) BOOL result;
/**
 *  识别的算式在图片上的位置信息
 */
@property (nonatomic, assign) CGRect rect;
/**
 *  识别的算式
 */
@property (nonatomic, strong) NSString *formula;
/**
 *  推荐的答案，暂不支持多个关系运算符、无关系运算符、单位换算错题的推荐答案返回
 */
@property (nonatomic, strong) NSString *answer;
/**
 *  算式题型编号，如加减乘除四则题型，具体题型及编号如下：
 *  1 加减乘除四则
 *  2 加减乘除已知结果求运算因子
 *  3 判断大小
 *  4 约等于估算
 *  5 带余数除法
 *  6 分数四则运算
 *  7 单位换算
 *  8 竖式加减法
 *  9 竖式乘除法
 *  10 脱式计算
 *  11 解方程
 *  注意：此字段可能返回空，表示取不到有效值。
 */
@property (nonatomic, strong) NSString *expressionType;
/**
 *  文本行置信度
 *  此字段可能返回 0，表示取不到有效值
 */
@property (nonatomic, assign) float itemConf;
@end


@interface TAIMathCorrectionRet : NSObject
//sessionId
@property (nonatomic, strong) NSString *sessionId;
//items
@property (nonatomic, strong) NSArray<TAIMathCorrectionItem *> *items;
@end



@interface TAIMathCorrectionParam : TAICommonParam
/**
 * 业务应用 id
 * 默认为 default
 */
@property (nonatomic, strong) NSString *hcmAppId;
/**
 *  sessionId
 */
@property (nonatomic, strong) NSString *sessionId;
/**
 *  图片数据
 */
@property (nonatomic, strong) NSData *imageData;
/**
 *  图片 url，与 imageData 参数二者填一
 */
@property (nonatomic, strong)  NSString *url;
/**
 * 横屏拍摄开关，若开启则支持传输横屏拍摄的图片
 * 默认 false
 */
@property (nonatomic, assign) BOOL supportHorizontalImage;
/**
 * 拒绝非速算图（如风景图、人物图）开关，若开启，则遇到非速算图会快速返回拒绝的结果，
 * 但极端情况下可能会影响评估结果（比如算式截图贴到风景画里可能被判为非速算图直接返回了）
 * 默认 false
 */
@property (nonatomic, assign) BOOL rejectNonArithmeticImage;
/**
 * 是否展开耦合算式中的竖式计算
 * 默认 false
 */
@property (nonatomic, assign) BOOL enableDispRelatedVertical;
/**
 * 是否展示竖式算式的中间结果和格式控制字符
 * 默认 false
 */
@property (nonatomic, assign) BOOL enableDispMidresult;
/**
 * 是否开启pdf识别，默认开启
 * 默认 true
 */
@property (nonatomic, assign) BOOL enablePdfRecognize;
/**
 * pdf页码，从0开始
 * 默认0
 */
@property (nonatomic, assign) int pdfPageIndex;
/**
 * 是否返回LaTex
 * 默认为0返回普通格式，设置成1返回LaTex格式
 */
@property (nonatomic, assign) int laTex;
@end




typedef void (^TAIMathCorrectionCallback)(TAIError *error, TAIMathCorrectionRet *result);

@interface TAIMathCorrection : NSObject
/**
 * 速算题目批改
 * @param param 参数
 * @param callback 回调
 */
- (void)mathCorrection:(TAIMathCorrectionParam *)param callback:(TAIMathCorrectionCallback)callback;
/**
 * 获取签名所需字符串
 * @param timestamp 时间戳
 * @return NSString 签名
 */
- (NSString *)getStringToSign:(NSInteger)timestamp;
@end
