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
@property (weak, nonatomic) IBOutlet UISegmentedControl *textModeSegment;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UITextField *coeffTextField;
@property (weak, nonatomic) IBOutlet UITextField *fragSizeTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *localRecordButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITextField *vadTextField;

@property (strong, nonatomic) TAIOralEvaluation *oralEvaluation;
@property (strong, nonatomic) NSString *fileName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostType;

@end

@implementation OralEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serverType.selectedSegmentIndex = 0;
    _hostType.selectedSegmentIndex = 0;
    _modeSegment.selectedSegmentIndex = 1;
    _transSegment.selectedSegmentIndex = 0;
    _storageSegment.selectedSegmentIndex = 0;
    _coeffTextField.text = @"1.0";
    _fragSizeTextField.text = @"1.0";
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    _fragSizeTextField.inputAccessoryView = toolbar;
    _coeffTextField.inputAccessoryView = toolbar;
    _vadTextField.inputAccessoryView = toolbar;
}

- (void)dismissKeyboard
{
    [_fragSizeTextField resignFirstResponder];
    [_coeffTextField resignFirstResponder];
    [_vadTextField resignFirstResponder];
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
    _fileName = [NSString stringWithFormat:@"taisdk_%ld.mp3", (long)[[NSDate date] timeIntervalSince1970]];
    if([_coeffTextField.text isEqualToString:@""]){
        [self setResponse:@"startRecordAndEvaluation:scoreCoeff invalid"];
        return;
    }
    self.responseTextView.text = @"";
    TAIOralEvaluationParam *param = [[TAIOralEvaluationParam alloc] init];
    param.sessionId = [[NSUUID UUID] UUIDString];
    param.appId = [PrivateInfo shareInstance].appId;
    param.soeAppId = [PrivateInfo shareInstance].soeAppId;
    param.secretId = [PrivateInfo shareInstance].secretId;
    param.secretKey = [PrivateInfo shareInstance].secretKey;
    param.token = [PrivateInfo shareInstance].token;
    param.workMode = (TAIOralEvaluationWorkMode)self.transSegment.selectedSegmentIndex;
    param.evalMode = (TAIOralEvaluationEvalMode)self.modeSegment.selectedSegmentIndex;
    param.serverType = (TAIOralEvaluationServerType)self.serverType.selectedSegmentIndex;
    param.hostType=(TAIOralEvaluationHostType)self.hostType.selectedSegmentIndex;
    param.scoreCoeff = [_coeffTextField.text intValue];
    param.fileType = TAIOralEvaluationFileType_Mp3;
    param.storageMode = (TAIOralEvaluationStorageMode)self.storageSegment.selectedSegmentIndex;
    param.textMode = (TAIOralEvaluationTextMode)self.textModeSegment.selectedSegmentIndex;
    param.refText = _inputTextField.text;
    param.audioPath = [NSString stringWithFormat:@"%@/%@.mp3", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], param.sessionId];
    if(param.workMode == TAIOralEvaluationWorkMode_Stream){
        param.timeout = 5;
        param.retryTimes = 5;
    }
    else{
        param.timeout = 30;
        param.retryTimes = 0;
    }
//    param.evalMode = 5;
//    param.refText = @"It was Mother’s Day. Tom stopped his car outside a flower shop. He wanted to order some beautiful flowers and ask the shop to deliver them to his mother. When he was about to enter the shop, he saw a little girl crying on the roadside. Tom walked to her and asked what happened. The girl told him she wanted to buy a rose for her mother, but she had no money. Hearing this, Tom took the girl’s hand and entered the flower shop. He ordered the flowers for his mother and bought a beautiful rose for the girl. Then he offered to drive the girl home. But the girl said that she was not going home; she was going to the bus station. Her mother worked in another town. She must go to her today with the rose. Tom was touched. He changed his mind. After driving the girl to the bus station, he returned to the shop, canceled the delivery service and bought a larger bunch of flowers and a box of chocolates. After Tom left the shop, he drove all the way to his mother’s place. He would give the flowers to his mother in person.";
//    param.keyword = @"It was Mother’s Day.| Tom went to a flower shop and wanted to ask the shop to send some flowers to his mother. | Tom saw a little girl crying on the roadside before he entered the shop. | The girl said she had no money to buy a rose for her mother. | He bought a rose for the girl and offered to drive her home. | The girl was going to give the rose to her mother in another town.  | Tom was touched and changed his mind. | He returned to the flower shop after driving the girl to the bus station. | He canceled the delivery service and bought more flowers and some chocolates. | He would give the flowers to his mother in person.";
    
    
//    param.evalMode = 2;
//    param.refText = @"I need a hat. | I want to buy a hat. | Yes, please. I want a hat.";
//    param.keyword = @"I need | hat # I want | buy | hat";
    
    CGFloat fragSize = [_fragSizeTextField.text floatValue];
    if(fragSize == 0){
        return;
    }
    TAIRecorderParam *recordParam = [[TAIRecorderParam alloc] init];
    recordParam.fragEnable = (param.workMode == TAIOralEvaluationWorkMode_Stream ? YES: NO);
    recordParam.fragSize = fragSize * 1024;
    recordParam.vadEnable = YES;
    recordParam.vadInterval = [_vadTextField.text intValue];
    [self.oralEvaluation setRecorderParam:recordParam];
    __weak typeof(self) ws = self;
    [self.oralEvaluation resetAvAudioSession:true];
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
    param.sessionId = [[NSUUID UUID] UUIDString];
    param.appId = [PrivateInfo shareInstance].appId;
    param.soeAppId = [PrivateInfo shareInstance].soeAppId;
    param.secretId = [PrivateInfo shareInstance].secretId;
    param.secretKey = [PrivateInfo shareInstance].secretKey;
    param.workMode = TAIOralEvaluationWorkMode_Once;
    param.evalMode = TAIOralEvaluationEvalMode_Sentence;
    param.serverType = TAIOralEvaluationServerType_English;
    param.scoreCoeff = 1.0;
    param.fileType = TAIOralEvaluationFileType_Mp3;
    param.storageMode = TAIOralEvaluationStorageMode_Disable;
    param.textMode = TAIOralEvaluationTextMode_Noraml;
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
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//    NSString *desc = [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    NSString *text = _responseTextView.text;
    text = [NSString stringWithFormat:@"%@\n%@ %@", text, [format stringFromDate:[NSDate date]], string];
    _responseTextView.text = text;
}

#pragma mark - oral evaluation delegate
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onEvaluateData:(TAIOralEvaluationData *)data result:(TAIOralEvaluationRet *)result error:(TAIError *)error
{
    if(error.code != TAIErrCode_Succ){
        [_recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    }
    NSString *log = [NSString stringWithFormat:@"oralEvaluation:seq:%ld, end:%ld, error:%@, ret:%@", (long)data.seqId, (long)data.bEnd, error, result];
    [self setResponse:log];
}

- (void)onEndOfSpeechInOralEvaluation:(TAIOralEvaluation *)oralEvaluation
{
    [self setResponse:@"onEndOfSpeech"];
    [self onRecord:nil];
}

- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onVolumeChanged:(NSInteger)volume
{
    self.progressView.progress = volume / 120.0;
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
