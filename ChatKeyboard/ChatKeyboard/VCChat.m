//
//  VCChat.m
//  ChatKeyboard
//
//  Created by yons on 2019/2/26.
//  Copyright © 2019年 yons. All rights reserved.
//

#import "VCChat.h"
#import "YYChatInputView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LVRecordTool.h"

@interface VCChat ()<UITableViewDelegate,UITableViewDataSource,LVRecordToolDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) YYChatInputView *inputView;

//录音时  提示的相关view
@property (nonatomic,weak) UIImageView * bgView;
@property (nonatomic,weak) UIImageView * stateImageView;
@property (nonatomic,weak) UILabel * textLabel;
@property (nonatomic,assign) CGFloat currentRecordTime;
//录音工具类
@property(nonatomic,strong)LVRecordTool * recordTool;
@end

@implementation VCChat

- (void)dealloc{
    [self.recordTool stopPlaying];
    self.recordTool = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB3(230);
    [self.view addSubview:self.table];
    [self.view addSubview:self.inputView];
    self.inputView.vTarget = self.table;
    
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    self.recordTool.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat height = [self.inputView heightThatFitsSection];
    CGFloat minY = CGRectGetHeight(self.view.bounds) - height;
    self.inputView.frame = CGRectMake(0, minY, CGRectGetWidth(self.view.bounds), height);
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}

#pragma mark ---- 销毁录音提示的视图
-(void)removeView
{
    [self.bgView removeFromSuperview];
    [self.stateImageView removeFromSuperview];
    [self.textLabel removeFromSuperview];
}


#pragma mark ---- 发布语音的状态来创建提示视图
-(void)voiceStateWithImage:(NSString *)imageName labelText:(NSString *)text isAnimation:(BOOL)Animation
{
    UIImageView * bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_bg"]];
    bgView.width = 150*RATIO_WIDHT750;
    bgView.height = 132*RATIO_HEIGHT750;
    
    bgView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    
    UIImageView * stateImageView;
    if (!Animation) {
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    }else{
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        stateImageView.animationImages = @[[UIImage imageNamed:imageName],
                                           [UIImage imageNamed:@"donghua_one"],
                                           [UIImage imageNamed:@"donghua_two"],
                                           ];
        stateImageView.animationDuration = 0.6;
        [stateImageView startAnimating];
    }
    stateImageView.y = 15;
    stateImageView.x = (bgView.width - stateImageView.width)/2.0;
    stateImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:stateImageView];
    self.stateImageView = stateImageView;
    
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = text;
    textLabel.y = CGRectGetMaxY(self.stateImageView.frame) + 15;
    textLabel.x = 0;
    textLabel.width = self.bgView.width;
    textLabel.height = 20;
    [self.bgView addSubview:textLabel];
    self.textLabel = textLabel;
}



- (YYChatInputView *)inputView
{
    if (!_inputView) {
        _inputView = [[YYChatInputView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weak_self = self;
        //手指按下
        _inputView.btnInputRecord.recordTouchDownAction = ^(YYRecordButton *sender){
            
            //如果用户没有开启麦克风权限,不能让其录音
            if (![weak_self canRecord]) return ;
            
            //NSLog(@"开始录音");
            if (sender.highlighted) {
                sender.highlighted = YES;
                [sender setButtonStateWithRecording];
            }
            [weak_self.recordTool startRecording];
            
            [weak_self removeView];
            [weak_self voiceStateWithImage:@"shuohua" labelText:@"手指上滑 取消发送" isAnimation:YES];
            
        };
        
        //手指抬起
        _inputView.btnInputRecord.recordTouchUpInsideAction = ^(YYRecordButton *sender) {
            
            //NSLog(@"完成录音");
            [sender setButtonStateWithNormal];
            weak_self.currentRecordTime = weak_self.recordTool.recorder.currentTime;
            
            [weak_self.recordTool stopRecording];
            [weak_self removeView];
//            [weak_self handleRecord];
        };
        
        //手指滑出按钮
        _inputView.btnInputRecord.recordTouchUpOutsideAction = ^(YYRecordButton *sender){
            //NSLog(@"取消录音");
            
            [sender setButtonStateWithNormal];
            [weak_self removeView];
        };
        
        
        //中间状态  从 TouchDragInside ---> TouchDragOutside
        _inputView.btnInputRecord.recordTouchDragExitAction = ^(YYRecordButton *sender){
            
            [weak_self removeView];
            [weak_self voiceStateWithImage:@"quxiao" labelText:@"松开手指 取消发送" isAnimation:NO];
        };
        //中间状态  从 TouchDragOutside ---> TouchDragInside
        _inputView.btnInputRecord.recordTouchDragEnterAction = ^(YYRecordButton *sender){
            //NSLog(@"继续录音");
            
            [weak_self removeView];
            [weak_self voiceStateWithImage:@"shuohua" labelText:@"手指上滑 取消发送" isAnimation:YES];
        };
    }
    return _inputView;
}


#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*RATIO_HEIGHT750;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateData];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT-[self.inputView heightThatFitsSection]) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}
@end
