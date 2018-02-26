//
//  CallDirectoryHandler.m
//  CallExtension
//
//  Created by jzy on 2018/2/23.
//  Copyright © 2018年 secretlisa. All rights reserved.
//

#import "CallDirectoryHandler.h"
#import "FMDataBaseManager.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

// 执行CXCallDirectoryManager reloadExtensionWithIdentifier方法的时候会调用这个方法，在这里把屏蔽或标记写入context
- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
    // and identification entries which have been added or removed since the last time this extension's data was loaded.
    // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
    // and identification phone numbers if the request is not incremental.
//    if (context.isIncremental) {
//        [self addOrRemoveIncrementalBlockingPhoneNumbersToContext:context];
//
//        [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
//    } else {
//        [self addAllBlockingPhoneNumbersToContext:context];
//
//        [self addAllIdentificationPhoneNumbersToContext:context];
//    }
//
//    [context completeRequestWithCompletionHandler:nil];
    
    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

// 自己加的方法，屏蔽
- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    NSArray * contacts = [[FMDataBaseManager shareInstance] getAllContacts:kBlockNumberTable];
//    for (int i= 0; i < contacts.count; i ++) {
//        @autoreleasepool {
//            ContactModel * contact = contacts[i];
//            if (contact.phoneNumber) {
//                CXCallDirectoryPhoneNumber phoneNumber = [contact.phoneNumber longLongValue];
//                [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//            }
//            contact = nil;
//        }
//    }
//    return YES;
    CXCallDirectoryPhoneNumber phoneNumber = [@"+8618513029845" longLongValue];
    [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    return YES;
}

// 自己加的方法，标记
- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    NSArray * contacts = [[FMDataBaseManager shareInstance] getAllContacts:kNumberTable];
//    for (int i= 0; i < contacts.count; i ++) {
//        @autoreleasepool {
//            ContactModel * contact = contacts[i];
//            if (contact.phoneNumber && contact.identification) {
//                CXCallDirectoryPhoneNumber phoneNumber = [contact.phoneNumber longLongValue];
//                NSString * label = contact.identification;
//                [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//            }
//            contact = nil;
//        }
//    }
//    CXCallDirectoryPhoneNumber phoneNumber = [@"+8618513029845" longLongValue];
//    NSString * label = @"标记123";
//    [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    return YES;
}

// 下方是原始生成的示例代码

// 批量添加屏蔽
//- (void)addAllBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
//    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
//    //
//    // Numbers must be provided in numerically ascending order.
//    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 14085555555, 18005555555 };
//    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger index = 0; index < count; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }
//}

// 批量添加、删除屏蔽
//- (void)addOrRemoveIncrementalBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
//    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
//    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 14085551234 };
//    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger index = 0; index < countOfPhoneNumbersToAdd; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }
//
//    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 18005555555 };
//    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger index = 0; index < countOfPhoneNumbersToRemove; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[index];
//        [context removeBlockingEntryWithPhoneNumber:phoneNumber];
//    }
//
//    // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
//}

// 批量添加标记
//- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
//    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
//    //
//    // Numbers must be provided in numerically ascending order.
//    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 18775555555, 18885555555 };
//    NSArray<NSString *> *labels = @[ @"Telemarketer", @"Local business" ];
//    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger i = 0; i < count; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[i];
//        NSString *label = labels[i];
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }
//}

// 批量添加、删除标记
//- (void)addOrRemoveIncrementalIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
//    // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
//    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
//    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 14085555678 };
//    NSArray<NSString *> *labelsToAdd = @[ @"New local business" ];
//    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger i = 0; i < countOfPhoneNumbersToAdd; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[i];
//        NSString *label = labelsToAdd[i];
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }
//
//    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 18885555555 };
//    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger i = 0; i < countOfPhoneNumbersToRemove; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[i];
//        [context removeIdentificationEntryWithPhoneNumber:phoneNumber];
//    }
//
//    // Record the most-recently loaded set of identification entries in data store for the next incremental load...
//}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
