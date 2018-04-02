//
//  GPUimagePicrtVC.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUimagePicrtVC.h"

@interface GPUimagePicrtVC ()

@end

@implementation GPUimagePicrtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView  *imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imageview];
    
    
    // Do any additional setup after loading the view.
    UIImage  *imag=[UIImage imageNamed:@"WID-small.jpg"];
    GPUImagePicture *imagePicture=[[GPUImagePicture alloc]initWithImage:imag smoothlyScaleOutput:YES];
    //反色滤镜
    GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init];
    
    //伽马线滤镜
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc]init];
    gammaFilter.gamma = 0.1;
    
    //曝光度滤镜
    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc]init];
    exposureFilter.exposure = 1.0;

    //怀旧
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];

    /*
     *FilterGroup的方式混合滤镜
     */
    //初始化GPUImageFilterGroup
    GPUImageFilterGroup*myFilterGroup = [[GPUImageFilterGroup alloc] init];
    //将滤镜组加在GPUImagePicture上
    [imagePicture addTarget:myFilterGroup];
    //将滤镜加在FilterGroup中
    
    
    [self addGPUImageFilter:gammaFilter myFilterGroup:myFilterGroup];
     [self addGPUImageFilter:sepiaFilter myFilterGroup:myFilterGroup];
     [self addGPUImageFilter:exposureFilter myFilterGroup:myFilterGroup];
     [self addGPUImageFilter:invertFilter myFilterGroup:myFilterGroup];

    
    
    
//    [myFilterGroup addFilter:gammaFilter];
//    [myFilterGroup addFilter:sepiaFilter];
//    [gammaFilter addTarget:sepiaFilter];
//    myFilterGroup.initialFilters = @[gammaFilter];
//    myFilterGroup.terminalFilter = sepiaFilter;
//
    
    //处理图片
    [imagePicture processImage];
    [myFilterGroup useNextFrameForImageCapture];
    //拿到处理后的图片
    UIImage *dealedImage = [myFilterGroup imageFromCurrentFramebuffer];
    imageview.image = dealedImage;
    
   
    
    
    
    
    
    
}


#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter  myFilterGroup:(GPUImageFilterGroup*)myFilterGroup{
    
    [myFilterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = myFilterGroup.filterCount;
    
    if (count == 1)
    {
        //设置初始滤镜
       myFilterGroup.initialFilters = @[newTerminalFilter];
        //设置末尾滤镜
        myFilterGroup.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = myFilterGroup.terminalFilter;
        NSArray *initialFilters                          = myFilterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        //设置初始滤镜
       myFilterGroup.initialFilters = @[initialFilters[0]];
        //设置末尾滤镜
        myFilterGroup.terminalFilter = newTerminalFilter;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
