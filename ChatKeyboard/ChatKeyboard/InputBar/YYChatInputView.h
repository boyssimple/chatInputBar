//
//  YYChatInputView.h
//  ChatKeyboard
//
//  Created by yons on 2019/2/26.
//  Copyright © 2019年 yons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRecordButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YYKeyboardType) {
    YYKeyboardTypeNone,
    YYKeyboardTypeSys,
    YYKeyboardTypeRecord,
    YYKeyboardTypeFace,
    YYKeyboardTypeFunc,
};

@interface YYChatInputView : UIView
@property (nonatomic, strong) YYRecordButton *btnInputRecord;
@property (nonatomic, strong) UITableView *vTarget;
- (CGFloat)heightThatFitsSection;
@end


NS_ASSUME_NONNULL_END
