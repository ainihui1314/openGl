//
//  GPUimagePicrtVC.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUimagePicrtVC.h"
#import "GPUimageLocalFilter.h"
#import "GPUimageLocalTwoFiltter.h"
#import "GPUImageTwoInputFilter.h"
#import "FWNashvilleFilter.h"
#import "GPUimageLocalNewTwoFiltter.h"

// Hardcode the vertex shader for standard filters, but this can be overridden
NSString *const GPUimageLocaltexShaderString123123 = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
{
    //base就是add的target,overlay就是第二个,均用vec4来表示像素
    mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
    mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
    
    //为了防止第一个加入的图片(底图),有一些空白的像素点(指的是黑色,并不是白色)
    lowp float alphaDivisor = base.a + step(base.a, 0.0); // Protect against a divide-by-zero blacking out things in the output
    
    //这个是柔光混合的算法：
    //(2*A-1)*(B-B*B)+B
    //(2*A-1)*(sqrt(B)-B)+B
    //overlay > vec4(0.5)  --> (2*A-1)*(B-B*B)+B
    //overlay <= vec4(0.5) --> (2*A-1)*(sqrt(B)-B)+B
    
    mediump vec4 mixColor;
    
    if (max(overlay, vec4(0.5)) == vec4(0.5)){
        mixColor = (vec4(2) * overlay - vec4(1)) * (sqrt(base) - base) + base;
    }else {
        mixColor = (vec4(2) * overlay - vec4(1)) * (base - base * base) + base;
    }
    gl_FragColor = vec4((mixColor.rgb + vec3(0.3)), mixColor.w);
}
 );

NSString *const kGPUImageGreenHistogramSamplingVertexShaderString1213 = SHADER_STRING
(
 attribute vec4 position;
 
 varying vec3 colorFactor;
 
 void main()
 {
     colorFactor = vec3(0.0, 1.0, 0.0);
     gl_Position = vec4(-1.0 + (position.y * 0.0078125), 0.0, 0.0, 1.0);
     gl_PointSize = 1.0;
 }
 );

@interface GPUimagePicrtVC ()

@end

@implementation GPUimagePicrtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView  *imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imageview];
    
    
    UIImage  *imag=[UIImage imageNamed:@"3.jpg"];
    GPUImagePicture *imagePicture=[[GPUImagePicture alloc]initWithImage:imag];
    
    UIImage  *imag1=[UIImage imageNamed:@"1.jpg"];
    GPUImagePicture *imagePicture1=[[GPUImagePicture alloc]initWithImage:imag1];
    
    
//*********************GPUImageTwoInputFilter

//    GPUimageLocalFilter *filter=[[GPUimageLocalFilter alloc]init];
//    GLfloat noRotationTexture[] = {
//        -1.0f, 0.8f,
//        -0.5f, 0.8f,
//        -1.0f, 0.5f,
//        -0.5f, 0.5f,
//    };
//    filter.pioneNumber=noRotationTexture;
//    [imagePicture addTarget:filter];
//
//    GPUimageLocalFilter *filter1=[[GPUimageLocalFilter alloc]init];
////    GLfloat noRotationTe[] = {
////        0.0f, 0.0f,
////        0.5f, -0.5f,
////        0.5f, 0.5f,
////        1.0f, -0.0f,
////    };
////    filter1.pioneNumber=noRotationTe;
//    [imagePicture1 addTarget:filter1];
//
//
//    GPUImageTwoInputFilter *twoFile=[[GPUImageTwoInputFilter alloc]initWithFragmentShaderFromString:GPUimageLocaltexShaderString123123];
//
////  GPUImageColorBurnBlendFilter*twoinputFilter = [[GPUImageColorBurnBlendFilter alloc]initWithFragmentShaderFromString:GPUimageLocaltexShaderString123123];
////
//
////    [filter addTarget:twoinputFilter];
//    [filter addTarget:twoFile atTextureLocation:1];
//    [imagePicture processImage];
//
//    [imagePicture1 addTarget:twoFile atTextureLocation:0];
//    [imagePicture1 processImage];
//
//    [twoFile useNextFrameForImageCapture];
//    imageview.image=[twoFile imageFromCurrentFramebuffer];

    
    
