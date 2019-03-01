//
//  YYRecordButton.h
//  OKVoice
//
//  Created by yanyu on 2018/12/20.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYRecordButton;
typedef void (^RecordTouchDown)         (YYRecordButton *recordButton);
typedef void (^RecordTouchUpOutside)    (YYRecordButton *recordButton);
typedef void (^RecordTouchUpInside)     (YYRecordButton *recordButton);
typedef void (^RecordTouchDragEnter)    (YYRecordButton *recordButton);
typedef void (^RecordTouchDragInside)   (YYRecordButton *recordButton);
typedef void (^RecordTouchDragOutside)  (YYRecordButton *recordButton);
typedef void (^RecordTouchDragExit)     (YYRecordButton *recordButton);

@interface YYRecordButton : UIButton

@property (nonatomic, copy) RecordTouchDown         recordTouchDownAction;
@property (nonatomic, copy) RecordTouchUpOutside    recordTouchUpOutsideAction;
@property (nonatomic, copy) RecordTouchUpInside     recordTouchUpInsideAction;
@property (nonatomic, copy) RecordTouchDragEnter    recordTouchDragEnterAction;
@property (nonatomic, copy) RecordTouchDragInside   recordTouchDragInsideAction;
@property (nonatomic, copy) RecordTouchDragOutside  recordTouchDragOutsideAction;
@property (nonatomic, copy) RecordTouchDragExit     recordTouchDragExitAction;

- (void)setButtonStateWithRecording;
- (void)setButtonStateWithNormal;

@end
