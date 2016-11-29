//
//  XYHotLiveCell.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYHotLiveCell.h"
#import <UIImageView+WebCache.h>
#import "XYLiveItem.h"

@interface XYHotLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UILabel *watchNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;

@end
@implementation XYHotLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLiveItem:(XYLiveItem *)liveItem {

    _liveItem = liveItem;
    
    // 头像
    [self.userProfileView sd_setImageWithURL:[NSURL URLWithString:liveItem.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) return;
        // 设置圆形头像
        image = [UIImage xy_circleImage:image borderColor:[UIColor redColor] borderWidth:1.0f];
        self.userProfileView.image = image;
    }];
    
    // 昵称
    self.nameLabel.text = liveItem.myname;
    
    // 地理位置
    if (!liveItem.gps.length) {
        liveItem.gps = @"喵星";
    }
    self.locationName.text = liveItem.gps;
    
    // 星级
    self.startView.image = liveItem.starImage;
    self.startView.hidden = !liveItem.starlevel;
    
    // 大图
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:liveItem.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    
    // 观看直播的用户数量
    NSString *watchNumberStr = [NSString stringWithFormat:@"%ld人在看", liveItem.allnum];
    NSRange range = [watchNumberStr rangeOfString:[NSString stringWithFormat:@"%ld", liveItem.allnum]];
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:watchNumberStr];
    [attrM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:0.5] range:range];
    [attrM addAttribute:NSForegroundColorAttributeName value:xyKeyColor range:range];
    self.watchNumberLabel.attributedText = attrM;
    
}

@end
