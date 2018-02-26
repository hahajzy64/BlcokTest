//
//  MessageFilterExtension.m
//  MessageExtension
//
//  Created by jzy on 2018/2/24.
//  Copyright © 2018年 secretlisa. All rights reserved.
//

#import "MessageFilterExtension.h"
#import "JSONModel.h"
#import "MJCondition.h"
#import "MJQueryRequest.h"

@interface MessageFilterExtension () <ILMessageFilterQueryHandling>
@end

@implementation MessageFilterExtension

#pragma mark - ILMessageFilterQueryHandling

// 短信来了就调用这个方法
- (void)handleQueryRequest:(ILMessageFilterQueryRequest *)queryRequest context:(ILMessageFilterExtensionContext *)context completion:(void (^)(ILMessageFilterQueryResponse *))completion {
    // First, check whether to filter using offline data (if possible).
    ILMessageFilterAction offlineAction = [self offlineActionForQueryRequest:queryRequest];
    
    switch (offlineAction) {
        case ILMessageFilterActionAllow:
        case ILMessageFilterActionFilter: {
            // Based on offline data, we know this message should either be Allowed or Filtered. Send response immediately.
            ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
            response.action = offlineAction;
            
            completion(response);
            break;
        }
            
        case ILMessageFilterActionNone: {
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            [context deferQueryRequestToNetworkWithCompletion:^(ILNetworkResponse *_Nullable networkResponse, NSError *_Nullable error) {
                ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
                response.action = ILMessageFilterActionNone;
                
                if (networkResponse) {
                    // If we received a network response, parse it to determine an action to return in our response.
                    response.action = [self actionForNetworkResponse:networkResponse];
                } else {
                    NSLog(@"Error deferring query request to network: %@", error);
                }
                
                completion(response);
            }];
            break;
        }
    }
}

// 在这里检测是否是要屏蔽的短信，是就返回ILMessageFilterActionFilter
- (ILMessageFilterAction)offlineActionForQueryRequest:(ILMessageFilterQueryRequest *)queryRequest {
    // Replace with logic to perform offline check whether to filter first (if possible).
    NSString *messageContent = queryRequest.messageBody;
    MJQueryRequest *request = [[MJQueryRequest alloc] initWithSystemQueryRequest:queryRequest];
    NSUserDefaults *extDefaults = [[NSUserDefaults alloc] initWithSuiteName:MJExtentsionAppGroupName];
    NSArray *ruleArr = [extDefaults objectForKey:MJExtentsionRuleKey];
    for (NSString *json in ruleArr) {
        MJCondition *condition = [[MJCondition alloc] initWithString:json error:nil];
        if ([condition isMatchedForRequest:request]) {
            return ILMessageFilterActionFilter;
        }
    }
    return ILMessageFilterActionAllow;
}

// 可以用我们服务器来检测是否屏蔽，未调研
- (ILMessageFilterAction)actionForNetworkResponse:(ILNetworkResponse *)networkResponse {
    // Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
    return ILMessageFilterActionNone;
}

@end
