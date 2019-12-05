//
//  NSExceptionCatcher.h
//  Pods-SegueCoordinatorExample
//
//  Created by Evgeniy Safronov on 05.12.2019.
//

#import <Foundation/Foundation.h>

@interface NSExceptionCatcher : NSObject

+ (BOOL)catchException:(void(NS_NOESCAPE ^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
