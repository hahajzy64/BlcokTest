//
//  ViewController.m
//  CallTest
//
//  Created by jzy on 2018/2/23.
//  Copyright © 2018年 secretlisa. All rights reserved.
//

#import "ViewController.h"
#import "CallBlockViewController.h"
#import "MessageBlockViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *callBlockBtn;
@property (nonatomic, strong) UIButton *messageBlockBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.callBlockBtn];
    [self.view addSubview:self.messageBlockBtn];
}

- (UIButton *)callBlockBtn
{
    if (!_callBlockBtn) {
        _callBlockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_callBlockBtn setTitle:@"Call Blcok" forState:UIControlStateNormal];
        [_callBlockBtn addTarget:self action:@selector(pressCallBlcok) forControlEvents:UIControlEventTouchUpInside];
        _callBlockBtn.frame = CGRectMake(80, 90, 100, 100);
    }
    return _callBlockBtn;
}

- (UIButton *)messageBlockBtn
{
    if (!_messageBlockBtn) {
        _messageBlockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_messageBlockBtn setTitle:@"Message Blcok" forState:UIControlStateNormal];
        [_messageBlockBtn addTarget:self action:@selector(pressMessageBlcok) forControlEvents:UIControlEventTouchUpInside];
        _messageBlockBtn.frame = CGRectMake(80, 190, 200, 100);
    }
    return _messageBlockBtn;
}

- (void)pressCallBlcok
{
    [self.navigationController pushViewController:[CallBlockViewController new] animated:YES];
}

- (void)pressMessageBlcok
{
    [self.navigationController pushViewController:[MessageBlockViewController new] animated:YES];
}

@end
