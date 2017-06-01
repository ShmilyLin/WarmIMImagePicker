//
//  WarmIMCameraViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/27.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMCameraViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface WarmIMCameraViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
//@property (nonatomic, strong) AVCaptureDevice *currentCaptureDevice; // 当前捕获设备
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (nonatomic, strong) UIButton *closeButton; // 关闭页面按钮
@property (nonatomic, strong) UIButton *switchDevice; // 切换摄像头
@property (nonatomic, strong) UILabel *descriptionLabel; // 描述
@property (nonatomic, strong) UIButton *takePhotoButton; // 拍照按钮
@property (nonatomic, strong) UIButton *flashButton; // 闪光灯按钮
@property (nonatomic, strong) UIImageView *focusCursor; // 聚焦光标
@property (nonatomic, strong) UIButton *livePhotoButton; // 是否拍摄LivePhoto

@end

@implementation WarmIMCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setupCamera];
    [self setupSubViews];
    
    [self addNotificationToCaptureDevice];
//    [self addGenstureRecognizer];
//    [self setFlashModeButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dealloc{
    [self removeNotification];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - UI

- (void)setupSubViews {
    // 创建视频预览层，用于实时展示摄像头状态
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
        self.view.layer.masksToBounds = YES;
        _captureVideoPreviewLayer.frame = self.view.layer.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 填充模式
        // 将视频预览层添加到界面中
        [self.view.layer insertSublayer:_captureVideoPreviewLayer atIndex:0];
    }
    
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 0, 0);
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_camera_exit"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.frame = CGRectMake(0, 0, 0, 0);
        _flashButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_camera_flash_off"] forState:UIControlStateNormal];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_camera_flash_on"] forState:UIControlStateSelected];
        [_flashButton addTarget:self action:@selector(flashButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashButton];
    }
    
    if (!_switchDevice) {
        _switchDevice = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchDevice.frame = CGRectMake(0, 0, 0, 0);
        _switchDevice.translatesAutoresizingMaskIntoConstraints = NO;
        [_switchDevice setBackgroundImage:[UIImage imageNamed:@"WarmIM_camera_switch"] forState:UIControlStateNormal];
        [_switchDevice addTarget:self action:@selector(switchDeviceClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchDevice];
    }
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_closeButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_switchDevice attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_switchDevice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_closeButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_switchDevice attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_switchDevice attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_switchDevice attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_switchDevice attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_switchDevice attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_flashButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
}


#pragma mark - Camera

