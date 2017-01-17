//
//  SDViewController.m
//  SDMenuBarViewKit
//
//  Created by sfuser on 01/16/2017.
//  Copyright (c) 2017 sfuser. All rights reserved.
//

#import "SDViewController.h"
#import "SDDemoTableView.h"

#import <SDMenuBarViewKit/SDMenuBarView.h>
#import <SDMenuBarViewKit/SDMenuBarItem.h>

@interface SDViewController ()

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SDMenuBarItem *item1 = [SDMenuBarItem barItemWithTitle:@"课题" tableView:[SDDemoTableView new]];
    SDMenuBarItem *item2 = [SDMenuBarItem barItemWithTitle:@"话题" tableView:[SDDemoTableView new]];
    SDMenuBarItem *item3 = [SDMenuBarItem barItemWithTitle:@"政策" tableView:[SDDemoTableView new]];
    SDMenuBarItem *item4 = [SDMenuBarItem barItemWithTitle:@"新闻" tableView:[SDDemoTableView new]];
    
    SDMenuBarView *menuBarView = [[SDMenuBarView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    menuBarView.barItems = @[item1, item2, item3, item4];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160)];
    
    headView.backgroundColor = [UIColor redColor];
    menuBarView.headerView = headView;
    
    [self.view addSubview:menuBarView];
}

@end
