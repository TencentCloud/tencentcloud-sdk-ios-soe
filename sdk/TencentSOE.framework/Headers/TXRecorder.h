//
//  TXRecorder.h
//  TencentSOE
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TXRecorder;

@protocol AudioQueueRecorderDelegate < NSObject>

@optional
//回调mp3数据
-(void)AudioQueueRecorder:(TXRecorder *)recorder mp3Data:(NSData *)mp3Data isEnd:(int)isEnd;

@end



@interface TXRecorder : NSObject

@property (nonatomic, weak) id<AudioQueueRecorderDelegate> delegate;


//开始录制
-(void)startRecording;

//结束录制
-(void)stopRecording;

@end

NS_ASSUME_NONNULL_END
