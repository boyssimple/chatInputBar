//
//  CollCellGroupChatFace.m
//  IM
//
//  Created by luowei on 2018/11/1.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYEmojiFaceCell.h"
#import "YYEmojiFaceCollCell.h"


@interface YYEmojiFaceCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collView;
@end
@implementation YYEmojiFaceCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.collView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 10) collectionViewLayout:layout];
        [_collView registerClass:[YYEmojiFaceCollCell class] forCellWithReuseIdentifier:@"YYEmojiFaceCollCell"];
        _collView.contentInset = UIEdgeInsetsMake(10*RATIO_HEIGHT750, 15*RATIO_WIDHT750, 10*RATIO_HEIGHT750, 15*RATIO_WIDHT750);
        _collView.backgroundColor = [UIColor clearColor];
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.scrollEnabled = NO;
        [self.contentView addSubview:_collView];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.collView.frame;
    r.size.width = self.frame.size.width;
    r.size.height = self.frame.size.height;
    r.origin.x = 0;
    r.origin.y = 0;
    self.collView.frame = r;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return YYEmojiMaxCount+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"YYEmojiFaceCollCell";
    YYEmojiFaceCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        [cell updateDataModel:[self.dataSource objectAtIndex:indexPath.row]];
    }else if(indexPath.row == YYEmojiMaxCount){
        [cell backspace];
    }else{
        [cell emptyFace]; 
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (DEVICEWIDTH - 30*RATIO_WIDHT750) / 8.0;
    CGFloat h = (self.frame.size.height - 20*RATIO_HEIGHT750)/4.0;
    return CGSizeMake(w, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(clickFaceForIndex:withType:)]) {
        if (indexPath.row < self.dataSource.count) {
            [self.delegate clickFaceForIndex:[self.dataSource objectAtIndex:indexPath.row] withType:YYEmojiSelectTypeFace];
        }else if(indexPath.row == YYEmojiMaxCount){
            [self.delegate clickFaceForIndex:@"" withType:YYEmojiSelectTypeDele];
        }
    }
}
@end
