//
//  YYChatFaceView.m
//  ChatKeyboard
//
//  Created by yons on 2019/2/26.
//  Copyright © 2019年 yons. All rights reserved.
//

#import "YYChatFaceView.h"


@implementation YYChatFaceView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _emoji = [[YYEmoji alloc]initWithFrame:CGRectZero];
        [self addSubview:_emoji];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGRect r = self.emoji.frame;
    r.size.width = DEVICEWIDTH;
    r.size.height = self.height;
    r.origin.x = 0;
    r.origin.y = 0;
    self.emoji.frame = r;
}

+ (CGFloat)calHeight{
    return 200*RATIO_HEIGHT750;
}


@end
