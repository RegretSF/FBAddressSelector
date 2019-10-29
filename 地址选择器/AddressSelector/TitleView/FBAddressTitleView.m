//
//  FBAddressTitleView.m
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBAddressTitleView.h"

@interface FBAddressTitleView ()
@property(nonatomic, weak) UIView *filletView;
@property(nonatomic, weak) UILabel *tipLabel;
@property(nonatomic, weak) UIView *bottomLineView;
@property(nonatomic, weak) UIView *scrollLineView;
@property(nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
@end

@implementation FBAddressTitleView {
    /// 是否重新布局
    BOOL _isReLayout;
}
#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 0.判断是否重新布局
    if (!_isReLayout) { return; }
    
    // 圆角视图
    self.filletView.frame = CGRectMake(0, -10, self.bounds.size.width, self.bounds.size.height - 35);
    self.tipLabel.frame = CGRectMake(15, 15, 100, 30);
    self.cancelBtn.frame = CGRectMake(self.bounds.size.width - 30, 10, 30, 30);
    
    // 1.底部分割线
    CGFloat lineH = 1;
    self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - lineH, self.bounds.size.width, lineH);
    
    // 2.隐藏所有的 label
    for (UILabel *label in self.titleLabels) {
        label.hidden = YES;
        label.textColor = UIColor.darkTextColor;
    }
    
    // 3.设置 label 的frame
    __block CGFloat tempW = 0;
    [self.titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算 label 的宽度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
        CGFloat labelW = [obj sizeWithAttributes:attrs].width + 30;
        tempW += labelW;
        
        // 设置 label 的属性
        UILabel *label = self.titleLabels[idx];
        label.text = obj;
        label.font = [UIFont systemFontOfSize:16];
        label.hidden = NO;
        label.frame = CGRectMake(tempW - labelW, self.bounds.size.height - 35, labelW, 35);
        
        if (idx == self.titleArr.count - 1) {
            // 4.设置滑块的位置
            CGFloat scrollLineY = self.bounds.size.height - 2;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollLineView.frame = CGRectMake(tempW - labelW + 15, scrollLineY, labelW - 30, 2);
            }];
            
            // 设置 label 选中的文字颜色
            label.textColor = UIColor.redColor;
        }
    }];
}

#pragma mark setter
- (void)setTitleArr:(NSArray<NSString *> *)titleArr {
    _titleArr = titleArr;
    _isReLayout = YES;
    
    [self layoutSubviews];
}

#pragma mark 监听方法
- (void)clickLabel:(nullable UITapGestureRecognizer *)tapGes {
    
    [self setTitleWithTargetIndex:tapGes.view.tag];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(addressTitleView:selectedIndex:)]) {
        [self.delegate addressTitleView:self selectedIndex:tapGes.view.tag];
    }
}

#pragma mark 对外暴露的方法
- (void)setTitleWithTargetIndex:(NSInteger)targetIndex {
    // 0.记录是否是重新布局
    _isReLayout = NO;
    
    // 1.取出 label
    UILabel *currentLabel = self.titleLabels[targetIndex];
    
    // 2.改变滑块的位置 self.titleArr
    CGFloat scrollLineY = self.bounds.size.height - 2;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollLineView.frame = CGRectMake(currentLabel.frame.origin.x + 15,
                                               scrollLineY,
                                               currentLabel.frame.size.width - 30,
                                               2);
    }];
    
    // 3.改变label的颜色
    for (UILabel *label in self.titleLabels) {
        label.textColor = UIColor.darkTextColor;
    }
    currentLabel.textColor = UIColor.redColor;
}

#pragma mark 设置UI界面
- (void)setupUI {
    // 0.添加顶部圆角视图
    UIView *filletView = [[UIView alloc] init];
    filletView.backgroundColor = UIColor.whiteColor;
    filletView.layer.cornerRadius = 10;
    filletView.layer.masksToBounds = YES;
    self.filletView = filletView;
    [self addSubview:filletView];
    
    // 添加提示语句
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"配送至";
    tipLabel.font = [UIFont systemFontOfSize:20 weight:16];
    self.tipLabel = tipLabel;
    [filletView addSubview:tipLabel];
    
    // 添加右边删除按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    self.cancelBtn = cancelBtn;
    [filletView addSubview:cancelBtn];
    
    // 1.添加底部分割线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = UIColor.lightGrayColor;
    self.bottomLineView = bottomLineView;
    [self addSubview:bottomLineView];

    // 2.创建label
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.textColor = UIColor.darkTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabel:)];
        [label addGestureRecognizer:tapGes];
        [self.titleLabels addObject:label];
        [self addSubview:label];
    }
    
    // 3.添加滑块
    UIView *scrollLineView = [[UIView alloc] init];
    scrollLineView.backgroundColor = UIColor.redColor;
    self.scrollLineView = scrollLineView;
    [self addSubview:scrollLineView];
}

#pragma mark 懒加载
- (NSMutableArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
@end
