//
//  FBAddressContentView.h
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FBAddressListView, FBAddressContentView;
@protocol FBAddressContentViewDelegate <NSObject>

- (void)addressContentView:(FBAddressContentView *)contentView targetIndex:(NSInteger)targetIndex;

@end

@interface FBAddressContentView : UIView
@property(nonatomic,weak) id <FBAddressContentViewDelegate>delegate;

@property(nonatomic, strong) NSArray<FBAddressListView *> *childViews;

/// 设置当前内容视图
/// @param currentIndex 索引
- (void)setCurrentIndex:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
