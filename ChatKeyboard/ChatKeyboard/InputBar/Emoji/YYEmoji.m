//
//  YYEmoji.m
//  Emoji
//
//  Created by yons on 2019/2/18.
//  Copyright © 2019年 yons. All rights reserved.
//

#import "YYEmoji.h"
#import "YYEmojiFaceCell.h"

@interface YYEmoji()<UICollectionViewDelegate,UICollectionViewDataSource,YYEmojiFaceCellDelegate>
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) UIView *vFaceBottomBar;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UIView *vBg;
@property (nonatomic, strong) UIImageView *ivFace;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDictionary *emojis;
@property (nonatomic, assign) NSInteger count;
@end

@implementation YYEmoji


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 10) collectionViewLayout:layout];
        [_collView registerClass:[YYEmojiFaceCell class] forCellWithReuseIdentifier:@"YYEmojiFaceCell"];
        _collView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.pagingEnabled = TRUE;
        _collView.showsVerticalScrollIndicator = FALSE;
        _collView.showsHorizontalScrollIndicator = FALSE;
        _collView.backgroundColor = RGB3(247);
        [self addSubview:_collView];
        
        _vFaceBottomBar = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_vFaceBottomBar];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.backgroundColor = RGB3(247);
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [_pageControl addTarget:self action:@selector(clickPageController:event:) forControlEvents:UIControlEventTouchUpInside];
        [_vFaceBottomBar addSubview:_pageControl];
        
        _btnSend = [[UIButton alloc]initWithFrame:CGRectZero];
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnSend.backgroundColor = [UIColor whiteColor];
        _btnSend.titleLabel.font = [UIFont systemFontOfSize:12*RATIO_WIDHT750];
        _btnSend.tag = 100;
        [_btnSend addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_vFaceBottomBar addSubview:_btnSend];
        
        _vBg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _vBg.backgroundColor = RGB3(247);
        [_vFaceBottomBar addSubview:_vBg];
        
        _ivFace = [[UIImageView alloc]initWithFrame:CGRectZero];
        _ivFace.image = [UIImage imageNamed:@"face"];
        [_vBg addSubview:_ivFace];
        
        self.dataSource = [NSMutableArray array];
        NSArray *arr = [self.emojis objectForKey:@"People"];
        [self.dataSource addObjectsFromArray:arr];
        
        //计算多少页
        self.count = self.dataSource.count / YYEmojiMaxCount;
        if (self.dataSource.count % YYEmojiMaxCount) {
            self.count += 1;
        }
        self.pageControl.numberOfPages = self.count;
        [_collView reloadData];
    }
    return self;
}

- (void)clickPageController:(UIPageControl *)pageController event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches] anyObject];
    CGPoint p = [touch locationInView:_pageControl];
    CGFloat centerX = pageController.center.x;
    CGFloat left = centerX-15.0*self.count/2;
    [_pageControl setCurrentPage:(int ) (p.x-left)/15];
    [_collView setContentOffset:CGPointMake(_pageControl.currentPage*DEVICEWIDTH, 0)];
}

- (void)clickAction:(UIButton*)sender{
    if (self.sendClickFace) {
        self.sendClickFace();
    }
}

- (NSDictionary *)emojis {
    if (!_emojis) {
        NSBundle *selfBundle = [NSBundle bundleForClass:[self class]];
        NSString *plistPath = [selfBundle pathForResource:@"EmojisList"
                                                   ofType:@"plist"];
        _emojis = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
    }
    return _emojis;
}

- (NSArray *)getDatas:(NSIndexPath*)indexPath{
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger start = YYEmojiMaxCount*indexPath.row;
    NSInteger count = YYEmojiMaxCount;
    if (indexPath.row == self.count - 1) {
        count = self.dataSource.count % YYEmojiMaxCount;
    }
    arr = [[self.dataSource objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, count)]] mutableCopy];
    return arr;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"YYEmojiFaceCell";
    YYEmojiFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dataSource = [self getDatas:indexPath]; 
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = DEVICEWIDTH;
    CGFloat h = [self calHeight];
    return CGSizeMake(w, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/DEVICEWIDTH;
    self.pageControl.currentPage = index;
}

#pragma CollCellGroupChatFaceDelegate
- (void)clickFaceForIndex:(NSString *)face withType:(YYEmojiSelectType)type{ 
    if (type == YYEmojiSelectTypeFace) {
        self.tfText.text = [NSString stringWithFormat:@"%@%@",self.tfText.text,face];
    }else{
        if (self.tfText.text.length >= 2) {
            NSString *preStr = [self.tfText.text substringFromIndex:self.tfText.text.length-2];
            if ([self stringContainsEmoji:preStr]) {
                self.tfText.text = [self.tfText.text substringToIndex:self.tfText.text.length-2];
            }else{
                self.tfText.text = [self.tfText.text substringToIndex:self.tfText.text.length-1];
            }
        }else if(self.tfText.text.length == 0){
            
        }else{
            self.tfText.text = [self.tfText.text substringToIndex:self.tfText.text.length-1];
        }
    }
}


- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.collView.frame;
    r.size.width = self.frame.size.width;
    r.size.height = self.frame.size.height - 55*RATIO_HEIGHT750;
    r.origin.x = 0;
    r.origin.y = 0;
    self.collView.frame = r;
    
    r = self.vFaceBottomBar.frame;
    r.size.width = self.frame.size.width;
    r.size.height = 55*RATIO_HEIGHT750;
    r.origin.x = 0;
    r.origin.y = self.collView.frame.origin.y + self.collView.frame.size.height;
    self.vFaceBottomBar.frame = r;
    
    r = self.pageControl.frame;
    r.size.width = self.frame.size.width;
    r.size.height = 20*RATIO_HEIGHT750;
    r.origin.x = 0;
    r.origin.y = 0;
    self.pageControl.frame = r;
    
    r = self.btnSend.frame;
    r.size.width = 50*RATIO_WIDHT750;
    r.size.height = 35*RATIO_HEIGHT750;
    r.origin.x = DEVICEWIDTH - r.size.width;
    r.origin.y = self.pageControl.frame.origin.y + self.pageControl.frame.size.height;
    self.btnSend.frame = r;
    
    r = self.vBg.frame;
    r.size.width = 35*RATIO_HEIGHT750;
    r.size.height = r.size.width;
    r.origin.x = 30*RATIO_WIDHT750;
    r.origin.y = self.btnSend.frame.origin.y;
    self.vBg.frame = r;
    
    r = self.ivFace.frame;
    r.size.width = 25*RATIO_HEIGHT750;
    r.size.height = r.size.width;
    r.origin.x = (self.vBg.frame.size.width - r.size.width)/2.0;
    r.origin.y = (self.vBg.frame.size.height - r.size.height)/2.0;
    self.ivFace.frame = r;
    
    
}


- (CGFloat)calHeight{
    return 200*RATIO_HEIGHT750 - 55*RATIO_HEIGHT750;
}
@end
