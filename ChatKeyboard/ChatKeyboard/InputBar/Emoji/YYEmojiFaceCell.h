//
//  YYEmojiFaceCell.h
//  OKVoice
//
//  Created by yons on 2019/2/19.
//  Copyright © 2019年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YYEmojiFaceCellDelegate <NSObject>

- (void)clickFaceForIndex:(NSString*)face withType:(YYEmojiSelectType)type; 

@end

@interface YYEmojiFaceCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<YYEmojiFaceCellDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
