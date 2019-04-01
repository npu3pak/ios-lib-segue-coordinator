
#import <Foundation/Foundation.h>

@interface NSExceptionCatch : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

