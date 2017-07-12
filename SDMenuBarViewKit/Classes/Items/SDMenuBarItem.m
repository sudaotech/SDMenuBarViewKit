//
//  SDMenuBarItem.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "SDMenuBarItem.h"

@implementation SDMenuBarItem

+ (instancetype)barItemWithTitle:(NSString *)title scrollView:(UIScrollView *)scrollView
{
    SDMenuBarItem *item = [[self alloc] init];
    
    item.title          = title;
    item.scrollView      = scrollView;
    
    return item;
}

@end
