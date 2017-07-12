//
//  SDMenuBarView.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "SDMenuBarView.h"

//#import "SDMenuBar.h"
#import "SDMenuBarItem.h"

#import "UIView+SDDeleteSubView.h"
#import "SDCollectionViewLayout.h"

@interface SDMenuBarView ()<UICollectionViewDataSource, UICollectionViewDelegate, SDMenuBarDelegate>

@property (nonatomic, strong) UIView            *topView;           // 顶部视图
@property (nonatomic, strong) UICollectionView  *collectionView;    // 底部承载tableView的视图
@property (nonatomic, strong) SDMenuBar         *menuBar;           // 顶部菜单
@end

@implementation SDMenuBarView

static NSString *const kReuseIdentifier = @"SDMenuBarCollectionViewCell";
static CGFloat   const kDefaultMenuBarH = 50;     //默认menuBar高度
static NSInteger const kBasicTag        = 0xffff; //默认TAG起点

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.collectionView     = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:[SDCollectionViewLayout new]];
    
    self.topView            = [[UIView alloc] init];
    
    self.menuBar            = [[SDMenuBar alloc] init];
    self.menuBar.delegate   = self;
    
    [self               addSubview: self.collectionView];
    [self               addSubview: self.topView];
    [self.topView       addSubview: self.menuBar];
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kReuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.topView.backgroundColor        = [UIColor whiteColor];
}

- (void)setHeaderView:(UIView *)headerView
{
    [self.headerView removeFromSuperview];
    
    _headerView = headerView;
    if (headerView) {
        [self.topView addSubview:headerView];
    }
    [self setNeedsLayout];
    [self.collectionView reloadData];
}

- (void)setBarItems:(NSArray<SDMenuBarItem *> *)barItems
{
    _barItems = barItems;
    self.menuBar.titleList = [barItems.mutableCopy mutableArrayValueForKey:@"title"];
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame   = self.bounds;
    
    self.topView.frame          = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(self.frame),
                                             CGRectGetMaxY(self.headerView.frame) + kDefaultMenuBarH);
    if (self.headerView) {
        self.headerView.frame   = CGRectMake(0,
                                             0,
                                             CGRectGetWidth(self.frame),
                                             CGRectGetHeight(self.headerView.frame));
    }
    
    self.menuBar.frame          = CGRectMake(0,
                                             CGRectGetMaxY(self.headerView.frame),
                                             CGRectGetWidth(self.frame),
                                             kDefaultMenuBarH);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.barItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView removeAllSubview];

    UIScrollView *scrollView = self.barItems[indexPath.item].scrollView;
    if (scrollView) {
        scrollView.backgroundColor       = [UIColor whiteColor];
        scrollView.frame                 = self.bounds;
        scrollView.tag                   = kBasicTag + indexPath.item;
        
        scrollView.contentInset          = UIEdgeInsetsMake(
                                                           CGRectGetHeight(self.topView.frame),
                                                           0,
                                                           0,
                                                           0);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(
                                                           CGRectGetHeight(self.topView.frame),
                                                           0,
                                                           0,
                                                           0);
        [cell.contentView addSubview:scrollView];
    } else {
        NSLog(@"no tableView found in menuBarItem(%@).....", self.barItems[indexPath.item]);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableView = [cell.contentView viewWithTag:kBasicTag + indexPath.item];
    tableView.contentOffset = CGPointMake(0, -CGRectGetMaxY(self.topView.frame));
    
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableView = [cell.contentView viewWithTag:kBasicTag + indexPath.item];
    [tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX     = scrollView.contentOffset.x;
    CGFloat offsetRatio = offsetX / CGRectGetWidth(scrollView.frame);
    [self.menuBar setContentOffsetX:offsetX offsetRatio:offsetRatio];
}

#pragma mark - SDMenuBarDelegate
- (void)menuBar:(SDMenuBar *)menuBar didSelectedAtIndex:(NSInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y + CGRectGetHeight(self.topView.frame);
        if (offsetY > CGRectGetHeight(self.headerView.frame)) {
            offsetY = CGRectGetHeight(self.headerView.frame);
        } else if(offsetY <= 0) {
            offsetY = 0;
        }
        CGRect rect = self.topView.frame;
        rect.origin.y = -offsetY;
        self.topView.frame = rect;
    }
}

- (void)dealloc
{
    [self.barItems enumerateObjectsUsingBlock:^(SDMenuBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @try {
            [obj.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        } @finally {
            
        }
        
    }];
}

@end
