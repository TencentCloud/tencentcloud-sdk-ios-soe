//
//  OralEvaluationViewController.m
//  TAIDemo
//
//  Created by kennethmiao on 2018/12/26.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import "OralEvaluationViewController.h"
#import <TAISDK/TAIOralEvaluation.h>
#import "PrivateInfo.h"

@interface OralEvaluationViewController () <TAIOralEvaluationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *storageSegment;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UITextField *coeffTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *localRecordButton;

@property (strong, nonatomic) TAIOralEvaluation *oralEvaluation;

@end

@implementation OralEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serverType.selectedSegmentIndex = 0;
    _modeSegment.selectedSegmentIndex = 1;
    _transSegment.selectedSegmentIndex = 0;
    _storageSegment.selectedSegmentIndex = 0;
    _coeffTextField.text = @"1.0";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - button event
- (IBAction)onRecord:(id)sender {
    if([self.oralEvaluation isRecording]){
        __weak typeof(self) ws = self;
        [self.oralEvaluation stopRecordAndEvaluation:^(TAIError *error) {
            [ws setResponse:[NSString stringWithFormat:@"stopRecordAndEvaluation:%@", error]];
            [ws.recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
        }];
        return;
    }
    if([_coeffTextField.text isEqualToString:@""]){
        [self setResponse:@"startRecordAndEvaluation:scoreCoeff invalid"];
        return;
    }
    self.responseTextView.text = @"";
    TAIOralEvaluationParam *param = [[TAIOralEvaluationParam alloc] init];
    param.sessionId = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    param.appId = [PrivateInfo shareInstance].appId;
    param.secretId = [PrivateInfo shareInstance].secretId;
    param.secretKey = [PrivateInfo shareInstance].secretKey;
    param.workMode = (TAIOralEvaluationWorkMode)self.transSegment.selectedSegmentIndex;
    param.evalMode = (TAIOralEvaluationEvalMode)self.modeSegment.selectedSegmentIndex;
    param.serverType = (TAIOralEvaluationServerType)self.serverType.selectedSegmentIndex;
    param.scoreCoeff = [_coeffTextField.text intValue];
    param.fileType = TAIOralEvaluationFileType_Mp3;
    param.storageMode = (TAIOralEvaluationStorageMode)self.storageSegment.selectedSegmentIndex;
    param.refText = _inputTextField.text;
    __weak typeof(self) ws = self;
    [self.oralEvaluation startRecordAndEvaluation:param callback:^(TAIError *error) {
        if(error.code == TAIErrCode_Succ){
            [ws.recordButton setTitle:@"停止录制" forState:UIControlStateNormal];
        }
        [ws setResponse:[NSString stringWithFormat:@"startRecordAndEvaluation:%@", error]];
    }];
}

- (IBAction)onLocalRecord:(id)sender {
    self.responseTextView.text = @"";
    TAIOralEvaluationParam *param = [[TAIOralEvaluationParam alloc] init];
    param.sessionId = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    param.appId = [PrivateInfo shareInstance].appId;
    param.secretId = [PrivateInfo shareInstance].secretId;
    param.secretKey = [PrivateInfo shareInstance].secretKey;
    param.workMode = TAIOralEvaluationWorkMode_Once;
    param.evalMode = TAIOralEvaluationEvalMode_Sentence;
    param.serverType = TAIOralEvaluationServerType_English;
    param.scoreCoeff = 1.0;
    param.fileType = TAIOralEvaluationFileType_Mp3;
    param.storageMode = TAIOralEvaluationStorageMode_Disable;
    param.refText = @"hello guagua";
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"hello_guagua" ofType:@"mp3"];
    TAIOralEvaluationData *data = [[TAIOralEvaluationData alloc] init];
    data.seqId = 1;
    data.bEnd = YES;
    data.audio = [NSData dataWithContentsOfFile:mp3Path];
    __weak typeof(self) ws = self;
    [self.oralEvaluation oralEvaluation:param data:data callback:^(TAIError *error) {
        [ws setResponse:[NSString stringWithFormat:@"oralEvaluation:%@", error]];
    }];
}


- (void)setResponse:(NSString *)string
{
//    NSString *desc = [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    NSString *text = _responseTextView.text;
    text = [NSString stringWithFormat:@"%@\n%@", text, string];
    _responseTextView.text = text;
}

#pragma mark - oral evaluation delegate
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onEvaluateData:(TAIOralEvaluationData *)data result:(TAIOralEvaluationRet *)result error:(TAIError *)error
{
    if(error.code != TAIErrCode_Succ){
        [_recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    }
    [self setResponse:[NSString stringWithFormat:@"oralEvaluation:seq:%ld, end:%ld, error:%@, ret:%@", (long)data.seqId, (long)data.bEnd, error, result]];
}

#pragma mark - ui delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (TAIOralEvaluation *)oralEvaluation
{
    if(!_oralEvaluation){
        _oralEvaluation = [[TAIOralEvaluation alloc] init];
        _oralEvaluation.delegate = self;
    }
    return _oralEvaluation;
}
@end
