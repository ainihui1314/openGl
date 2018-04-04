//
//  FWNashvilleFilter.h
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/3.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"
#import "GPUimageLocalTwoFiltter.h"
#import "GPUImage.h"
@interface FWNashvilleFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource ;
}

@end
