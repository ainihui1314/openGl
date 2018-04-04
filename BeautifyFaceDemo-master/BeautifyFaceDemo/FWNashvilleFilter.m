//
//  FWNashvilleFilter.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/3.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "FWNashvilleFilter.h"



@implementation FWNashvilleFilter

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    
    imageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageTwoInputFilter *filters = [[GPUImageTwoInputFilter alloc] init];
    
//    GLfloat noRotationTextureCoordinates123[] = {
//        -0.5f, 0.5f,
//        -0.5f, -0.5f,
//        0.5f, 0.5f,
//        0.5f, -0.5f,
//    };
//
//    filters.pioneNumber=noRotationTextureCoordinates123;
    
    [self addFilter:filters];
    
    
//       //反色滤镜
//        GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init];
//       //怀旧
//        GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
//        [invertFilter addTarget:filters];
//        [sepiaFilter addTarget:filters];
    
    
    [imageSource addTarget:filters atTextureLocation:1];
    [imageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:filters, nil];
    self.terminalFilter = filters;
    
    return self;
}

@end

