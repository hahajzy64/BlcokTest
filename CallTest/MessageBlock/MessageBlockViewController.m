//
//  MessageBlockViewController.m
//  CallTest
//
//  Created by jzy on 2018/2/24.
//  Copyright © 2018年 secretlisa. All rights reserved.
//

#import "MessageBlockViewController.h"
#import "MJCondition.h"

@interface MessageBlockViewController ()

@property (nonatomic, strong) UITextField *tagField;
@property (nonatomic, strong) UIButton *blockBtn;

@end

@implementation MessageBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tagField];
    [self.view addSubview:self.blockBtn];
}

- (UITextField *)tagField
{
    if (!_tagField) {
        _tagField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 300, 30)];
        _tagField.placeholder = @"content";
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

- (void)pressBlock
{
    [self.view endEditing:YES];
    
    if (self.tagField.text.length<=0) {
        return;
    }
    
    MJCondition *condition = [MJCondition new];
    condition.conditionTarget = MJConditionTargetContent;
    condition.conditionTarget = MJConditionTypeContains;
    condition.keyword = self.tagField.text;
    NSString *ruleString = [condition modelToString];
    
    NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
    NSArray *localArr = [extDefaults objectForKey:MJExtentsionRuleKey];
    localArr = (localArr.count>0)? localArr:[NSArray new];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:localArr];
    [tempArr addObject:ruleString];
    [extDefaults setObject:tempArr forKey:MJExtentsionRuleKey];
}

@end
