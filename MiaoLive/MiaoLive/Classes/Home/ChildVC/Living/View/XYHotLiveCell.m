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
@property (weak, nonatomic) IBOutlet UIImageView *showldentifi;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UILabel *watchNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
//@property (weak, nonatomic) IBOutlet UIButton *familyNameBtn;
@property (weak, nonatomic) UILabel *familyNameLabel;
@property (weak, nonatomic) UIImageView *family_bgView;
@end
@implementation XYHotLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImageView *family_bgView = [[UIImageView alloc] init];
    family_bgView.image = [UIImage imageNamed:@"family_bg"];
    [self.contentView addSubview:family_bgView];
    self.family_bgView = family_bgView;
    [family_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(self.showldentifi).mas_offset(-5);
        
    }];
    UILabel *familyNameLabel = [[UILabel alloc] init];
    familyNameLabel.font = [UIFont systemFontOfSize:12];
    familyNameLabel.textColor = [UIColor purpleColor];
    [family_bgView addSubview:familyNameLabel];
    self.familyNameLabel = familyNameLabel;
    [familyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(family_bgView).mas_offset(10);
        make.right.mas_equalTo(family_bgView).mas_offset(-20); // 设置这个属性是为了防止文字超出了family_bgView显示，不好看
        make.top.mas_equalTo(family_bgView).mas_offset(10);
    }];
}

- (void)setLiveItem:(XYLiveItem *)liveItem {

    _liveItem = liveItem;
    
    // 家族名称
    self.familyNameLabel.text = liveItem.familyName;
    self.family_bgView.hidden = !liveItem.familyName.length;
    
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
