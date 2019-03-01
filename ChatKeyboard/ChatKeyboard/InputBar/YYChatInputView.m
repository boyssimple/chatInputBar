//
//  YYChatInputView.m
//  ChatKeyboard
//
//  Created by yons on 2019/2/26.
//  Copyright © 2019年 yons. All rights reserved.
//

#import "YYChatInputView.h"
#import "YYChatFaceView.h"
#import "YYChatFuncView.h"

static CGFloat const PPStickerTextViewHeight = 44.0;

@interface YYChatInputView()
@property (nonatomic, strong) UIButton *btnRecord;
@property (nonatomic, strong) UITextView *tvInput;
@property (nonatomic, strong) UIButton *btnFace;
@property (nonatomic, strong) UIButton *btnFunc;
@property (nonatomic, assign) YYKeyboardType keyboardType;
@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) YYChatFaceView *faceView;
@property (nonatomic, strong) YYChatFuncView *funcView;

@property (nonatomic, assign) BOOL keepsPreModeTextViewWillEdited;
@end

@implementation YYChatInputView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _btnRecord = [[UIButton alloc]initWithFrame:CGRectZero];
        [_btnRecord setImage:[UIImage imageNamed:@"Chat_Record"] forState:UIControlStateNormal];
        [_btnRecord setImage:[UIImage imageNamed:@"Chat_Keyboard"] forState:UIControlStateSelected];
        
        _btnRecord.tag = 100;
        [_btnRecord addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnRecord];
        
        
        _btnFace = [[UIButton alloc]initWithFrame:CGRectZero];
        [_btnFace setImage:[UIImage imageNamed:@"Chat_Face"] forState:UIControlStateNormal];
        [_btnFace setImage:[UIImage imageNamed:@"Chat_Keyboard"] forState:UIControlStateSelected];
        _btnFace.tag = 101;
        [_btnFace addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFace];
        
        
        
        
        _btnFunc = [[UIButton alloc]initWithFrame:CGRectZero];
        [_btnFunc setImage:[UIImage imageNamed:@"Chat_Func"] forState:UIControlStateNormal];
        _btnFunc.tag = 102;
        [_btnFunc addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFunc];
        
        _tvInput = [[UITextView alloc]initWithFrame:CGRectZero];
        _tvInput.backgroundColor = [UIColor whiteColor];
        _tvInput.layer.borderColor = RGB3(231).CGColor;
        _tvInput.layer.borderWidth = 0.5f;
        _tvInput.layer.cornerRadius = 3;
        _tvInput.returnKeyType = UIReturnKeySend;
        _tvInput.font = [UIFont systemFontOfSize:17*RATIO_WIDHT750];
        [self addSubview:_tvInput];
        
        _btnInputRecord = [[YYRecordButton alloc]initWithFrame:CGRectZero];
        [_btnInputRecord setTitle:@"按住说话" forState:UIControlStateNormal];
        [_btnInputRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnInputRecord.tag = 105;
        _btnInputRecord.layer.borderColor = RGB3(231).CGColor;
        _btnInputRecord.layer.borderWidth = 0.5f;
        _btnInputRecord.layer.cornerRadius = 3;
        _btnInputRecord.hidden = TRUE;
//        [_btnInputRecord addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnInputRecord];
        
        _vLine = [[UIView alloc]initWithFrame:CGRectZero];
        _vLine.hidden = TRUE;
        _vLine.backgroundColor = RGB3(230);
        [self addSubview:_vLine];
        
        _faceView = [[YYChatFaceView alloc]initWithFrame:CGRectZero];
        _faceView.hidden = TRUE;
        _faceView.emoji.tfText = self.tvInput;
        [self addSubview:_faceView];
        
        _funcView = [[YYChatFuncView alloc]initWithFrame:CGRectZero];
        _funcView.hidden = TRUE;
        _funcView.dataSource = @[@{@"icon":@"ic_zhaopian",@"name":@"照片"},
                                 @{@"icon":@"ic_zhaopian",@"name":@"拍摄"},
                                                                     @{@"icon":@"ic_shipin",@"name":@"视频通话"},
                                 @{@"icon":@"ic_weizhi",@"name":@"位置"},
                                                                     @{@"icon":@"ic_hongbao",@"name":@"红包"},
                                 @{@"icon":@"ic_shoucang",@"name":@"收藏"}];
        [self addSubview:_funcView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)clickAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 100) {
        
        self.vLine.hidden = TRUE;
        if (sender.selected) {
            self.btnFace.selected = FALSE;
            self.btnFunc.selected = FALSE;
            self.btnInputRecord.hidden = FALSE;
            self.funcView.hidden = TRUE;
            self.faceView.hidden = TRUE;
            
            self.keyboardType = YYKeyboardTypeRecord;
            if (!self.tvInput.isFirstResponder) {
                [self changeStatus];
            }else{
                [self.tvInput resignFirstResponder];
            }
            
        }else{
            self.btnInputRecord.hidden = TRUE;
            self.keyboardType = YYKeyboardTypeSys;
            [self.tvInput becomeFirstResponder];
        }
    }else if (sender.tag == 101) {
        if (sender.selected) {
            self.btnRecord.selected = FALSE;
            self.btnFunc.selected = FALSE;
            
            self.btnInputRecord.hidden = TRUE;
            self.funcView.hidden = TRUE;
            self.vLine.hidden = FALSE;
            
            CGFloat y = self.faceView.y;
            self.faceView.y = self.height;
            self.faceView.hidden = FALSE;
            [UIView animateWithDuration:0.3 animations:^{
                self.faceView.y = y;
            }];
            
            self.keyboardType = YYKeyboardTypeFace;
            if (!self.tvInput.isFirstResponder) {
                [self changeStatus];
            }else{
                [self.tvInput resignFirstResponder];
            }
        }else{
            self.vLine.hidden = TRUE;
            self.faceView.hidden = TRUE;
            self.keyboardType = YYKeyboardTypeSys;
            [self.tvInput becomeFirstResponder];
        }
    }else if (sender.tag == 102) {
        if (sender.selected) {
            self.btnRecord.selected = FALSE;
            self.btnFace.selected = FALSE;
            self.vLine.hidden = FALSE;
            
            self.btnInputRecord.hidden = TRUE;
            self.faceView.hidden = TRUE;
            
            
            CGFloat y = self.funcView.y;
            self.funcView.y = self.height;
            self.funcView.hidden = FALSE;
            [UIView animateWithDuration:0.3 animations:^{
                self.funcView.y = y;
            }];
            
            self.keyboardType = YYKeyboardTypeFunc;
            if (!self.tvInput.isFirstResponder) {
                [self changeStatus];
            }else{
                [self.tvInput resignFirstResponder];
            }
        }else{
            self.vLine.hidden = TRUE;
            self.funcView.hidden = TRUE;
            self.keyboardType = YYKeyboardTypeSys;
            [self.tvInput becomeFirstResponder];
        }
    }
}

