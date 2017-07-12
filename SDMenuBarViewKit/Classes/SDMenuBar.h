//
//  SDMenuBar.h
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import <UIKit/UIKit.h>
@class SDMenuBar;
@protocol SDMenuBarDelegate <NSObject>

- (void)menuBar:(SDMenuBar *)menuBar didSelectedAtIndex:(NSInteger)index;

@end

@interface SDMenuBar : UIView
@property (nonatomic, strong) NSArray<NSString *> *titleList;

@property (nonatomic, assign) CGFloat bottomLineHeight;     // 底部分割线的高度
@property (nonatomic, strong) UIColor *bottomLineColor;     // 底部分割线的颜色， 默认#eeeeee
@property (nonatomic, strong) UIColor *selectedColor;       // 菜单选中时的颜色， 默认#333333
@property (nonatomic, strong) UIColor *normalColor;         // 菜单普通状态下的颜色， 默认#999999
@property (nonatomic, strong) UIColor *indicatorLineColor;  // 指示线颜色， 默认#E52C4E
@property (nonatomic, assign) CGFloat indicatorLineHeight;  // 指示线的高度

@property (nonatomic, weak)   id<SDMenuBarDelegate> delegate; //代理

/**
 设置偏移量

 @param offsetX 偏移量
 @param offsetRatio 偏移量比例
 */
- (void)setContentOffsetX:(CGFloat)offsetX offsetRatio:(CGFloat)offsetRatio;

@end
