//
//  XYHomeADCell.m
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYHotADCell.h"
#import "XYTopADItem.h"

@interface XYHotADCell ()

//@property (nonatomic, strong) NSMutableArray *imageURLs;

@end
@implementation XYHotADCell

//- (NSMutableArray *)imageURLs {
//
//    if (_imageURLs == nil) {
//        _imageURLs = [NSMutableArray array];
//    }
//    return _imageURLs;
//}
- (void)setAdItems:(NSArray *)adItems {

    _adItems = adItems;
    /**
     注意: 这里数组不要使用懒加载，会导致重复添加，崩溃
     */
    NSMutableArray *imageURLs = [NSMutableArray array];
    for (XYTopADItem *item in adItems) {
        [imageURLs addObject:item.imageUrl];
    }
    
    XRCarouselView *view = [[XRCarouselView alloc] init];
    [view setImageArray:imageURLs];
    view.time = 2.0;
    view.delegate = self;
    view.frame = self.bounds;
    [self addSubview:view];
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {

    NSLog(@"%ld", index);
    if (self.imageClickBlock) {
        self.imageClickBlock(self.adItems[index]);
    }
}
@end
