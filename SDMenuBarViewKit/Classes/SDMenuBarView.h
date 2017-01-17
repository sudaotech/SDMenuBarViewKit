//
//  SDMenuBarView.h
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import <UIKit/UIKit.h>

@class SDMenuBarItem;

@interface SDMenuBarView : UIView

/**
 头部视图
 */
@property (nonatomic, strong) UIView                    *headerView;

/**
 内容
 */
@property (nonatomic, strong) NSArray<SDMenuBarItem *>  *barItems;

@end
