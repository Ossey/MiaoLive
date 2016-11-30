//
//  XYHotLivelViewSmalCell.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYHotLivelViewSmalCell.h"
#import <UIImageView+WebCache.h>
#import "XYLiveItem.h"

@interface XYHotLivelViewSmalCell ()
@property (weak, nonatomic) IBOutlet UIButton *familyNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *watchNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;

@end
@implementation XYHotLivelViewSmalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


- (void)setLiveItem:(XYLiveItem *)liveItem {
    
    _liveItem = liveItem;
    
    // 昵称
    self.nameLabel.text = liveItem.myname;
    
    // 地理位置
    if (!liveItem.gps.length) {
        liveItem.gps = @"喵星";
    }
    
    // 家族
    [self.familyNameBtn setTitle:liveItem.familyName forState:UIControlStateNormal];
    self.familyNameBtn.hidden = liveItem.familyName.length == 0;
    
    
    // 星级
    self.starImageView.image = liveItem.starImage;
    self.starImageView.hidden = !liveItem.starlevel;
    
    // 大图
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:liveItem.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    
    // 观看直播的用户数量
    NSString *watchNumberStr = [NSString stringWithFormat:@"%ld人", liveItem.allnum];
    self.watchNumberLabel.text = watchNumberStr;
    
}

@end
