//
//  NSExceptionCatcher.m
//  Pods-SegueCoordinatorExample
//
//  Created by Evgeniy Safronov on 05.12.2019.
//

#import "NSExceptionCatcher.h"

@implementation NSExceptionCatcher

+ (BOOL)catchException:(void(NS_NOESCAPE ^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
