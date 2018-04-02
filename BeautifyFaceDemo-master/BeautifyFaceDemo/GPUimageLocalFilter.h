//
//  GPUimageLocalFilter.h
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018年 guikz. All rights reserved.
// 测试局部改变

#import "GPUImageFilter.h"

@interface GPUimageLocalFilter : GPUImageFilter

/** A 4x4 matrix used to transform each color in an image
 */
@property(readwrite, nonatomic) CGFloat pionrMatrix;

@end
