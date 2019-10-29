//
//  FBAddressTitleView.h
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FBAddressTitleView;

@protocol FBAddressTitleViewDelegate <NSObject>

- (void)addressTitleView:(FBAddressTitleView *)titleView selectedIndex:(NSInteger)index;

@end

@interface FBAddressTitleView : UIView
@property(nonatomic, weak) id <FBAddressTitleViewDelegate>delegate;
@property(nonatomic, strong) NSArray<NSString *> *titleArr;
@property(nonatomic, weak) UIButton *cancelBtn;

/**
 对外暴露的方法
 @param targetIndex 目标索引
 */
- (void)setTitleWithTargetIndex:(NSInteger)targetIndex;
@end

NS_ASSUME_NONNULL_END
