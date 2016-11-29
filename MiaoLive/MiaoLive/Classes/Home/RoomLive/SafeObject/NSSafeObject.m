//
//  NSSafeObject.m
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "NSSafeObject.h"

@interface NSSafeObject ()
{
    __weak id _object;
    SEL _selctor;
}

@end
@implementation NSSafeObject

- (instancetype)initWithObjct:(id)object {

    if (self = [super init]) {
        _object = object;
        _selctor = nil;
    }
    return self;
}

- (instancetype)initWithObjct:(id)object withSelector:(SEL)selector {

    if (self = [super init]) {
        _object = object;
        _selctor = selector;
    }
    return self;
}

- (void)excute {

    if (_object && _selctor && [_object respondsToSelector:_selctor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelector:_selctor withObject:nil];
#pragma clang diagnostic pop
    }
}

@end
