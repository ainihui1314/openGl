//
//  GPUimageLocalNewTwoFiltter.h
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/4.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUimageLocalNewTwoFiltter : GPUImageFilter{
    GLProgram *secondFilterProgram;

    
    GPUImageFramebuffer *secondInputFramebuffer;
    
    GLint secondFilterPositionAttribute,filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
    

    
}
@property(readwrite, nonatomic) GLfloat *pioneNumber;

@end
