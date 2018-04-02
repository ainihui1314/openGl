//
//  FilterViewCell.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "FilterViewCell.h"

@implementation FilterViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.imagview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 60, 60)];
        [self.contentView addSubview: self.imagview];
        self.lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 60,90, 20)];
        self.lab.textColor=[UIColor grayColor];
        self.lab.font=[UIFont systemFontOfSize:14];
        self.lab.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.lab];
        self.lab.text=@"复古";
        
    }
    return self;
}
@end
