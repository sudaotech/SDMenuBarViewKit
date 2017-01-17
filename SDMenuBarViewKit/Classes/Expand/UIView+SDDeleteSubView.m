//
//  UIView+SDDeleteSubView.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "UIView+SDDeleteSubView.h"

@implementation UIView (SDDeleteSubView)

- (void)removeAllSubview {
    NSArray<UIView *> *subviews = self.subviews;
    
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

@end
