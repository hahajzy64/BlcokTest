//
//  MJCondition.h
//  MessageJudge
//
//  Created by GeXiao on 08/06/2017.
//  Copyright © 2017 GeXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJQueryRequest.h"
#import "JSONModel.h"

static NSString *MJExtentsionAppGroupName = @"group.secretlisa.BlockDemo";
static NSString *MJExtentsionRuleKey = @"MJExtentsionRuleKey";

typedef NS_ENUM(NSInteger, MJConditionTarget) {
    MJConditionTargetSender = 0,
    MJConditionTargetContent
};

typedef NS_ENUM(NSInteger, MJConditionType) {
    MJConditionTypeHasPrefix = 0,
    MJConditionTypeHasSuffix,
    MJConditionTypeContains,
    MJConditionTypeNotContains,
    MJConditionTypeContainsRegex
};

@interface MJCondition : JSONModel

@property (nonatomic, assign) MJConditionTarget conditionTarget;
@property (nonatomic, assign) MJConditionType conditionType;
@property (nonatomic, copy) NSString *keyword;

- (BOOL)isMatchedForRequest:(MJQueryRequest *)request;

- (NSString *)modelToString;

@end