///******************GPUimageLocalTwoFiltter自定义双虑镜
    
    
//     GPUimageLocalTwoFiltter *twoFile=[[GPUimageLocalTwoFiltter alloc]initWithFragmentShaderFromString:GPUimageLocaltexShaderString123123];
//    GLfloat noRotationTexture[] = {
//        -0.5f, 0.5f,
//        -0.5f, -0.5f,
//        0.5f, 0.5f,
//        0.5f, -0.5f,
//    };
////    twoFile.pioneNumber=noRotationTexture;
//        GPUImageTwoInputFilter *twoFile=[[GPUImageTwoInputFilter alloc]initWithFragmentShaderFromString:GPUimageLocaltexShaderString123123];
//
//
//        [imagePicture1 addTarget:twoFile atTextureLocation:0];
//        [imagePicture1 processImage];
//
//        [imagePicture addTarget:twoFile atTextureLocation:1];
//        [imagePicture processImage];
//
//
//
//        [twoFile useNextFrameForImageCapture];
//        imageview.image=[twoFile imageFromCurrentFramebuffer];

   
 ///////////GPUimageLocalNewTwoFiltter
    GPUimageLocalNewTwoFiltter *twoFile=[[GPUimageLocalNewTwoFiltter alloc]initWithFragmentShaderFromString:GPUimageLocaltexShaderString123123];

    [imagePicture addTarget:twoFile atTextureLocation:1];
    [imagePicture processImage];

    [imagePicture1 addTarget:twoFile atTextureLocation:0];
    [imagePicture1 processImage];

    [twoFile useNextFrameForImageCapture];
    imageview.image=[twoFile imageFromCurrentFramebuffer];


    
    
    
    
//******************************GPUImageFilterGroup
    //    //反色滤镜
    //    GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init];
    //
    //    //伽马线滤镜
    //    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc]init];
    //    gammaFilter.gamma = 0.1;
    //
    //    //曝光度滤镜
    //    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc]init];
    //    exposureFilter.exposure = 1.0;
    //
    //    //怀旧
    //    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    /*
     *FilterGroup的方式混合滤镜
     */
    //初始化GPUImageFilterGroup
//    GPUImageFilterGroup*myFilterGroup = [[GPUImageFilterGroup alloc] init];
//    //将滤镜组加在GPUImagePicture上
//    [imagePicture addTarget:myFilterGroup];
    //将滤镜加在FilterGroup中
    
    
    //     [self addGPUImageFilter:localFilter myFilterGroup:myFilterGroup];
    //    [self addGPUImageFilter:gammaFilter myFilterGroup:myFilterGroup];
    //     [self addGPUImageFilter:sepiaFilter myFilterGroup:myFilterGroup];
    //     [self addGPUImageFilter:exposureFilter myFilterGroup:myFilterGroup];
    //     [self addGPUImageFilter:invertFilter myFilterGroup:myFilterGroup];
    
    

    //    [myFilterGroup addFilter:gammaFilter];
    //    [myFilterGroup addFilter:sepiaFilter];
    //    [gammaFilter addTarget:sepiaFilter];
    //    myFilterGroup.initialFilters = @[gammaFilter];
    //    myFilterGroup.terminalFilter = sepiaFilter;
    //
    
//
//    //添加上滤镜
//    [imagePicture1 addTarget:group];
//    [imagePicture1 processImage];
//    [group useNextFrameForImageCapture];
//    imageview.image = [group imageFromCurrentFramebuffer];
//
    
}

- (UIImage *)applyNashvilleFilter:(UIImage *)image
{
    FWNashvilleFilter *filter = [[FWNashvilleFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
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







- (GLuint) loadTextureFromCGImage : (CGImageRef) imageRef {

    //copy rgba data from imageRef
    int width = (int)CGImageGetWidth(imageRef);
    int height = (int)CGImageGetHeight(imageRef);
    GLubyte * imageData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));

    CGContextRef spriteContext = CGBitmapContextCreate(imageData, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);

    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(spriteContext);

    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    //    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    free(imageData);

    return texture;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
