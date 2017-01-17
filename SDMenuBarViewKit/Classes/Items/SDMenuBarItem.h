//
//  SDMenuBarItem.h
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import <Foundation/Foundation.h>

@interface SDMenuBarItem : NSObject
/**
 标题
 */
@property (nonatomic, strong) NSString      *title;

/**
 内容对应的tableView
 */
@property (nonatomic, strong) UITableView   *tableView;

+ (instancetype)barItemWithTitle:(NSString *)title tableView:(UITableView *)tableView;

@end
