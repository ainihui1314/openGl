//
//  GPUImageStillCameraVC.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUImageStillCameraVC.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "Masonry.h"

#import "FilterView.h"
#import "ColorMatrix.h"

#import "GPUimageLocalRGBFilter.h"
///滤镜View的显示状态
typedef NS_ENUM(NSInteger, FilterViewState) {
    
    FilterViewHidden,/**<隐藏*/
    
    FilterViewUsing /**<显示*/
};

///闪光灯状态
typedef NS_ENUM(NSInteger, CameraManagerFlashMode) {
    
    CameraManagerFlashModeAuto, /**<自动*/
    
    CameraManagerFlashModeOff, /**<关闭*/
    
    CameraManagerFlashModeOn /**<打开*/
};




@interface GPUImageStillCameraVC ()<UIGestureRecognizerDelegate,CAAnimationDelegate>
{
    CALayer *_focusLayer; //聚焦层
}
@property(nonatomic,strong)GPUImageStillCamera  *stillCamera;
//@property(nonatomic,strong)GPUImageBeautifyFilter   *beautifyFilter;
@property (nonatomic,strong) GPUImageView           *filterImageView;
@property (nonatomic,strong) GPUImageBeautifyFilter   *filter;

@property (nonatomic,strong) UIImageView         *filterView;

@property (nonatomic , assign) CameraManagerFlashMode flashMode;
@property (nonatomic , assign) FilterViewState filterViewState;

@property (strong, nonatomic)  UIView *preview;
@property (nonatomic , assign) CGFloat beginGestureScale;//开始的缩放比例
@property (nonatomic , assign) CGFloat effectiveScale;//最后的缩放比例


//GPUImageMonochromeFilter
@end

@implementation GPUImageStillCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stillCamera=[[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    _stillCamera.outputImageOrientation=UIInterfaceOrientationPortrait;
    
    _filterImageView=[[GPUImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_filterImageView];
    
    _filter=[[GPUImageBeautifyFilter alloc]init];
    
    [self.stillCamera addTarget:_filter];

    [_filter addTarget:_filterImageView];

    
   GPUImageLightenBlendFilter *filter11 = [[GPUImageLightenBlendFilter alloc] init];
    
    
    GPUImageMonochromeFilter *romeFilter=[[GPUImageMonochromeFilter alloc]init];
    [romeFilter setBackgroundColorRed:0.5 green:0.3 blue:0.9 alpha:1.0];
    
    UIImage *ime=[UIImage imageNamed:@"WID-small.jpg"];
    
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:ime smoothlyScaleOutput:YES];
    [sourcePicture processImage];

//    [sourcePicture addTarget:romeFilter];
     [sourcePicture addTarget:filter11];

    [filter11 addTarget:_filterImageView];
    
    
    [self.stillCamera startCameraCapture];
    
    
    UIButton  *btn=[[UIButton alloc]init];
    btn.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btn];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
    }];
    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterView=[[UIImageView alloc]init];
    self.filterView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.filterView];
    

    
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.width.equalTo(@144);
        make.height.equalTo(@256);
        make.centerX.equalTo(self.view);
    }];
    
//    [self addFileView];
    UIImage  *imd=[filter11 imageFromCurrentFramebuffer];
    _filterView.image=imd;
    
    
    
 //聚焦图片
//    [self  setfocusImage];
//    _beginGestureScale=1.0;
//    _effectiveScale=1.0;
}

