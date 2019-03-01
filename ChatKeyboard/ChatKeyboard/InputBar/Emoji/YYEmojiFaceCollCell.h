//
//  YYEmojiFaceCollCell.h
//  OKVoice
//
//  Created by yons on 2019/2/19.
//  Copyright © 2019年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYEmojiFaceCollCell : UICollectionViewCell
- (void)updateDataModel:(NSString*)text;
- (void)emptyFace;
- (void)backspace;

@end

NS_ASSUME_NONNULL_END
