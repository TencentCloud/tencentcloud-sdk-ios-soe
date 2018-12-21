//
//  ViewController.m
//  TSOEDemo
//
//  Created by kennethmiao on 2018/12/10.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import "ViewController.h"
#import <TencentSOE/TencentSOE.h>

@interface ViewController () <AudioQueueRecorderDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *audioPath;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *formatSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transSegment;
@property (weak, nonatomic) IBOutlet UIButton *fragRecordButton;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

#pragma mark - sdk param
@property (nonatomic, strong) TXRecorder *recorder;
@property (nonatomic, strong) TXVoiceVerification *verification;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, assign) BOOL isRecording;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSdk];
}

#pragma mark - sdk
- (void)initSdk
{
    ------此处编译不通过，需要填写自己申请的secretId和secretKey
    [TXTencentSOE shareTencentSOE].VoiceSecretID = @"";
    [TXTencentSOE shareTencentSOE].VoiceSecretKey = @"";
    [TXTencentSOE shareTencentSOE].Region = @"";
    [TXTencentSOE shareTencentSOE].SoeAppId = @"";
    [TXTencentSOE shareTencentSOE].isLongLifesession = @"1";
    [TXTencentSOE shareTencentSOE].requestDomain = @"soe.tencentcloudapi.com";
}

- (void)startRecord
{
    if(_isRecording){
        _isRecording = NO;
        [_recorder stopRecording];
        [_fragRecordButton setTitle:@"开始分片录制" forState:UIControlStateNormal];
        return;
    }
    
    _recorder = [[TXRecorder alloc] init];
    _recorder.delegate = self;
    _isRecording = YES;
    _responseTextView.text = @"";
    [TXTencentSOE shareTencentSOE].seqID = 0;
    [TXTencentSOE shareTencentSOE].isVoiceVerifyInit= 0;
    [_recorder startRecording];
    [_fragRecordButton setTitle:@"停止分片录制" forState:UIControlStateNormal];
}

- (void)initVoice:(NSString *)data isEnd:(BOOL)isEnd
{
    _sessionId = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *refText = _inputTextField.text;
    TXVoiceVerificationWorkMode workMode = [self getWorkMode];
    TXVoiceVerificationEvaluationMode evalMode = [self getEvalMode];
    __weak typeof(self) ws = self;
    [_verification oralProcessInitWithSessionID:_sessionId RefText:refText workMode:workMode evaluationMode:evalMode ScoreCoeff:1 result:^(TXVoiceVerification *voiceVerification, NSDictionary * _Nullable result, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [ws setResponse:[NSString stringWithFormat:@"%@", result]];
        [ws vertifyVoice:data isEnd:isEnd];
    }];
}

- (void)vertifyVoice:(NSString *)date isEnd:(BOOL)isEnd
{
    TXVoiceVerificationFileType type = [self getFileType];
    __weak typeof(self) ws = self;
    [_verification oralProcessTransmitWithVoiceFileType:type userVoiceData:@[date] sessionID:_sessionId isEnd:isEnd result:^(TXVoiceVerification *voiceVerification, NSDictionary * _Nullable result, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [ws setResponse:[NSString stringWithFormat:@"%@", result]];
    }];
}
#pragma mark - sdk help
- (TXVoiceVerificationFileType)getFileType
{
    NSInteger index = _formatSegment.selectedSegmentIndex;
    TXVoiceVerificationFileType type = TXVoiceVerificationFileTypeMp3;
    switch (index) {
        case 0:
            type = TXVoiceVerificationFileTypeRaw;
            break;
        case 1:
            type = TXVoiceVerificationFileTypeWav;
            break;
        case 2:
            type = TXVoiceVerificationFileTypeMp3;
            break;
        default:
            break;
    }
    return type;
}

- (TXVoiceVerificationWorkMode)getWorkMode
{
    NSInteger index = _transSegment.selectedSegmentIndex;
    TXVoiceVerificationWorkMode mode = TXVoiceVerificationWorkModeStreaming;
    switch (index) {
        case 0:
            mode = TXVoiceVerificationWorkModeStreaming;
            break;
        case 1:
            mode = TXVoiceVerificationWorkModeNoneStreaming;
            break;
        default:
            break;
    }
    return mode;
}


- (TXVoiceVerificationEvaluationMode)getEvalMode
{
    NSInteger index = _modeSegment.selectedSegmentIndex;
    TXVoiceVerificationEvaluationMode mode = TXVoiceVerificationEvaluationModeWord;
    switch (index) {
        case 0:
            mode = TXVoiceVerificationEvaluationModeWord;
            break;
        case 1:
            mode = TXVoiceVerificationEvaluationModeSentence;
            break;
        default:
            break;
    }
    return mode;
}

- (void)setResponse:(NSString *)string
{
    NSString *desc = [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    NSString *text = _responseTextView.text;
    text = [NSString stringWithFormat:@"%@\n%@", text, desc];
    _responseTextView.text = text;
}
#pragma mark - audio delegate
- (void)AudioQueueRecorder:(TXRecorder *)recorder mp3Data:(NSData *)mp3Data isEnd:(int)isEnd
{
    _verification = [[TXVoiceVerification alloc] init];
    NSString *dataStr = [TXBase64File getBase64StringWithFileData:mp3Data];
    if(![TXTencentSOE shareTencentSOE].isVoiceVerifyInit){
        [TXTencentSOE shareTencentSOE].isVoiceVerifyInit = 1;
        [self initVoice:dataStr isEnd:isEnd];
    }
    else{
        [self vertifyVoice:dataStr isEnd:isEnd];
    }
}

#pragma mark - button event
- (IBAction)onPickAudio:(id)sender {
    
}

- (IBAction)onRecord:(id)sender {
    [self startRecord];
}

- (IBAction)onFragRecord:(id)sender {
    [self startRecord];
}
#pragma mark - ui delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
