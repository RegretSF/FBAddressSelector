//
//  FBAreaModel.m
//  地址选择器
//
//  Created by Mac on 2019/10/25.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "FBAreaModel.h"

@implementation FBAreaModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cityWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSArray *)cityList {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < _cityList.count; i++) {
        FBAreaModel *model = [FBAreaModel cityWithDict:_cityList[i]];
        [arrayM addObject:model];
    }
    return arrayM;
}

- (NSArray *)areaList {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < _areaList.count; i++) {
        FBAreaModel *model = [FBAreaModel cityWithDict:_areaList[i]];
        [arrayM addObject:model];
    }
    return arrayM;
}
@end