- (void)changeStatus{
    
    CGRect inputViewFrame = self.frame;
    CGFloat textViewHeight = [self heightThatFitsSection];
    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - textViewHeight;
    inputViewFrame.size.height = textViewHeight;
    CGRect targetFrame = self.vTarget.frame;
    targetFrame.size.height = inputViewFrame.origin.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = inputViewFrame;
        self.vTarget.frame = targetFrame;
    } completion:^(BOOL finished) {
        [self scrollBottom];
    }];
}

- (void)reset{
    if (self.keyboardType != YYKeyboardTypeRecord) {
        self.btnRecord.selected = FALSE;
        self.btnInputRecord.hidden = TRUE;
        self.btnFace.selected = FALSE;
        self.btnFunc.selected = FALSE;
        
        self.faceView.hidden = TRUE;
        self.funcView.hidden = TRUE;
    }
}

- (void)recordReset{
    if (!self.btnRecord.selected) {
        self.btnRecord.selected = FALSE;
        self.btnInputRecord.hidden = TRUE;
    }
    self.btnFace.selected = FALSE;
    self.btnFunc.selected = FALSE;
    
    self.faceView.hidden = TRUE;
    self.funcView.hidden = TRUE;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.superview) {
        return;
    }
    self.keyboardType = YYKeyboardTypeSys;
    [self reset];
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect inputViewFrame = self.frame;
    CGFloat textViewHeight = [self heightThatFitsSection];
    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(keyboardFrame) - textViewHeight;
    inputViewFrame.size.height = textViewHeight;
    
    
    CGRect targetFrame = self.vTarget.frame;
    targetFrame.size.height = inputViewFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = inputViewFrame;
        self.vTarget.frame = targetFrame;
    } completion:^(BOOL finished) {
        [self scrollBottom];
    }];
}

