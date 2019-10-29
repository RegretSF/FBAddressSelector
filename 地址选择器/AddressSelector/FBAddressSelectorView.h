//
//  FBAddressSelectorView.h
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FBAddressSelectorViewAction)(NSString *provinceName, NSString *cityName, NSString *regionName);

@interface FBAddressSelectorView : UIView
// 城市数组
@property(nonatomic, strong) NSArray *cityArr;
/// 选完地址后的回调
@property(nonatomic, copy) FBAddressSelectorViewAction addressBlock;

/// 显示视图的方法
- (void)show;
@end

NS_ASSUME_NONNULL_END
