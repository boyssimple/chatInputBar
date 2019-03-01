//
//  YYAvPlayer.m
//  IMPlayer
//
//  Created by yanyu on 2018/12/25.
//  Copyright © 2018年 yanyu. All rights reserved.
//

#import "YYAvPlayer.h"

#import<AVFoundation/AVFoundation.h>

@interface YYAvPlayer()
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIView *mainView;

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, strong) UIButton *btnClose;

@property (nonatomic, strong) UIButton *btnStop;

@property (nonatomic, strong) UILabel *lbCurrent;
@property (nonatomic, strong) UILabel *lbTotal;
@property (nonatomic, strong) UISlider *btnSlider;
@property (nonatomic, strong) UIActivityIndicatorView *actView;
@property (nonatomic, assign) BOOL isReadToPlay;
@property (nonatomic ,strong) id playbackTimeObserver;
@property (nonatomic, strong) NSString *url;
@end
@implementation YYAvPlayer

- (id)initWith:(NSString*)url{
    
    self = [super initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        windowPlayer = self;
        _url = url;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews{
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT)];
    _mainView.backgroundColor = [UIColor blackColor];
    _mainView.alpha = 1;
    _mainView.userInteractionEnabled = YES;
    [self addSubview:_mainView];
    
    
    NSURL *mediaURL = [NSURL URLWithString:self.url];
    _item = [AVPlayerItem playerItemWithURL:mediaURL];
    _myPlayer = [AVPlayer playerWithPlayerItem:_item];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_myPlayer];
    _playerLayer.frame = self.mainView.frame;
    [_mainView.layer addSublayer:_playerLayer];
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    _btnClose = [[UIButton alloc]init];
    [_btnClose setImage:[UIImage imageNamed:@"avplayer_close"] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_btnClose];
    
    _btnStop = [[UIButton alloc]init];
    [_btnStop setImage:[UIImage imageNamed:@"avplayer_stop"] forState:UIControlStateNormal];
    [_btnStop setImage:[UIImage imageNamed:@"avplayer_play"] forState:UIControlStateSelected];
    [_btnStop addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_btnStop];
    
    _lbCurrent = [[UILabel alloc]init];
    _lbCurrent.font = [UIFont systemFontOfSize:12];
    _lbCurrent.textColor = [UIColor whiteColor];
    _lbCurrent.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_lbCurrent];
    
    _lbTotal = [[UILabel alloc]init];
    _lbTotal.font = [UIFont systemFontOfSize:12];
    _lbTotal.textColor = [UIColor whiteColor];
    _lbTotal.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:_lbTotal];
    
    _btnSlider = [[UISlider alloc]init];
    [_mainView addSubview:_btnSlider];
    
    [_btnSlider addTarget:self action:@selector(avSliderAction) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    
    _actView = [[UIActivityIndicatorView alloc]init];
    _actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [_mainView addSubview:_actView];
    
    CGRect r = _btnClose.frame;
    r.origin.x = 15;
    r.origin.y = 15;
    r.size.width = 30;
    r.size.height = r.size.width;
    _btnClose.frame = r;
    
    r = _btnStop.frame;
    r.size.width = 30;
    r.size.height = r.size.width;
    r.origin.x = 15;
    r.origin.y = DEVICEHEIGHT - r.size.height - 15;
    _btnStop.frame = r;
    
    r = _lbCurrent.frame;
    r.size.width = 40;
    r.size.height = 30;
    r.origin.x = _btnStop.right + 15;
    r.origin.y = _btnStop.y;
    _lbCurrent.frame = r;
    
    r = _lbTotal.frame;
    r.size.width = 40;
    r.size.height = 30;
    r.origin.x = DEVICEWIDTH - 15 - r.size.width;
    r.origin.y = _btnStop.y;
    _lbTotal.frame = r;
    
    r = _btnSlider.frame;
    r.size.width = _lbTotal.x - _lbCurrent.right;
    r.size.height = 30;
    r.origin.x = _lbCurrent.right;
    r.origin.y = _btnStop.y;
    _btnSlider.frame = r;
    _btnSlider.thumbTintColor = [UIColor whiteColor];
    _btnSlider.minimumTrackTintColor = [UIColor whiteColor];
    r = _actView.frame;
    r.origin.x = (DEVICEWIDTH - _actView.width)/2.0;
    r.origin.y = (DEVICEHEIGHT - _actView.height)/2.0;
    _actView.frame = r;
    
    _lbCurrent.text = @"00:00";
    _lbTotal.text = @"00:00";
    
    
    //@"https://media.w3.org/2010/05/sintel/trailer.mp4"
    [_actView startAnimating];
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                self.btnSlider.maximumValue = self.item.duration.value / self.item.duration.timescale;
                long long total = self.item.duration.value / self.item.duration.timescale;
                self.lbTotal.text = [self getFormatDate:total];
                [self.actView stopAnimating];
                [self play];
                [self timerStar];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    }
}


- (void)clickAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self pause];
    }else{
        [self play];
    }
}

- (void)play{
    [self.myPlayer play];
}

- (void)pause{
    [self.myPlayer pause];
}

- (void)avSliderAction{
    //slider的value值为视频的时间
    float seconds = self.btnSlider.value;
    [self seekTo:seconds withPlay:TRUE];
}

- (void)seekTo:(float)value withPlay:(BOOL)isPlay{
    
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(value, self.item.currentTime.timescale);
    //让视频从指定处播放
    [self.myPlayer seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished && isPlay) {
            [self play];
        }
    }];
}

//开启定时
- (void)timerStar {
    //定时回调
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.myPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        long long current = weakSelf.item.currentTime.value / weakSelf.item.currentTime.timescale;
        weakSelf.btnSlider.value = current;
        weakSelf.lbCurrent.text = [weakSelf getFormatDate:current];
    }];
    
}

//视频播放完成的通知
-(void)moviePlayDidEnd:(NSNotification *)notification{
    NSLog(@"播放完成");
    [self seekTo:0 withPlay:FALSE];
    self.btnStop.selected = TRUE;
}

//格式化时间
- (NSString*)getFormatDate:(NSTimeInterval)time {
    int seconds = (int)time % 60;
    int minutes = (int)(time / 60) % 60;
//    int hours = (int)time / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

- (void)dealloc{
    NSLog(@"[DEBUG] delloc:%@",self);
    [self.myPlayer removeTimeObserver:self.playbackTimeObserver];
}



- (void)show {
    [self makeKeyAndVisible];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.mainView.alpha = 1;
    }];
}

- (void)dismiss {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.mainView.alpha = 0;
    } completion:^(BOOL finished) {
        NSArray *subs = [self subviews];
        for (UIView *v in subs) {
            [v removeFromSuperview];
        }
        [self.item removeObserver:self forKeyPath:@"status"];
        windowPlayer = nil;
        [self resignKeyWindow];
    }];
    
}

@end
