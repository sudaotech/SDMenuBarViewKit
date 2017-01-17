//
//  SDMenuBarItem.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "SDMenuBarItem.h"

@implementation SDMenuBarItem

+ (instancetype)barItemWithTitle:(NSString *)title tableView:(UITableView *)tableView
{
    SDMenuBarItem *item = [[self alloc] init];
    
    item.title          = title;
    item.tableView      = tableView;
    
    return item;
}

@end
