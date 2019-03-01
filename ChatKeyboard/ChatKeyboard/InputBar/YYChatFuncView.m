//
//  ViewMessageFunc.m
//  IM
//
//  Created by yanyu on 2018/7/26.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYChatFuncView.h"

@interface YYChatFuncViewCollView : UICollectionViewCell

@property(nonatomic,strong)UIButton *btnImg;
@property(nonatomic,strong)UILabel *lbText;
@end

@implementation YYChatFuncViewCollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _btnImg = [[UIButton alloc]initWithFrame:CGRectZero];
        _btnImg.userInteractionEnabled = FALSE;
        [self.contentView addSubview:_btnImg];
        
        _lbText = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbText.textColor = [UIColor darkGrayColor];
        _lbText.font = [UIFont systemFontOfSize:12*RATIO_WIDHT750];
        _lbText.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lbText];
    }
    return self;
}

- (void)updateData:(NSDictionary *)data{
    self.lbText.text = [data jk_stringForKey:@"name"];
    [self.btnImg setImage:[UIImage imageNamed:[data jk_stringForKey:@"icon"]] forState:UIControlStateNormal];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.btnImg.frame;
    r.size.width = 50*RATIO_WIDHT750;
    r.size.height = r.size.width;
    r.origin.x = (self.width - r.size.width)/2.0;
    r.origin.y = 0;
    self.btnImg.frame = r;
    
    CGSize size = [self.lbText sizeThatFits:CGSizeMake(MAXFLOAT, 12*RATIO_WIDHT750)];
    r = self.lbText.frame;
    r.size.width = self.width;
    r.size.height = size.height;
    r.origin.x = 0;
    r.origin.y = self.btnImg.bottom + 5*RATIO_WIDHT750;
    self.lbText.frame = r;
}

+ (CGFloat)calHeight{
    return 80*RATIO_WIDHT750;
}

@end

@interface YYChatFuncView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collView;

@end
@implementation YYChatFuncView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat m = (DEVICEWIDTH - 200*RATIO_WIDHT750)/5.0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = m;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 50*RATIO_HEIGHT750) collectionViewLayout:layout];
        [_collView registerClass:[YYChatFuncViewCollView class] forCellWithReuseIdentifier:@"YYChatFuncViewCollView"];
        _collView.contentInset = UIEdgeInsetsMake(20*RATIO_WIDHT750, m, 10*RATIO_WIDHT750, m);
        _collView.backgroundColor = [UIColor clearColor];
        _collView.delegate = self;
        _collView.dataSource = self;
        [self addSubview:_collView];
    }
    return self;
}


- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"YYChatFuncViewCollView";
    YYChatFuncViewCollView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell updateData:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = [YYChatFuncViewCollView calHeight];
    return CGSizeMake(50*RATIO_WIDHT750, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(selectFuncWithIndex:)]) {
//        [self.delegate selectFuncWithIndex:indexPath.row];
//    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.collView.frame;
    r.size.width = self.width;
    r.size.height = self.height;
    r.origin.x = 0;
    r.origin.y = 0;
    self.collView.frame = r;
}

+ (CGFloat)calHeight{
    return 200*RATIO_HEIGHT750;
}


@end
