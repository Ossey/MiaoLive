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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *watchNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
@property (weak, nonatomic) UILabel *familyNameLabel;
@property (weak, nonatomic) UIImageView *family_bgView;
@end
@implementation XYHotLivelViewSmalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *family_bgView = [[UIImageView alloc] init];
    family_bgView.image = [UIImage imageNamed:@"family_bg"];
    [self.contentView addSubview:family_bgView];
    self.family_bgView = family_bgView;
    [family_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(self.contentView).mas_offset(5);
        
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
    
    // 昵称
    self.nameLabel.text = liveItem.myname;
    
    // 地理位置
    if (!liveItem.gps.length) {
        liveItem.gps = @"喵星";
    }
    
    // 家族名称
    self.familyNameLabel.text = liveItem.familyName;
    self.family_bgView.hidden = !liveItem.familyName.length;
    
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