- (void)scrollBottom{
    dispatch_async(dispatch_get_main_queue(), ^{
        //需要执行的方法
        [self.vTarget scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.vTarget numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:FALSE];
    });
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.superview) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect inputViewFrame = self.frame;
    CGFloat textViewHeight = [self heightThatFitsSection];
    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - textViewHeight;
    inputViewFrame.size.height = textViewHeight;
    
    CGRect targetFrame = self.vTarget.frame;
    targetFrame.size.height = inputViewFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = inputViewFrame;
        self.vTarget.frame = targetFrame;
    } completion:^(BOOL finished) {
        [self scrollBottom];
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.tvInput isFirstResponder]) {
        return YES;
    }else if(self.btnFace.selected || self.btnFunc.selected){
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        if ([self.tvInput isFirstResponder]) {
            [self.tvInput resignFirstResponder];
        }else if(self.btnFace.selected || self.btnFunc.selected){
            self.keyboardType = YYKeyboardTypeNone;
            [self reset];
            [self changeStatus];
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = PPStickerTextViewHeight*RATIO_HEIGHT750;
    
    CGRect r = self.btnRecord.frame;
    r.size.width = 25*RATIO_WIDHT750;
    r.size.height = 25*RATIO_WIDHT750;
    r.origin.x = 10*RATIO_WIDHT750;
    r.origin.y = (height - r.size.height)/2.0;
    self.btnRecord.frame = r;
    
    r = self.btnFunc.frame;
    r.size.width = 25*RATIO_WIDHT750;
    r.size.height = 25*RATIO_WIDHT750;
    r.origin.x = self.width - r.size.width -  10*RATIO_WIDHT750;
    r.origin.y = (height - r.size.height)/2.0;
    self.btnFunc.frame = r;
    
    r = self.btnFace.frame;
    r.size.width = 25*RATIO_WIDHT750;
    r.size.height = 25*RATIO_WIDHT750;
    r.origin.x = self.btnFunc.x - r.size.width -  5*RATIO_WIDHT750;
    r.origin.y = (height - r.size.height)/2.0;
    self.btnFace.frame = r;
    
    r = self.tvInput.frame;
    r.size.width = self.btnFace.x - 20*RATIO_WIDHT750 - self.btnRecord.right;
    r.size.height = height - 10*RATIO_HEIGHT750;
    r.origin.x = self.btnRecord.right + 10*RATIO_WIDHT750;
    r.origin.y = 5*RATIO_HEIGHT750;
    self.tvInput.frame = r;
    
    r = self.btnInputRecord.frame;
    r.size.width = self.btnFace.x - 20*RATIO_WIDHT750 - self.btnRecord.right;
    r.size.height = height - 10*RATIO_HEIGHT750;
    r.origin.x = self.btnRecord.right + 10*RATIO_WIDHT750;
    r.origin.y = 5*RATIO_HEIGHT750;
    self.btnInputRecord.frame = r;
    
    r = self.vLine.frame;
    r.size.width = DEVICEWIDTH;
    r.size.height = 1;
    r.origin.x = 0;
    r.origin.y = self.tvInput.bottom + 5*RATIO_HEIGHT750;
    self.vLine.frame = r;
    
    r = self.faceView.frame;
    r.size.width = DEVICEWIDTH;
    r.size.height = [YYChatFaceView calHeight]-1;
    r.origin.x = 0;
    r.origin.y = self.vLine.bottom;
    self.faceView.frame = r;
    
    r = self.funcView.frame;
    r.size.width = DEVICEWIDTH;
    r.size.height = [YYChatFaceView calHeight]-1;
    r.origin.x = 0;
    r.origin.y = self.vLine.bottom;
    self.funcView.frame = r;
}


- (CGFloat)heightThatFitsSection
{
    if (self.keyboardType == YYKeyboardTypeRecord || self.keyboardType == YYKeyboardTypeNone || self.keyboardType == YYKeyboardTypeSys) {
        return PPStickerTextViewHeight*RATIO_HEIGHT750;
    } else {
        return PPStickerTextViewHeight*RATIO_HEIGHT750 + [YYChatFuncView calHeight];
    }
}

@end
