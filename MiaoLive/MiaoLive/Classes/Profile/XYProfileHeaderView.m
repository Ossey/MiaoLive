//
//  XYProfileHeaderView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/17.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYProfileHeaderView.h"
#import <SDWebImageDownloader.h>

@interface XYProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signaturesLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridxLabel;
@property (weak, nonatomic) IBOutlet UIButton *followNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *showLiveDuration;

@end
@implementation XYProfileHeaderView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.followNumberLabel.layer.shadowRadius = 2;
    self.followNumberLabel.layer.shadowOpacity = 0.5;
    self.followNumberLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.fansNumberLabel.layer.shadowRadius = 2;
    self.fansNumberLabel.layer.shadowOpacity = 0.5;
    self.fansNumberLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.showLiveDuration.layer.shadowRadius = 2;
    self.showLiveDuration.layer.shadowOpacity = 0.5;
    self.showLiveDuration.layer.shadowColor = [UIColor blackColor].CGColor;
    
  
    
    NSURL *bgURL = [NSURL URLWithString:@"http://liveimg.9158.com/default.png"];
    NSString *bgPath = [xyDocumentPath stringByAppendingPathComponent:bgURL.lastPathComponent];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:bgURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (error) return;
        
        if ([data writeToFile:bgPath atomically:YES]) {
            NSLog(@"吸入成功");
        } else {
            NSLog(@"写入失败");
        }
    }];
    NSData *bgImageData = [NSData dataWithContentsOfFile:bgPath];
    UIImage *bgImage = [UIImage imageWithData:bgImageData];
    self.backgroundImageView.image = [UIImage filterWith:bgImage andRadius:20];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundImageView setClipsToBounds:YES];
    self.iconView.image = bgImage;
    
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileDataManagerBtnClick:)]];
    
    self.iconView.layer.cornerRadius = CGRectGetWidth(self.iconView.frame) * 0.5;
    self.iconView.layer.borderWidth = 1.5;
    self.iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.iconView.layer setMasksToBounds:YES];
}


// 跳转到个人资料管理界面
- (IBAction)profileDataManagerBtnClick:(id)sender {
    
    if (self.profileDataManagerCompleteHandle) {
        self.profileDataManagerCompleteHandle();
    }
}

#pragma mark - Private Method
- (void)blurWithImageView:(UIImageView *)imageview {
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        /**  毛玻璃特效类型
         *  UIBlurEffectStyleExtraLight,
         *  UIBlurEffectStyleLight,
         *  UIBlurEffectStyleDark
         */
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        //  毛玻璃视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.effectView = effectView;
        
        //添加到要有毛玻璃特效的控件中
        [self.backgroundImageView addSubview:effectView];
        
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backgroundImageView);
        }];
        //设置模糊透明度
        effectView.alpha = 0.95f;
    }else{
        [self blurWithImageViewForiOS7:nil];
        
    }
    
}

- (void)blurWithImageViewForiOS7:(UIImageView*)imageView{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.contentView.bounds];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.effectView = toolbar;
    [self.backgroundImageView addSubview:toolbar];
    toolbar.alpha = 0.95f;
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}
@end
