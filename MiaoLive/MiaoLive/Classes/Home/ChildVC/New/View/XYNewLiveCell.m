//
//  XYNewLiveCell.m
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYNewLiveCell.h"
#import "XYLiveUserItem.h"
#import <UIImageView+WebCache.h>

@interface XYNewLiveCell ()

/** 定位 */
@property (nonatomic, weak) UIButton *positionBtn;
/** 星级 */
@property (nonatomic, weak) UIImageView *starlevelView;
/** 主播名 */
@property (nonatomic, weak) UILabel *nicknameLabel;
/** 显示最新图标，如果服务器返回1就显示new */
@property (nonatomic, weak) UIImageView *newview;
/** 用户头像 */
@property (nonatomic, weak) UIImageView *photoView;


@end

@implementation XYNewLiveCell

- (void)setUserItem:(XYLiveUserItem *)userItem {
    _userItem = userItem;
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:userItem.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.positionBtn setTitle:userItem.position forState:UIControlStateNormal];
    
    self.starlevelView.hidden = userItem.starlevel == 0;
    NSLog(@"%ld", userItem.starlevel);
    self.starlevelView.image = userItem.starImage;
    
    self.nicknameLabel.text = userItem.nickname;
    if (userItem.New == 1) {
        self.newview.image = [UIImage imageNamed:@"flag_new_33x17_"];
        self.newview.hidden = NO;
    } else {
        self.newview.image = nil;
        self.newview.hidden = YES;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *photoView = [[UIImageView alloc] init];
    [photoView setUserInteractionEnabled:YES];
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [positionBtn setImage:[UIImage imageNamed:@"location_white_8x9_"] forState:UIControlStateNormal];
    [positionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [positionBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.photoView addSubview:positionBtn];
    self.positionBtn = positionBtn;
    
    UIImageView *newView = [[UIImageView alloc] init];
//    newView.image = [UIImage imageNamed:@"flag_new_33x17_"];
    [self.photoView addSubview:newView];
    self.newview = newView;
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
//    nicknameLabel.text = @"sey";
    [nicknameLabel setFont:[UIFont systemFontOfSize:11]];
    nicknameLabel.textColor = [UIColor whiteColor];
    [self.photoView addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;
    
    UIImageView *starlevelView = [[UIImageView alloc] init];
//    starlevelView.image = [UIImage imageNamed:@"girl_star1_40x19"];
    [self.photoView addSubview:starlevelView];
    self.starlevelView = starlevelView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 5;
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.newview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-padding);
        make.top.mas_equalTo(self.contentView).mas_offset(padding);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(17);
    }];
    [self.positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(padding);
        make.centerY.mas_equalTo(self.newview);
        
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.starlevelView);
        make.left.mas_equalTo(self.contentView).mas_offset(padding);
    }];
    [self.starlevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.nicknameLabel.mas_right).mas_offset(padding);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-padding);
    }];
   
}
@end
