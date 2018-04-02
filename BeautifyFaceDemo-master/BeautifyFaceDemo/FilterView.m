//
//  FilterView.m
//  BeautifyFaceDemo
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018年 guikz. All rights reserved.
//

#import "FilterView.h"
#import "FilterViewCell.h"
@implementation FilterView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:CGSizeMake(80, 80)];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置其边界
        flowLayout.minimumLineSpacing =10;//设置其边界
         flowLayout.minimumInteritemSpacing =10;//设置其边界
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[FilterViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
        
    }
    return self;
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return 10;
}
//注册 Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor=[UIColor redColor];
//    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rightBtnTargetBlock) {
        self.rightBtnTargetBlock(@"");
    }
    
}
@end
