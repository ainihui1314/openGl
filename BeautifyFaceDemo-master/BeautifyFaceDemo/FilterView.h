//
//  FilterView.h
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView     *collectionView;
@property (nonatomic,strong)void(^rightBtnTargetBlock)(NSString *string);
@end
