//
//  NSExceptionCatch.h
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//
//
#import <Foundation/Foundation.h>

@interface NSExceptionCatch : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

