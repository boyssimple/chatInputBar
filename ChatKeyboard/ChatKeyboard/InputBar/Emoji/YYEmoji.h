//
//  YYEmoji.h
//  Emoji
//
//  Created by yons on 2019/2/18.
//  Copyright © 2019年 yons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYEmoji : UIView
@property (nonatomic, strong) void (^sendClickFace)(void);
@property (nonatomic, strong) UITextView *tfText;
@end

NS_ASSUME_NONNULL_END
