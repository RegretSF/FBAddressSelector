//
//  ViewController.m
//  地址选择器
//
//  Created by Mac on 2019/10/25.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ViewController.h"
#import "FBAreaModel.h"
#import "FBAddressSelectorView.h"

@interface ViewController ()
@property(nonatomic, strong) FBAddressSelectorView *addressSelectorView;
@property(nonatomic, strong) NSMutableArray *cityArr;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadAddressData];
}

#pragma mark 监听方法
- (void)clickButton {
    [self.addressSelectorView show];
}

#pragma mark setupUI
- (void)setupUI {
    self.title = @"添加收货地址";
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    [self.view addSubview:button];
    
    self.addressSelectorView.frame = self.view.bounds;
    [self.view addSubview:self.addressSelectorView];
    
    self.addressSelectorView.addressBlock = ^(NSString * _Nonnull provinceName, NSString * _Nonnull cityName, NSString * _Nonnull regionName) {
        NSLog(@"%@%@%@", provinceName, cityName, regionName);
    };
}

#pragma mark 加载地址数据
- (void)loadAddressData {
    // 1.获取沙盒路径
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [docDir stringByAppendingPathComponent:@"cityList.plist"];
    
    // 2.加载 data
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    // 3.判断沙盒中是否存在 cityList.plist 文件，存在则不需要从网络上获取，否则，发送请求。
    if (data == nil) {
        // 4.从网络上加载'全国地址大全信息'
        NSString *jsonPath = [NSBundle.mainBundle pathForResource:@"cityList.json" ofType:nil];
        data = [NSData dataWithContentsOfFile:jsonPath];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        // 获取沙盒路径
        NSString *docDir1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath = [docDir1 stringByAppendingPathComponent:@"cityList.plist"];
        
        // 5.将'全国地址大全信息'存到沙盒中。
        [array writeToFile:plistPath atomically:YES];
    }
    
    // 6.字典转模型
    // 反序列化成数组
    NSArray *cityArr = [NSArray arrayWithContentsOfFile:filePath];
    // 字典数组转模型数组
    for (int i = 0; i < cityArr.count; i++) {
        FBAreaModel *model = [FBAreaModel cityWithDict:cityArr[i]];
        [self.cityArr addObject:model];
    }
    
    self.addressSelectorView.cityArr = self.cityArr;
}

#pragma mark 懒加载
- (FBAddressSelectorView *)addressSelectorView {
    if (!_addressSelectorView) {
        _addressSelectorView = [[FBAddressSelectorView alloc] init];
    }
    return _addressSelectorView;
}

- (NSMutableArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}
@end
