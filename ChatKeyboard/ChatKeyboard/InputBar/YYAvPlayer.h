//
//  YYAvPlayer.h
//  IMPlayer
//
//  Created by yanyu on 2018/12/25.
//  Copyright © 2018年 yanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIWindow *windowPlayer = nil;

@interface YYAvPlayer : UIWindow

- (id)initWith:(NSString*)url;
- (void)show;
- (void)dismiss;
@end

