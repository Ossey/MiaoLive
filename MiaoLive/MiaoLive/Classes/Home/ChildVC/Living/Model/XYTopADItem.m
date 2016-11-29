//
//  XYTopADItem.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYTopADItem.h"

@implementation XYTopADItem
- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)adItemWithDict:(NSDictionary *)dict {

    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}




@end
