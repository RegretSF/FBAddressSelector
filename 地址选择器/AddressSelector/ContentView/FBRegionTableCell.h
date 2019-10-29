//
//  FBRegionTableCell.h
//  地址选择器
//
//  Created by Mac on 2019/10/29.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FBAreaModel;

@interface FBRegionTableCell : UITableViewCell
@property(nonatomic, strong) FBAreaModel *model;
@property(nonatomic, strong) UILabel *arrowLabel;
@end

NS_ASSUME_NONNULL_END
