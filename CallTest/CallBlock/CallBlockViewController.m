//
//  CallBlockViewController.m
//  CallTest
//
//  Created by jzy on 2018/2/24.
//  Copyright © 2018年 secretlisa. All rights reserved.
//

#import "CallBlockViewController.h"
#import "FMDataBaseManager.h"
#import <CallKit/CallKit.h>

#define kExtensionIdentifier @"secretlisa.CallTest.CallExtension"

@interface CallBlockViewController ()

@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *tagField;
@property (nonatomic, strong) UIButton *blockBtn;
@property (nonatomic, strong) UIButton *identifierBtn;

@end

@implementation CallBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.numberField];
    [self.view addSubview:self.tagField];
    [self.view addSubview:self.blockBtn];
    [self.view addSubview:self.identifierBtn];
}

- (UITextField *)numberField
{
    if (!_numberField) {
        _numberField = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, 300, 30)];
        _numberField.placeholder = @"number";
    }
    return _numberField;
}

- (UITextField *)tagField
{
    if (!_tagField) {
        _tagField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 300, 30)];
        _tagField.placeholder = @"tag";
    }
    return _tagField;
}

- (UIButton *)blockBtn
{
    if (!_blockBtn) {
        _blockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_blockBtn setTitle:@"block" forState:UIControlStateNormal];
        [_blockBtn addTarget:self action:@selector(pressBlock) forControlEvents:UIControlEventTouchUpInside];
        _blockBtn.frame = CGRectMake(20, 300, 100, 100);
    }
    return _blockBtn;
}

- (UIButton *)identifierBtn
{
    if (!_identifierBtn) {
        _identifierBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_identifierBtn setTitle:@"identifier" forState:UIControlStateNormal];
        [_identifierBtn addTarget:self action:@selector(pressIdentifier) forControlEvents:UIControlEventTouchUpInside];
        _identifierBtn.frame = CGRectMake(150, 300, 100, 100);
    }
    return _identifierBtn;
}

- (void)pressBlock
{
    [self.view endEditing:YES];
    if (self.numberField.text.length <= 0) {
        return;
    }
    
    NSString * phoneNumber = self.numberField.text;
    
    [self reloadBlockList];
}

- (void)pressIdentifier
{
    [self.view endEditing:YES];
    if (self.numberField.text.length <= 0 || self.tagField.text.length <= 0) {
        return;
    }
    
    [self reloadBlockList];
}

#pragma mark - power
- (void)reloadBlockList // 先存好数据，然后reload时 extension里会执行更新，extension里把数据读出来更新就好了
{
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager reloadExtensionWithIdentifier:kExtensionIdentifier completionHandler:^(NSError * _Nullable error) {
        
    }];
}

- (void)permissionStatusConfirm:(void(^)(bool allow)) block {
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager getEnabledStatusForExtensionWithIdentifier:kExtensionIdentifier completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            switch (enabledStatus) {
                case CXCallDirectoryEnabledStatusEnabled:
                    if (block) block(YES); break;
                case CXCallDirectoryEnabledStatusUnknown:
                    // ; break;
                case CXCallDirectoryEnabledStatusDisabled:
                    [self openSetting]; break;
                default: break;
            }
        } else {
            // 获取状态失败
        }
        if (block) block(NO);
    }];
}

- (void)openSetting {
    NSURL *url = [NSURL URLWithString:@"app-Prefs:root=Phone"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
