//
//  NSSafeObject.h
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeObject : NSObject
- (instancetype)initWithObjct:(id)object;
- (instancetype)initWithObjct:(id)object withSelector:(SEL)selector;
@end
