//
//  SDMenuBar.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "SDMenuBar.h"
#import "UIColor+SDHex.h"
#import "UIView+SDDeleteSubView.h"

@interface SDMenuBar ()
@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, strong) UIView                        *lineView;
@property (nonatomic, strong) UIView                        *indicatorLineView;

@property (nonatomic, strong) UIButton                      *selectedButton;
@property (nonatomic, strong) NSMutableArray<UIButton *>    *buttonList;

@end

@implementation SDMenuBar

#define kScreenW            [UIScreen mainScreen].bounds.size.width
#define kDefaultPadding     5
static NSInteger const kBasicTag = 0xf890;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor                            = [UIColor whiteColor];
    self.scrollView                                 = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.backgroundColor                 = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    self.lineView                                   = [[UIView alloc] init];
    self.lineView.backgroundColor                   = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:self.lineView];
    
    self.indicatorLineView                          = [[UIView alloc] init];
    self.indicatorLineView.layer.cornerRadius       = 1;
    self.indicatorLineView.layer.masksToBounds      = YES;
}

- (void)setTitleList:(NSArray<NSString *> *)titleList
{
    _titleList = titleList;
    [self.scrollView removeAllSubview];
    [self.scrollView addSubview:self.indicatorLineView];
    self.indicatorLineView.backgroundColor = self.indicatorLineColor;
    
    [titleList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = kBasicTag + idx;
        [button sizeToFit];
        [self.scrollView addSubview:button];
        [self.buttonList addObject:button];
        
        if (idx == 0) {
            button.selected = YES;
            self.selectedButton = button;
            
        }

    }];
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame   = self.bounds;
    self.lineView.frame     = CGRectMake(0,
                                         CGRectGetHeight(self.frame) - self.bottomLineHeight,
                                         self.frame.size.width,
                                         self.bottomLineHeight);
    
    CGFloat buttonW = [self fetchMaxWidth];
    
    __weak typeof(self) weakSelf = self;
    [self.buttonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectMake(idx * (buttonW + kDefaultPadding), 0, buttonW, weakSelf.scrollView.frame.size.height);
        weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(obj.frame)+1, 0);
        if (idx == 0) {
            
            CGRect rect = [weakSelf.scrollView convertRect:obj.titleLabel.frame fromView:obj];
            
            weakSelf.indicatorLineView.frame = CGRectMake(
                                        CGRectGetMinX(rect),
                                        CGRectGetMaxY(obj.frame) - self.indicatorLineHeight,
                                        CGRectGetWidth(rect),
                                        self.indicatorLineHeight);
        }
    }];
    
    
}

- (void)buttonDidClick:(UIButton *)button
{
//    self.selectedButton.selected = NO;
//    self.selectedButton          = button;
//    self.selectedButton.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(menuBar:didSelectedAtIndex:)]) {
        [self.delegate menuBar:self didSelectedAtIndex:button.tag - kBasicTag];
    }
}

- (void)setContentOffsetX:(CGFloat)offsetX offsetRatio:(CGFloat)offsetRatio
{
    
    if (self.selectedButton.tag - kBasicTag != lround(offsetRatio)) {
        UIButton *button = self.buttonList[lround(offsetRatio)];
        self.selectedButton.selected = NO;
        self.selectedButton          = button;
        self.selectedButton.selected = YES;
        
    }
    CGRect rect = [self.scrollView convertRect:self.selectedButton.titleLabel.frame fromView:self.selectedButton];


    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.indicatorLineView.frame = CGRectMake(
                                        CGRectGetMinX(rect),
                                        CGRectGetMaxY(weakSelf.selectedButton.frame) - self.indicatorLineHeight,
                                        CGRectGetWidth(rect),
                                        self.indicatorLineHeight);
    }];
}

/**
 获取button的最大宽度

 @return button最大宽度
 */
- (CGFloat)fetchMaxWidth {
    
    if (self.buttonList.count == 0) {
        return 0.0;
    }
    
    __block CGFloat maxW = 0.0;
    [self.buttonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxW < CGRectGetWidth(obj.frame)) {
            maxW = CGRectGetWidth(obj.frame);
        }
    }];
    
    if ((maxW + kDefaultPadding) * self.buttonList.count - kDefaultPadding <= kScreenW) {
        maxW = (kScreenW - (self.titleList.count - 1) * kDefaultPadding) / self.buttonList.count;
    }
    
    return maxW;
}

#pragma mark - lazy

@synthesize indicatorLineHeight = _indicatorLineHeight;
- (void)setIndicatorLineHeight:(CGFloat)indicatorLineHeight {
    _indicatorLineHeight = indicatorLineHeight;
    [self setNeedsLayout];
}

- (CGFloat)indicatorLineHeight {
    return _indicatorLineHeight == 0 ? 2 : _indicatorLineHeight;
}


@synthesize bottomLineHeight = _bottomLineHeight;

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    _bottomLineHeight = bottomLineHeight;
    [self setNeedsLayout];
}

- (CGFloat)bottomLineHeight {
    return _bottomLineHeight == 0 ? 0.5 : _bottomLineHeight;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    self.lineView.backgroundColor = bottomLineColor;
}

@synthesize selectedColor = _selectedColor;

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _selectedColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self.buttonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:selectedColor forState:UIControlStateSelected];
    }];
}

@synthesize normalColor = _normalColor;
- (UIColor *)normalColor
{
    if (!_normalColor) {
        _normalColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _normalColor;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self.buttonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:normalColor forState:UIControlStateNormal];
    }];
}

@synthesize indicatorLineColor = _indicatorLineColor;
- (UIColor *)indicatorLineColor
{
    if (!_indicatorLineColor) {
        _indicatorLineColor = [UIColor colorWithHexString:@"#E52C4E"];
    }
    return _indicatorLineColor;
}

- (void)setIndicatorLineColor:(UIColor *)indicatorLineColor {
    _indicatorLineColor = indicatorLineColor;
    self.indicatorLineView.backgroundColor = _indicatorLineColor;
}

- (NSMutableArray<UIButton *> *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

@end
