//
//  XYHomeLiveController.h
//  MiaoLive
//
//  Created by mofeini on 16/11/27.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  所有直播类型的父类(除了最新和关注界面)

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYHomeLiveType){
    XYHomeLiveTypeHot = 1, // 热门  type=1，cacahe=1
    XYHomeLiveTypeSign = 9,    // 签约  type=9，cacahe=1
    XYHomeLiveTypeNetRed = 3,  // 红人  type=3，cacahe=3
    XYHomeLiveTypeOnlineFriends = 20, //关注主播(在线)post参数不够  http://live.9158.com/Fans/GetMyOnlineFriendsList
    XYHomeLiveTypeOverseas = 8,// 海外  type=8，cacahe=3
    XYHomeLiveTypeSameCity = 2,// 同城  type=2, cache=1
    XYHomeLiveTypeOfficial = 10 // 官方  type=10，cacahe=3
    
};

@interface XYHomeLiveController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UIScrollView *titleView;
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
- (XYHomeLiveType)liveType;
@end
