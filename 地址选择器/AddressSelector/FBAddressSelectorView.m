//
//  FBAddressSelectorView.m
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBAddressSelectorView.h"
#import "FBAddressTitleView.h"
#import "FBAddressContentView.h"
#import "FBAddressListView.h"
#import "FBAreaModel.h"

@interface FBAddressSelectorView ()<FBAddressTitleViewDelegate, FBAddressContentViewDelegate>
/// 遮罩视图
@property(nonatomic, weak) UIView *maskView;
/// 地址标题视图
@property(nonatomic, weak) FBAddressTitleView *titleView;
/// 地址列表视图
@property(nonatomic, weak) FBAddressContentView *contentView;
@end

@implementation FBAddressSelectorView
#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark setter
- (void)setCityArr:(NSArray *)cityArr {
    _cityArr = cityArr;
    FBAddressListView *listView = [[FBAddressListView alloc] init];
    listView.cityArr = cityArr;
    
    __block FBAddressListView *blockListView = listView;
    __weak typeof(self) weakSelf = self;
    listView.selectedCityBlock = ^(FBAreaModel * _Nonnull model) {
        FBAreaModel *model_1 = model;
        FBAddressListView *listView_2 = [[FBAddressListView alloc] init];
        
        // 如果是像北京，台湾等地区，这里不需要在创建多一个地址列表视图
        if (model.cityList.count == 1) {
            FBAreaModel *model_2 = model.cityList.firstObject;
            listView_2.cityArr = model_2.areaList;
            
            listView_2.selectedCityBlock = ^(FBAreaModel * _Nonnull model) {
                weakSelf.titleView.titleArr = @[model_1.name, model.name];
                
                // 将结果回调出去，并隐藏视图
                !weakSelf.addressBlock?:weakSelf.addressBlock(@"", model_1.name, model.name);
                [weakSelf dismiss];
            };
            
        }else {
            listView_2.cityArr = model.cityList;
            
            __block FBAddressListView *blockListView_2 = listView_2;
            listView_2.selectedCityBlock = ^(FBAreaModel * _Nonnull model) {
                FBAreaModel *model_2 = model;
                
                FBAddressListView *listView_3 = [[FBAddressListView alloc] init];
                listView_3.cityArr = model.areaList;
                
                weakSelf.contentView.childViews = @[blockListView, blockListView_2, listView_3];
                weakSelf.titleView.titleArr = @[model_1.name, model_2.name, @"未选择"];
                
                listView_3.selectedCityBlock = ^(FBAreaModel * _Nonnull model) {
                    weakSelf.titleView.titleArr = @[model_1.name, model_2.name, model.name];
                   
                    // 将结果回调出去，并隐藏视图
                    !weakSelf.addressBlock?:weakSelf.addressBlock(model_1.name, model_2.name, model.name);
                    [weakSelf dismiss];
                };
            };
        }
        
        weakSelf.contentView.childViews = @[blockListView, listView_2];
        weakSelf.titleView.titleArr = @[model_1.name, @"未选择"];
    };
    
    self.contentView.childViews = @[listView];
    self.titleView.titleArr = @[@"未选择"];
}

#pragma mark 设置UI界面
- (void)setupUI {
    self.hidden = YES;
    
    // 1. 创建控件
    // 遮罩视图
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(dismiss)];
    [maskView addGestureRecognizer:tapGes];
    self.maskView = maskView;
    
    // 地址标题视图
    FBAddressTitleView *titleView = [[FBAddressTitleView alloc] init];
    titleView.delegate = self;
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.titleView = titleView;
    
    // 地址列表视图
    FBAddressContentView *contentView = [[FBAddressContentView alloc] init];
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor redColor];
    self.contentView = contentView;
    
    // 2.添加控件
    [self addSubview:maskView];
    [self addSubview:titleView];
    [self addSubview:contentView];
    
    // 3.添加约束
    [self addConstraint];
    
}

/// 添加约束
- (void)addConstraint {
    // 取消 autoresizing
    for (UIView *subview in self.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewDict = @{@"maskView": self.maskView,
                               @"titleView": self.titleView,
                               @"listView": self.contentView};
    
    // 遮罩视图
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[maskView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[maskView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    
    // 地址标题视图
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[titleView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:200]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:80]];
    
    // 地址列表视图
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[listView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.titleView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
}

#pragma mark 显示 && 隐藏
- (void)show {
    self.hidden = NO;
    self.titleView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.contentView.frame));
    self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.contentView.frame));
    [UIView animateWithDuration:0.3 animations:^{
        self.titleView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.maskView.alpha = 0.5;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.titleView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.contentView.frame));
        self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.contentView.frame));
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark FBAddressTitleViewDelegate
- (void)addressTitleView:(FBAddressTitleView *)titleView selectedIndex:(NSInteger)index {
    [self.contentView setCurrentIndex:index];
}

#pragma mark FBAddressContentViewDelegate
- (void)addressContentView:(FBAddressContentView *)contentView targetIndex:(NSInteger)targetIndex {
    [self.titleView setTitleWithTargetIndex:targetIndex];
}
@end
