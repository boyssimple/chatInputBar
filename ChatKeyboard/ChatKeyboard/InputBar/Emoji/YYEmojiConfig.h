//
//  YYEmojiConfig.h
//  Emoji
//
//  Created by yons on 2019/2/19.
//  Copyright © 2019年 yons. All rights reserved.
//

#ifndef YYEmojiConfig_h
#define YYEmojiConfig_h

#import <Foundation/Foundation.h>

#define YYEmojiMaxCount 31

typedef NS_OPTIONS(NSUInteger, YYEmojiSelectType) {
    YYEmojiSelectTypeFace = 1 << 0,
    YYEmojiSelectTypeDele = 1 << 1,
};


#import "YYEmoji.h"

#endif /* YYEmojiConfig_h */
