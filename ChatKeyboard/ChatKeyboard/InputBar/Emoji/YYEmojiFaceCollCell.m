//
//  CollCellMessageFunc.m
//  IM
//
//  Created by yanyu on 2018/7/26.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYEmojiFaceCollCell.h"

@interface YYEmojiFaceCollCell()
@property(nonatomic,strong)UILabel *lbImg;
@property (nonatomic, strong) UIButton *btnBackspace;
@end
@implementation YYEmojiFaceCollCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lbImg = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbImg.textAlignment = NSTextAlignmentCenter;
        _lbImg.hidden = TRUE;
        _lbImg.font = [UIFont systemFontOfSize:25*RATIO_WIDHT750];
        [self.contentView addSubview:_lbImg]; 
        
        _btnBackspace = [[UIButton alloc]initWithFrame:CGRectZero];
        [_btnBackspace setImage:[UIImage imageNamed:@"ChatFaceDelete"] forState:UIControlStateNormal];
        _btnBackspace.userInteractionEnabled = FALSE;
        _btnBackspace.hidden = TRUE;
        [self.contentView addSubview:_btnBackspace];
    }
    return self;
}

- (void)clickAction:(UIButton*)sender{
    
}

- (void)updateDataModel:(NSString*)text{
    self.lbImg.hidden = FALSE;
    self.lbImg.text = text;
    self.btnBackspace.hidden = TRUE;
}


- (void)emptyFace{
    self.lbImg.hidden = TRUE;
    self.btnBackspace.hidden = TRUE;
}

- (void)backspace{
    self.lbImg.hidden = TRUE;
    self.btnBackspace.hidden = FALSE;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.lbImg.frame;
    r.size.width = self.frame.size.width;//24*RATIO_WIDHT750;
    r.size.height = self.frame.size.height;
    r.origin.x = (self.frame.size.width - r.size.width)/2.0;
    r.origin.y = (self.frame.size.height - r.size.height)/2.0;
    self.lbImg.frame = r;
    
    r = self.btnBackspace.frame;
    r.size.width = self.frame.size.width;
    r.size.height = self.frame.size.height;
    r.origin.x = (self.frame.size.width - r.size.width)/2.0;
    r.origin.y = (self.frame.size.height - r.size.height)/2.0;
    self.btnBackspace.frame = r;
}

+ (CGFloat)calHeight{
    return 80*RATIO_WIDHT750;
}


@end
