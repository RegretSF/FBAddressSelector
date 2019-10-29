//
//  FBAreaModel.h
//  地址选择器
//
//  Created by Mac on 2019/10/25.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBAreaModel : NSObject
@property(nonatomic, strong) NSArray *cityList;
@property(nonatomic, strong) NSArray *areaList;
/// 市
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *code;

/// 字典转模型的对象方法
/// @param dict 字典
- (instancetype)initWithDict:(NSDictionary *)dict;

/// 字典转模型的类方法
/// @param dict 字典
+(instancetype)cityWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
