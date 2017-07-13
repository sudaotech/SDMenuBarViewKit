//
//  NSObject+RemoveKVO.m
//  Pods
//
//  Created by 陈克锋 on 2017/7/13.
//
//

#import "NSObject+RemoveKVO.h"
#import <objc/message.h>


@implementation NSObject (RemoveKVO)

+ (void)load {
    Method m1 = class_getInstanceMethod([self class], @selector(sd_removeObserver:forKeyPath:));
    Method m2 = class_getInstanceMethod([self class], @selector(removeObserver:forKeyPath:));
    method_exchangeImplementations(m1, m2);
}

- (void)sd_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @try {
        [self sd_removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
