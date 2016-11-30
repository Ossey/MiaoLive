//
//  XYHomeLiveFlowLayout.h
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHomeLiveFlowLayout : UICollectionViewFlowLayout

/** item的列数 默认一列, 此属性主要用于控制collectionViewCell的大小 */
@property (nonatomic, assign) NSInteger columnNumber;
@end
