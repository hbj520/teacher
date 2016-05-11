//
//  ExchageCollectionViewCell.m
//  ERVICETecher
//
//  Created by youyou on 16/4/22.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "ExchageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "HomepageExchangeModel.h"
@interface ExchageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageview;
@property (weak, nonatomic) IBOutlet UIImageView *exchageImageView;

@end
@implementation ExchageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configWithData:(HomepageExchangeModel *)data{
    //毛玻璃
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.alpha = 0.9;
    CGRect farme = CGRectMake(0, 0, (ScreenWidth-30)/3, (ScreenWidth-33)/3);
    [visualEffectView setFrame:farme];
    [self.backgroundImageview addSubview:visualEffectView];
    [Tools imageCompressForSize:self.backgroundImageview.image targetSize:CGSizeMake((ScreenWidth-30)/3, (ScreenWidth-33)/3)];
    [self.exchageImageView sd_setImageWithURL:[NSURL URLWithString:data.exchangeImageurl] placeholderImage:[UIImage imageNamed:@"login_header"]];
    [self.contentView bringSubviewToFront:self.exchageImageView];
    
}
@end
