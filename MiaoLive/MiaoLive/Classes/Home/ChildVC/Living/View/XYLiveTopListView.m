//
//  XYLiveTopListView.m
//  ViewDEMO
//
//  Created by mofeini on 16/12/3.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveTopListView.h"
#import "XYLiveItem.h"
#import <UIImageView+WebCache.h>


@interface XYLiveTopListView ()

/** 正在观看直播的用户列表 */
@property (nonatomic, weak) XYWatchUserListView *watchLiveUserListView;
/** 当前直播详情view */
@property (nonatomic, weak) UIView *liveUserDetailsView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) UILabel *watchNumber;
@property (nonatomic, weak) UILabel *liveUserNameLabel;

@property (nonatomic, weak) UIView *giftContentView;
/** 当前主播喵粮控件 */
@property (nonatomic, weak) UIButton *giftButton;
/** 当前主播宝宝数量控件 */
@property (nonatomic, weak) UIButton *bobyButton;
/** 当前喵播号 */
@property (nonatomic, weak) UILabel *useridxLabel;

@end

@implementation XYLiveTopListView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    /*** liveUserDetailsView ****/
    UIView *liveUserDetailsView = [[UIView alloc] init];
    [self addSubview:liveUserDetailsView];
    self.liveUserDetailsView = liveUserDetailsView;
    liveUserDetailsView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    liveUserDetailsView.layer.cornerRadius = 25;
    [self.liveUserDetailsView.layer setMasksToBounds:YES];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [liveUserDetailsView addSubview:iconView];
    self.iconView = iconView;
    self.iconView.layer.cornerRadius = 18;
    [self.iconView.layer setMasksToBounds:YES];
    
    UIButton *followBtn = [[UIButton alloc] init];
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    followBtn.backgroundColor = [UIColor colorWithRed:249/255.0 green:112/255.0 blue:164/255.0 alpha:0.4];
    followBtn.layer.cornerRadius = 18;
    [liveUserDetailsView addSubview:followBtn];
    self.followBtn = followBtn;
    [self.followBtn.layer setMasksToBounds:YES];
    
    UILabel *watchNumber = [[UILabel alloc] init];
    watchNumber.text = @"2898人";
    watchNumber.font = [UIFont systemFontOfSize:12];
    watchNumber.textColor = [UIColor whiteColor];
    [liveUserDetailsView addSubview:watchNumber];
    self.watchNumber = watchNumber;
    
    UILabel *liveUserNameLabel = [[UILabel alloc] init];
    liveUserNameLabel.text = @"ZER88";
    liveUserNameLabel.textColor = [UIColor whiteColor];
    liveUserNameLabel.font = [UIFont systemFontOfSize:12];
    [liveUserDetailsView addSubview:liveUserNameLabel];
    self.liveUserNameLabel = liveUserNameLabel;
    /*** liveUserDetailsView ****/
    
    XYWatchUserListView *watchLiveUserListView = [[XYWatchUserListView alloc] init];
    [self addSubview:watchLiveUserListView];
    self.watchLiveUserListView = watchLiveUserListView;
    watchLiveUserListView.backgroundColor = [UIColor clearColor];
    
    /*** giftContentView ****/
    UIView *giftContentView = [[UIView alloc] init];
    [self addSubview:giftContentView];
    self.giftContentView = giftContentView;
    giftContentView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    giftContentView.layer.cornerRadius = 10;
    [self.giftContentView.layer setMasksToBounds:YES];
    
    UIButton *giftButton = [[UIButton alloc] init];
    [self.giftContentView addSubview:giftButton];
    self.giftButton = giftButton;
    giftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [giftButton setImage:[UIImage imageNamed:@"cat_food_18x12"] forState:UIControlStateNormal];
    [giftButton setTitle:@"喵粮:36117.4万" forState:UIControlStateNormal];
    
    UIButton *bobyButton = [[UIButton alloc] init];
    [self.giftContentView addSubview:bobyButton];
    bobyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [bobyButton setImage:[UIImage imageNamed:@"cat_food_18x12"] forState:UIControlStateNormal];
    [bobyButton setTitle:@"宝宝:19120" forState:UIControlStateNormal];
    self.bobyButton = bobyButton;
    /*** giftContentView ****/
    
    UILabel *useridxLabel = [[UILabel alloc] init];
    useridxLabel.text = @"喵喵号: 6123";
    useridxLabel.font = [UIFont systemFontOfSize:10];
    useridxLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    useridxLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    useridxLabel.layer.shadowOffset = CGSizeMake(3, 3);
    useridxLabel.layer.shadowOpacity = 0.2;
    [self addSubview:useridxLabel];
    self.useridxLabel = useridxLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self makeConstr];
}

