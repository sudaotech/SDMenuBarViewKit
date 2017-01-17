//
//  SDCollectionViewLayout.m
//  Pods
//
//  Created by 陈克锋 on 2017/1/16.
//
//

#import "SDCollectionViewLayout.h"

@implementation SDCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize                                       = self.collectionView.frame.size;
    self.minimumLineSpacing                             = 0;
    self.minimumInteritemSpacing                        = 0;
    self.scrollDirection                                = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsVerticalScrollIndicator    = NO;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
    self.collectionView.pagingEnabled                   = YES;
    
}

@end
