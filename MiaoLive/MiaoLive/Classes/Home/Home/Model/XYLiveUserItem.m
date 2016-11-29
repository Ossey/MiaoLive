//
//  XYLiveUserItem.m
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveUserItem.h"

@implementation XYLiveUserItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
    
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)LiveUserItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"new"]) {
        self.New = [key integerValue];
    }
}

- (UIImage *)starImage {
    
    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19", self.starlevel]];
    }
    return nil;
}

@end