- (void)setLiveItem:(XYLiveItem *)liveItem {
    _liveItem = liveItem;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:liveItem.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.liveUserNameLabel.text = liveItem.myname;
    self.watchNumber.text = [NSString stringWithFormat:@"%lu人", liveItem.allnum];
    self.useridxLabel.text = [NSString stringWithFormat:@"喵喵号: %@", liveItem.useridx];
    
}

- (void)makeConstr {
    
    [self.liveUserDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(10);
        make.top.mas_equalTo(self);
    }];
    
    [self.giftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liveUserDetailsView);
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.liveUserDetailsView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.watchLiveUserListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-10);
        make.top.height.mas_equalTo(self.liveUserDetailsView);
        make.left.mas_equalTo(self.liveUserDetailsView.mas_right).mas_offset(10);
    }];
    
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftContentView).mas_offset(10);
        make.top.bottom.mas_equalTo(self.giftContentView);
        
    }];
    
    [self.bobyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.giftButton);
        make.right.mas_equalTo(self.giftContentView).mas_offset(-10);
        make.left.mas_equalTo(self.giftButton.mas_right).mas_offset(10);
    }];
    
    [self.useridxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-10);
        make.centerY.mas_equalTo(self.giftContentView);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liveUserDetailsView).mas_offset(10);
        make.top.mas_equalTo(self.liveUserDetailsView).mas_equalTo(10);
        make.bottom.mas_equalTo(self.liveUserDetailsView).mas_offset(-10);
        make.width.mas_equalTo(self.iconView.mas_height);
    }];
    
    [self.watchNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.iconView);
        
    }];
    
    [self.liveUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.watchNumber);
        make.top.mas_equalTo(self.iconView);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.liveUserDetailsView).mas_offset(-10);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(80);
        make.top.bottom.mas_equalTo(self.iconView);
    }];
}

@end



/**
 XYUserListViewFlowLayout
 */
@implementation XYUserListViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat WH = CGRectGetHeight(self.collectionView.frame);
    self.itemSize = CGSizeMake(WH, WH);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

@end

/**
 XYWatchUserListView
 */
@interface XYWatchUserListView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) XYUserListViewFlowLayout *flowLayout;

@end

@implementation XYWatchUserListView
- (XYUserListViewFlowLayout *)flowLayout {
    
    if(_flowLayout == nil) {
        _flowLayout = [[XYUserListViewFlowLayout alloc] init];
        
    }
    return _flowLayout;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:self.flowLayout]) {
        [self setup];
    }
    return self;
}

static NSString *const WatchUsercellIdentifier = @"XYWatchUserListView";
- (void)setup {
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    [self registerClass:[XYWatchUserListViewCell class] forCellWithReuseIdentifier:WatchUsercellIdentifier];
}

#pragma mark - collectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYWatchUserListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WatchUsercellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}




@end


/**
 XYWatchUserListViewCell
 */
@interface XYWatchUserListViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end
@implementation XYWatchUserListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *imageView =  [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    imageView.backgroundColor = xyRandomColor;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor greenColor].CGColor;
    imageView.layer.cornerRadius = CGRectGetWidth(self.contentView.frame) * 0.5;
}

@end
