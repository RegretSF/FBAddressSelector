//
//  FBAddressListView.m
//  地址选择器
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBAddressListView.h"
#import "FBRegionTableCell.h"
#import "FBAreaModel.h"

@interface FBAddressListView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation FBAddressListView {
    /// 记录当前Cell
    NSInteger _currentIndex;
}
static NSString *const cellId = @"tableViewCellId";

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
    [self.tableView reloadData];
}

#pragma mark 设置UI界面
-(void)setupUI {
    _currentIndex = -1;
    
    // 1.添加 tableView
    [self addSubview:self.tableView];
    
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[FBRegionTableCell class] forCellReuseIdentifier:cellId];
    
    // 2.取消 autoresizing
    for (UIView *subview in self.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewDict = @{@"tableView": self.tableView};
    
    // 遮罩视图
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|"
                               options:0
                               metrics:nil
                               views:viewDict]];
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBRegionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (indexPath.row == _currentIndex) {
        cell.arrowLabel.hidden = NO;
    }else {
        cell.arrowLabel.hidden = YES;
    }
    
    cell.model = self.cityArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex == -1) { _currentIndex = 0; }
    
    // 取出 cell
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    FBRegionTableCell *oldCell = (FBRegionTableCell *)[tableView cellForRowAtIndexPath:oldIndexPath];
    FBRegionTableCell *currentCell = (FBRegionTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // 隐藏&显示 ☑️
    oldCell.arrowLabel.hidden = YES;
    currentCell.arrowLabel.hidden = NO;
    
    // 将model回调出去
    !self.selectedCityBlock?:self.selectedCityBlock(currentCell.model);
    
    // 记录当前 index
    _currentIndex = indexPath.row;
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
    }
    return _tableView;
}
@end
