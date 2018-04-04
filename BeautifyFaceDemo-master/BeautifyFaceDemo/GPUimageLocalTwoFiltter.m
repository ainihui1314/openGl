//
//  GPUimageLocalTwoFiltter.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "GPUimageLocalTwoFiltter.h"
NSString *const kGPUImageTwoInputTextureVertexShaderString11111= SHADER_STRING
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

@implementation GPUimageLocalTwoFiltter
@synthesize pioneNumber = _pioneNumber;



#pragma mark -
#pragma mark Rendering

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        [secondInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    [self setUniformsForProgramAtIndex:0];
    
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    glUniform1i(filterInputTextureUniform, 2);
    
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, [secondInputFramebuffer texture]);
    glUniform1i(filterInputTextureUniform2, 3);
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glVertexAttribPointer(filterSecondTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, [[self class] textureCoordinatesForRotation:inputRotation2]);
    
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, sizeof(vertices)/2);
 
      glDrawArrays(GL_TRIANGLE_STRIP, 0, sizeof(vertices)/2);

    [firstInputFramebuffer unlock];
    [secondInputFramebuffer unlock];
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }

}






- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    // You can set up infinite update loops, so this helps to short circuit them
    if (hasReceivedFirstFrame && hasReceivedSecondFrame)
    {
        return;
    }
    
    BOOL updatedMovieFrameOppositeStillImage = NO;
    
    if (textureIndex == 0)
    {
        hasReceivedFirstFrame = YES;
        firstFrameTime = frameTime;
        if (secondFrameCheckDisabled)
        {
            hasReceivedSecondFrame = YES;
        }
        
        if (!CMTIME_IS_INDEFINITE(frameTime))
        {
            if CMTIME_IS_INDEFINITE(secondFrameTime)
            {
                updatedMovieFrameOppositeStillImage = YES;
            }
        }
    }
    else
    {
        hasReceivedSecondFrame = YES;
        secondFrameTime = frameTime;
        if (firstFrameCheckDisabled)
        {
            hasReceivedFirstFrame = YES;
        }
        
        if (!CMTIME_IS_INDEFINITE(frameTime))
        {
            if CMTIME_IS_INDEFINITE(firstFrameTime)
            {
                updatedMovieFrameOppositeStillImage = YES;
            }
        }
    }
    
    // || (hasReceivedFirstFrame && secondFrameCheckDisabled) || (hasReceivedSecondFrame && firstFrameCheckDisabled)
    if ((hasReceivedFirstFrame && hasReceivedSecondFrame) || updatedMovieFrameOppositeStillImage)
    {
        if (textureIndex==0) {
            static const GLfloat imageVertices1111[] = {
                -1.0f, -1.0f,
                1.0f, -1.0f,
                -1.0f,  1.0f,
                1.0f,  1.0f,
            };
            CMTime passOnFrameTime = (!CMTIME_IS_INDEFINITE(firstFrameTime)) ? firstFrameTime : secondFrameTime;
            [self renderToTextureWithVertices:imageVertices1111 textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];

            [self informTargetsAboutNewFrameAtTime:passOnFrameTime];

            hasReceivedFirstFrame = NO;
            hasReceivedSecondFrame = NO;
        }else{
              CMTime passOnFrameTime = (!CMTIME_IS_INDEFINITE(firstFrameTime)) ? firstFrameTime : secondFrameTime;

            [self renderToTextureWithVertices:_pioneNumber textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];

            [self informTargetsAboutNewFrameAtTime:passOnFrameTime];

            hasReceivedFirstFrame = NO;
            hasReceivedSecondFrame = NO;

        }

       
    }
    else{
        static const GLfloat imageVertices1111[] = {
            -1.0f, -1.0f,
            1.0f, -1.0f,
            -1.0f,  1.0f,
            1.0f,  1.0f,
        };
        CMTime passOnFrameTime = (!CMTIME_IS_INDEFINITE(firstFrameTime)) ? firstFrameTime : secondFrameTime;
        [self renderToTextureWithVertices:imageVertices1111 textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];
        
        [self informTargetsAboutNewFrameAtTime:passOnFrameTime];

    }
}



#pragma mark -
#pragma mark Accessors

- (void)setPioneNumber:( GLfloat*)newValue;
{
    _pioneNumber = newValue;
    
   
    
}



@end
