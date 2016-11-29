//
//  XYLiveItem.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveItem.h"

@implementation XYLiveItem

- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
            
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)LiveItemWithDict:(NSDictionary *)dict {

    return [[self alloc] initWithDict:dict];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (UIImage *)starImage {

    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19", self.starlevel]];
    }
    return nil;
}


@end
