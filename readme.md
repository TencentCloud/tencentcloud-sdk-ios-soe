# 智聆口语评测iOS SDK功能设计与使用说明文档:

## 一、TencentSOE.fremework
腾讯云智聆口语评测（Smart Oral Evaluation）英语口语评测服务，是基于英语口语类教育培训场景和腾讯云的语音处理技术，应用特征提取、声学模型和语音识别算法，为儿童和成人提供高准确度的英语口语发音评测。支持单词和句子模式的评测，多维度反馈口语表现。支持单词和句子评测模式，可广泛应用于英语口语类教学应用中。
本SDK为智聆口语测评的iOS版本，封装了对智聆口语测评网络API的调用及本地音频文件处理，并提供简单的录音功能，使用者可以专注于从业务切入，方便简洁地进行二次开发。
本文档只对iOS SDK进行描述，详细的网络API说明请见在线文档https://cloud.tencent.com/document/product/884

## 二、使用说明
#### 2.1 工程及demo源码地址
https://github.com/TencentCloud/tencentcloud-sdk-ios-soe
#### 2.2 获取密钥
secretId和secretKey是使用SDK的安全凭证，通过以下方式获取
![](http://dldir1.qq.com/hudongzhibo/taisdk/document/taisdk_cloud_1.png)
#### 2.3 本SDK的主文件为TencentSOE.framework，依赖第三方库：lame.framework,将二者直接引入项目中即可
第三方库lame.framework的主要目的是为了实现文件类型转换
#### 2.4 导入工程
在github上下载本工程并导入到项目工程中
![](http://dldir1.qq.com/hudongzhibo/taisdk/document/taisdk_ios_2.png)

## 三、sdk整体使用流程（参见TSOEDemo工程）
#### 3.1 初始化sdk（参见demo中的initSdk）
```
    [TXTencentSOE shareTencentSOE].VoiceSecretID = @"";
    [TXTencentSOE shareTencentSOE].VoiceSecretKey = @"";
    [TXTencentSOE shareTencentSOE].Region = @"";
    [TXTencentSOE shareTencentSOE].SoeAppId = @"";
    [TXTencentSOE shareTencentSOE].isLongLifesession = @"1";
    [TXTencentSOE shareTencentSOE].requestDomain = @"soe.tencentcloudapi.com";
```

#### 3.2 开始分片录制(参见demo中的startRecord)
```
    [TXTencentSOE shareTencentSOE].seqID = 0;
    [TXTencentSOE shareTencentSOE].isVoiceVerifyInit= 0;
    [_recorder startRecording];
```

#### 3.3 同时处理分片回调的数据并进行口语评测(参见demo中的AudioQueueRecorder回调)
```
    _verification = [[TXVoiceVerification alloc] init];
    NSString *dataStr = [TXBase64File getBase64StringWithFileData:mp3Data];
    if(![TXTencentSOE shareTencentSOE].isVoiceVerifyInit){
        [TXTencentSOE shareTencentSOE].isVoiceVerifyInit = 1;
        [self initVoice:dataStr isEnd:isEnd];
    }
    else{
        [self vertifyVoice:dataStr isEnd:isEnd];
    }
```

#### 3.4 最后一个分片完成后，处理口语评测的结果（参见demo中的vertifyVoice返回）
```
    TXVoiceVerificationFileType type = [self getFileType];
    __weak typeof(self) ws = self;
    [_verification oralProcessTransmitWithVoiceFileType:type userVoiceData:@[date] sessionID:_sessionId isEnd:isEnd result:^(TXVoiceVerification *voiceVerification, NSDictionary * _Nullable result, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [ws setResponse:[NSString stringWithFormat:@"%@", result]];
    }];
```

## 四、模块设计说明
TencentSOE.fremework有四大模块：配置信息，录音，对文件进行base64加密，校验语音。
以下是四大模块的详细说明：
#### 4.1 模块1：配置信息（TXTencentSOE）
TXTencentSOE是一个单例，需要配置申请的SecretID和SecretKey，代码如下：
```
    // 初始化语音评测单例
    [TXTencentSOE shareTencentSOE].VoiceSecretID = @"";//填写在官网申请的secretid
    [TXTencentSOE shareTencentSOE].VoiceSecretKey = @"";//填写在官网申请的secretkey
    [TXTencentSOE shareTencentSOE].Region = @"";
    [TXTencentSOE shareTencentSOE].SoeAppId = @"";//填写soeappid
    [TXTencentSOE shareTencentSOE].isLongLifesession = @"1";
    [TXTencentSOE shareTencentSOE].requestDomain = @"soe.tencentcloudapi.com";//可根据实际选择就近的请求域名
```
#### 4.2 模块2：录音(TXRecorder)
TXRecorder是对录音功能的封装，这里依赖了系统库AudioToolbox和第三方库lame，这里包括了三个对象方法，分别是：
```
@selector(startRecording:)//开始录音;
@selector(stopRecording)//停止录音;
@selector(AudioQueueRecorder:(TXRecorder *)recorder mp3Data:(NSData *)mp3Data isEnd:(int)isEnd)//回调录制数据到上层app
```
#### 4.3 模块3：对文件进行base64加密（TXBase64File）
TXBase64File需要关注一个方法
```
@selector(getBase64StringWithFileData:)//对一段data做base64编码
```
#### 4.4 模块4：校验语音(TXVoiceVerification)
```
TXVoiceVerification//用来校验语音，并进行口语评测，分着两部分：初始化接口，发音数据传输接口。详细说明如下：
```
初始化接口：
```
@selector(oralProcessInitWithSessionID:RefText:workMode:evaluationMode:ScoreCoeff:result:)
```
参数说明：
* sessionID：语音段唯一标识，一个完整语音一个SessionId
* RefText：被评估语音对应的文本
* workMode：语音输入模式，0流式分片，1非流式一次性评估，分别与枚举值相对应
* evaluationMode：评估模式，0:词模式, 1:句子模式，当为词模式评估时，能够提供每个音节的评估信息，当为句子模式时，能够提供完整度和流利度信息。
* ScoreCoeff：评价苛刻指数，取值为[1.0 - 4.0]范围内的浮点数，用于平滑不同年龄段的分数，1.0为小年龄段，4.0为最高年龄段
* block：接口运行结果返回的block，在block里的result对应结果，error对应错误信息

发音数据传输接口：
```
@selector(oralProcessTransmitWithVoiceFileType:userVoiceData:sessionID:result:)
```
参数说明：
* voiceFileType：文件类型，有raw,wav,mp3三种类型
* userVoiceDataArray：要校验的语音数组，采用分片传输，只需要传入只有一个元素的数组就可以了，这个参数的传输依赖于TXBase64File生成的字符串与数组
* sessionID：同初始化接口的sessionID
* block：同初始化接口的block





