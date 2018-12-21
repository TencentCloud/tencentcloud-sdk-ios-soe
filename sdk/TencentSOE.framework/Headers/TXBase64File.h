//
//  TXBase64File.h
//  YunnanTravel
//
//  Created by lc on 2018/10/10.
//  Copyright © 2018年 lc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TXReadDataBlock)(BOOL isSuccess, NSString *message);

@interface TXBase64File : NSObject

/**
 *  @param  filePath 文件的路径
 *  @return 文件存在且有效则返回整个文件base64字符串，否则则返回nil
 */
+ (NSString * _Nullable)getBase64StringWithFilePath:(NSString *)filePath;


/**
 *  @param  filePath 文件的路径
 *  @param  dataPackageSize 单个数据包的长度，单位为Byte，取值须为[4 * 1024, 1024 * 1024]之间，否则会在 block 参数里回调
 *  @param block 可以查看成功与否
 *  @return 文件存在且有效则返回存放base64字符串的数组，否则则返回nil
 */
+ (NSArray<NSString *> * _Nullable)getBase64StringArrayWithFilePath:(NSString *)filePath dataPackageSize:(int)dataPackageSize completion:(TXReadDataBlock)block;

/**
 *  @param  fileData mp3数据
 *  @return 返回整mp3数据base64后的字符串
 */
+ (NSString *)getBase64StringWithFileData:(NSData *)fileData;

@end
