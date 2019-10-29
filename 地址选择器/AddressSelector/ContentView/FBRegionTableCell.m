//
//  FBRegionTableCell.m
//  地址选择器
//
//  Created by Mac on 2019/10/29.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBRegionTableCell.h"
#import "FBAreaModel.h"

@interface FBRegionTableCell ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIView *bottomLineView;
@end

@implementation FBRegionTableCell
#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineH = 1;
    self.bottomLineView.frame = CGRectMake(0,
                                           self.contentView.bounds.size.height - lineH,
                                           self.contentView.bounds.size.width,
                                           lineH);
    
    // 计算 label 的宽度
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    CGFloat nameLabelW = [self.nameLabel.text sizeWithAttributes:attrs].width + 15;
    self.nameLabel.frame = CGRectMake(15,
                                      0,
                                      nameLabelW,
                                      self.contentView.bounds.size.height - lineH);
    
    self.arrowLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame),
                                       0,
                                       20,
                                       self.contentView.bounds.size.height - lineH);
}

#pragma mark setter 方法
- (void)setModel:(FBAreaModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

#pragma mark 设置UI界面
- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.arrowLabel];
    [self.contentView addSubview:self.bottomLineView];
}

#pragma mark 懒加载
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColor.lightGrayColor;
    }
    return _bottomLineView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = UIColor.darkTextColor;
    }
    return _nameLabel;
}

- (UILabel *)arrowLabel {
    if (!_arrowLabel) {
        _arrowLabel = [UILabel new];
        _arrowLabel.text = @"√";
        _arrowLabel.textColor = UIColor.redColor;
        _arrowLabel.hidden = YES;
    }
    return _arrowLabel;
}
@end
