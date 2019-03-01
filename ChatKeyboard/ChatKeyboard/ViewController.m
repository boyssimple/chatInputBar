//
//  ViewController.m
//  ChatKeyboard
//
//  Created by yons on 2019/2/26.
//  Copyright © 2019年 yons. All rights reserved.
//

#import "ViewController.h"
#import "VCChat.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)clickAction:(id)sender {
    VCChat *vc = [[VCChat alloc] init];
    [self.navigationController pushViewController:vc animated:TRUE];
}


@end
