//
//  FBAddressContentView.m
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBAddressContentView.h"
#import "FBAddressListView.h"

@interface FBAddressContentView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation FBAddressContentView

static NSString *const cellId = @"collectionViewCellId";

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark setter
- (void)setChildViews:(NSArray<FBAddressListView *> *)childViews {
    _childViews = childViews;
    
    // 刷新
    [self.collectionView reloadData];
    
    // 滚动到指定 cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:childViews.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionLeft) animated:YES];
}

#pragma mark 设置UI界面
- (void)setupUI {
    // 1.添加控件
    [self addSubview:self.collectionView];

    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];

    // 2.自动布局
    // 取消 autoresizing
    for (UIView *subview in self.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSDictionary *viewDict = @{@"collectionView": self.collectionView};
    // 遮罩视图
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];

}

#pragma mark 设置当前内容视图
- (void)setCurrentIndex:(NSInteger)currentIndex {
    // 滚动到指定 cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionLeft) animated:YES];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    //2.给cell设置内容
    //防止多次添加 childVC.view ，所以在添加childVC.view之前先把之前缓存的视图给移除
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    FBAddressListView *listView = self.childViews[indexPath.item];
    listView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:listView];

    return cell;
}

// 停止滑动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        
        //根据scrollView的滚动位置决定pageControl显示第几页
        NSInteger targetIndex = (scrollView.contentOffset.x + self.frame.size.width * 0.5) / self.frame.size.width;
        
        if ([self.delegate respondsToSelector:@selector(addressContentView:targetIndex:)]) {
            [self.delegate addressContentView:self targetIndex:targetIndex];
        }
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end