-(void)btn:(UIButton*)sender{
    
//    //设置相机懂前后镜
//     [_stillCamera rotateCamera];
    
    
    //闪光灯设置
//    [self setFlashMode:CameraManagerFlashModeOn];
    
    
//    // 截取某一时刻的滤镜图片
//    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
//
//
//        _filterView.image=processedImage;
//
//
//        // 耗内存
//        NSData *dataForJPEGFile = UIImageJPEGRepresentation(processedImage, 0.8);
//        NSLog(@"++++++%lu",(unsigned long)dataForJPEGFile.length);
//
////        // 保存到Document
////        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////        NSString *documentsDirectory = [paths objectAtIndex:0];
////
////        NSError *error2 = nil;
////        if (![dataForJPEGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"FilteredPhoto.jpg"] options:NSAtomicWrite error:&error2])
////        {
////            return;
////        }
//    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置闪光灯模式

- (void)setFlashMode:(CameraManagerFlashMode)flashMode {
    _flashMode = flashMode;
    
    switch (flashMode) {
        case CameraManagerFlashModeAuto: {
            [_stillCamera.inputCamera lockForConfiguration:nil];
            if ([_stillCamera.inputCamera isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeAuto];
            }
            [_stillCamera.inputCamera unlockForConfiguration];
        }
            break;
        case CameraManagerFlashModeOff: {
            [_stillCamera.inputCamera lockForConfiguration:nil];
            [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
            [_stillCamera.inputCamera unlockForConfiguration];
        }
            
            break;
        case CameraManagerFlashModeOn: {
            [_stillCamera.inputCamera lockForConfiguration:nil];
            [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
            [_stillCamera.inputCamera unlockForConfiguration];
        }
            break;
            
        default:
            break;
    }
}

//设置聚焦图片
- (void)setfocusImage{
    if (!_preview) {
        _preview=[[UIView alloc]initWithFrame:self.view.bounds];
        _preview.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_preview];
    }
    
    if (!_focusLayer) {
        //增加tap手势，用于聚焦及曝光
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
        [self.preview addGestureRecognizer:tap];
        //增加pinch手势，用于调整焦距
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(focusDisdance:)];
        [self.preview addGestureRecognizer:pinch];
        pinch.delegate = self;
    }
    
    [_preview.layer setBorderWidth:1];
    [_preview.layer setBorderColor:[UIColor redColor].CGColor];
    _focusLayer = _preview.layer;
    
}


//调整焦距方法
-(void)focusDisdance:(UIPinchGestureRecognizer*)pinch {
    self.effectiveScale = self.beginGestureScale * pinch.scale;
    if (self.effectiveScale < 1.0f) {
        self.effectiveScale = 1.0f;
    }
    CGFloat maxScaleAndCropFactor = 3.0f;//设置最大放大倍数为3倍
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    NSError *error;
    if([self.stillCamera.inputCamera lockForConfiguration:&error]){
        [self.stillCamera.inputCamera setVideoZoomFactor:self.effectiveScale];
        [self.stillCamera.inputCamera unlockForConfiguration];
    }
    else {
        NSLog(@"ERROR = %@", error);
    }
    
    [CATransaction commit];
}

//手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

//对焦

//对焦方法
- (void)focus:(UITapGestureRecognizer *)tap {
    self.preview.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    // CGContextRef *touchContext = UIGraphicsGetCurrentContext();
    [self layerAnimationWithPoint:touchPoint];
    /**
     *下面是照相机焦点坐标轴和屏幕坐标轴的映射问题，这个坑困惑了我好久，花了各种方案来解决这个问题，以下是最简单的解决方案也是最准确的坐标转换方式
     */
    if(_stillCamera.cameraPosition == AVCaptureDevicePositionBack){
        touchPoint = CGPointMake( touchPoint.y /tap.view.bounds.size.height ,1-touchPoint.x/tap.view.bounds.size.width);
    }
    else
        touchPoint = CGPointMake(touchPoint.y /tap.view.bounds.size.height ,touchPoint.x/tap.view.bounds.size.width);
    /*以下是相机的聚焦和曝光设置，前置不支持聚焦但是可以曝光处理，后置相机两者都支持，下面的方法是通过点击一个点同时设置聚焦和曝光，当然根据需要也可以分开进行处理
     */
    if([_stillCamera.inputCamera isExposurePointOfInterestSupported] && [self.stillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
    {
        NSError *error;
        if ([self.stillCamera.inputCamera lockForConfiguration:&error]) {
            [self.stillCamera.inputCamera setExposurePointOfInterest:touchPoint];
            [self.stillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            if ([self.stillCamera.inputCamera isFocusPointOfInterestSupported] && [self.stillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.stillCamera.inputCamera setFocusPointOfInterest:touchPoint];
                [self.stillCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            [self.stillCamera.inputCamera unlockForConfiguration];
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

//对焦动画
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        ///聚焦点聚焦动画设置
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

//动画的delegate方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //    1秒钟延时
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.5f];
}

//focusLayer回到初始化状态
- (void)focusLayerNormal {
    self.preview.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}


-(void)addFileView{
    FilterView *view=[[FilterView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-90-70, self.view.frame.size.width, 90)];
    [self.view addSubview:view];
    view.rightBtnTargetBlock=^(NSString *string){
        [_stillCamera removeAllTargets];
        GPUImageMonochromeFilter *romeFilter=[[GPUImageMonochromeFilter alloc]init];
        [romeFilter setBackgroundColorRed:0.5 green:0.3 blue:0.9 alpha:1.0];

        [_stillCamera addTarget:romeFilter];
        [romeFilter addTarget:_filterImageView];
    
    };
}


@end