- (void)setupCamera {
    // 初始化会话
    _captureSession = [[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) { //设置分辨率
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    // 获得输入设备
    AVCaptureDevice *currentCaptureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!currentCaptureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error = nil;
    // 根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:currentCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
}

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

//#pragma mark 拍照
//- (IBAction)takeButtonClick:(UIButton *)sender {
//    //根据设备输出获得连接
//    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    //根据连接取得设备输出的数据
//    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer) {
//            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image=[UIImage imageWithData:imageData];
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//            //            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//            //            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
//        }
//        
//    }];
//}
#pragma mark 切换前后摄像头
//- (IBAction)toggleButtonClick:(UIButton *)sender {
//    AVCaptureDevice *currentDevice = [_captureDeviceInput device];
//    AVCaptureDevicePosition currentPosition = [currentDevice position];
//    [self removeNotificationFromCaptureDevice:currentDevice];
//    AVCaptureDevice *toChangeDevice;
//    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
//    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition==AVCaptureDevicePositionFront) {
//        toChangePosition = AVCaptureDevicePositionBack;
//    }
//    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
//    
//    //获得要调整的设备输入对象
//    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
//    [self addNotificationToCaptureDevice];
//    
//    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
//    [_captureSession beginConfiguration];
//    //移除原有输入对象
//    [_captureSession removeInput:_captureDeviceInput];
//    //添加新的输入对象
//    if ([_captureSession canAddInput:toChangeDeviceInput]) {
//        [_captureSession addInput:toChangeDeviceInput];
//        _captureDeviceInput = toChangeDeviceInput;
//    }
//    //提交会话配置
//    [self.captureSession commitConfiguration];
//    
//    [self setFlashModeButtonStatus];
//}
//
//#pragma mark 自动闪光灯开启
//- (IBAction)flashAutoClick:(UIButton *)sender {
//    [self setFlashMode:AVCaptureFlashModeAuto];
//    [self setFlashModeButtonStatus];
//}
//#pragma mark 打开闪光灯
//- (IBAction)flashOnClick:(UIButton *)sender {
//    [self setFlashMode:AVCaptureFlashModeOn];
//    [self setFlashModeButtonStatus];
//}
//#pragma mark 关闭闪光灯
//- (IBAction)flashOffClick:(UIButton *)sender {
//    [self setFlashMode:AVCaptureFlashModeOff];
//    [self setFlashModeButtonStatus];
//}

#pragma mark - Notifications
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice {
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[_captureDeviceInput device]];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - Actions

// 关闭按钮点击事件
- (void)closeButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 切换摄像头按钮点击事件
- (void)switchDeviceClicked:(UIButton *)sender {
    AVCaptureDevice *currentDevice = [_captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    
    // 获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    [self addNotificationToCaptureDevice];
    
    // 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [_captureSession beginConfiguration];
    // 移除原有输入对象
    [_captureSession removeInput:_captureDeviceInput];
    // 添加新的输入对象
    if ([_captureSession canAddInput:toChangeDeviceInput]) {
        [_captureSession addInput:toChangeDeviceInput];
        _captureDeviceInput = toChangeDeviceInput;
    }
    // 提交会话配置
    [_captureSession commitConfiguration];
}

// 打开闪光灯按钮点击事件
- (void)flashButtonClicked:(UIButton *)sedner {
    sedner.selected = !sedner.isSelected;
}

#pragma mark - Functions

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice = [_captureDeviceInput device];
    NSError *error;
    // 注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
//-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isFlashModeSupported:flashMode]) {
//            [captureDevice setFlashMode:flashMode];
//        }
//    }];
//}
///**
// *  设置聚焦模式
// *
// *  @param focusMode 聚焦模式
// */
//-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isFocusModeSupported:focusMode]) {
//            [captureDevice setFocusMode:focusMode];
//        }
//    }];
//}
///**
// *  设置曝光模式
// *
// *  @param exposureMode 曝光模式
// */
//-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isExposureModeSupported:exposureMode]) {
//            [captureDevice setExposureMode:exposureMode];
//        }
//    }];
//}
///**
// *  设置聚焦点
// *
// *  @param point 聚焦点
// */
//-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isFocusModeSupported:focusMode]) {
//            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
//        }
//        if ([captureDevice isFocusPointOfInterestSupported]) {
//            [captureDevice setFocusPointOfInterest:point];
//        }
//        if ([captureDevice isExposureModeSupported:exposureMode]) {
//            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
//        }
//        if ([captureDevice isExposurePointOfInterestSupported]) {
//            [captureDevice setExposurePointOfInterest:point];
//        }
//    }];
//}
//
///**
// *  添加点按手势，点按时聚焦
// */
//-(void)addGenstureRecognizer{
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
//    [self.view addGestureRecognizer:tapGesture];
//}
//-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
//    CGPoint point= [tapGesture locationInView:self.view];
//    //将UI坐标转化为摄像头坐标
//    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
//    [self setFocusCursorWithPoint:point];
//    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
//}
//
///**
// *  设置闪光灯按钮状态
// */
//-(void)setFlashModeButtonStatus{
//    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
//    AVCaptureFlashMode flashMode=captureDevice.flashMode;
//    if([captureDevice isFlashAvailable]){
//        self.flashAutoButton.hidden=NO;
//        self.flashOnButton.hidden=NO;
//        self.flashOffButton.hidden=NO;
//        self.flashAutoButton.enabled=YES;
//        self.flashOnButton.enabled=YES;
//        self.flashOffButton.enabled=YES;
//        switch (flashMode) {
//            case AVCaptureFlashModeAuto:
//                self.flashAutoButton.enabled=NO;
//                break;
//            case AVCaptureFlashModeOn:
//                self.flashOnButton.enabled=NO;
//                break;
//            case AVCaptureFlashModeOff:
//                self.flashOffButton.enabled=NO;
//                break;
//            default:
//                break;
//        }
//    }else{
//        self.flashAutoButton.hidden=YES;
//        self.flashOnButton.hidden=YES;
//        self.flashOffButton.hidden=YES;
//    }
//}
//
///**
// *  设置聚焦光标位置
// *
// *  @param point 光标位置
// */
//-(void)setFocusCursorWithPoint:(CGPoint)point{
//    self.focusCursor.center=point;
//    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
//    self.focusCursor.alpha=1.0;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.focusCursor.transform=CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        self.focusCursor.alpha=0;
//        
//    }];
//}
@end
