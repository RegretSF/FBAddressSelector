//
//  FBAddressListView.h
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FBAreaModel;
typedef void(^FBAddressListViewAction)(FBAreaModel *model);

@interface FBAddressListView : UIView
@property(nonatomic, strong) NSArray *cityArr;
@property(nonatomic, copy) FBAddressListViewAction selectedCityBlock;
@end

NS_ASSUME_NONNULL_END
