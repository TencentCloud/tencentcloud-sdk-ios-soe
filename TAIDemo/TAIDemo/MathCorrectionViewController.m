//
//  MathCorrectionViewController.m
//  TAIDemo
//
//  Created by kennethmiao on 2018/11/28.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import "MathCorrectionViewController.h"
#import <TAISDK/TAIMathCorrection.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PrivateInfo.h"

@interface MathCorrectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *pickButton;
@property (weak, nonatomic) IBOutlet UIButton *recoButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UITextField *formulaField;
@property (strong, nonatomic) TAIMathCorrectionRet *correctionRet;
@property (strong, nonatomic) TAIMathCorrection *mathCorrection;

@end

@implementation MathCorrectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)onClick:(id)sender {
    __weak typeof(self) ws = self;
    [_indicatorView startAnimating];
    //初始化参数
    TAIMathCorrectionParam *param = [[TAIMathCorrectionParam alloc] init];
    param.sessionId = [[NSUUID UUID] UUIDString];
    param.imageData = UIImageJPEGRepresentation(_imageView.image, 0.5);
    param.appId = [PrivateInfo shareInstance].appId;
    param.secretId = [PrivateInfo shareInstance].secretId;
    param.secretKey = [PrivateInfo shareInstance].secretKey;
    [self.mathCorrection mathCorrection:param callback:^(TAIError *error, TAIMathCorrectionRet *result) {
        //返回TAIEvaluationRet数组
        [ws.indicatorView stopAnimating];
        if(error.code != 0){
            [[[UIAlertView alloc] initWithTitle:@"提示" message:error.desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        ws.correctionRet = result;
        int i = 1;
        for (TAIMathCorrectionItem *item in result.items) {
            CGRect rect = [self convertFrame:item.rect];
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.layer.borderWidth = 2.0;
            if(item.result){
                view.layer.borderColor = [UIColor greenColor].CGColor;
            }
            else{
                view.layer.borderColor = [UIColor redColor].CGColor;
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [view addGestureRecognizer:tap];
            view.tag = i++;
            view.backgroundColor = [UIColor clearColor];
            [ws.view addSubview:view];
        }
        [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"识别到%ld个算式", (long)result.items.count] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}
- (IBAction)onPick:(id)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    for (UIView *sub in self.view.subviews) {
        if(sub.tag != 0){
            [sub removeFromSuperview];
        }
    }
    _formulaField.text = @"点击图片方框查看算式";
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=  image.imageOrientation;
        if(imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        _imageView.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTap:(UIGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    TAIMathCorrectionItem *item = _correctionRet.items[index - 1];
    if (item.result) {
        _formulaField.text = [NSString stringWithFormat:@"正确：%@", item.formula];
    }
    else {
        _formulaField.text = [NSString stringWithFormat:@"错误：%@, 答案：%@", item.formula, item.answer];
    }
}

- (CGRect)convertFrame:(CGRect)rect
{
    CGSize size = _imageView.image.size;
    CGSize frameSize = _imageView.frame.size;
    CGFloat scale = 0;
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;
    if(size.height / size.width > frameSize.height / frameSize.width){
        scale = size.height / frameSize.height;
        xoffset = (frameSize.width - size.width / scale) * 0.5;
    }
    else{
        scale = size.width / frameSize.width;
        yoffset = (frameSize.height - size.height / scale) * 0.5;
    }
    return CGRectMake(xoffset + rect.origin.x / scale, yoffset + rect.origin.y / scale, rect.size.width / scale, rect.size.height / scale);
}

- (TAIMathCorrection *)mathCorrection
{
    if(!_mathCorrection){
        _mathCorrection = [[TAIMathCorrection alloc] init];
    }
    return _mathCorrection;
}
@end
