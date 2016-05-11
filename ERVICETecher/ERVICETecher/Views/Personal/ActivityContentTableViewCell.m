//
//  ActivityContentTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityContentTableViewCell.h"
#import "ArticleModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "LabelHelper.h"
@interface ActivityContentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
//参加人数
@property (weak, nonatomic) IBOutlet UIImageView *isHotImage;

@end
@implementation ActivityContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(ArticleModel *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.articleImgUrl] placeholderImage:[UIImage imageNamed:@"annalyzeimage"]];
    self.titleLabel.text = model.articleTitle;
    self.contentLabel.text = model.articelBrief;
    UILabel *attentionLabel = [[LabelHelper alloc] buildAttentionLabelWithNumString:model.articleLikes regularString:@" 人赞"];
    [attentionLabel setFrame:CGRectMake(135, 58, attentionLabel.frame.size.width, attentionLabel.frame.size.height)];
    [self.contentView addSubview:attentionLabel];
    //是否审核通过
    self.passLabel.layer.borderWidth = 1;
    self.passLabel.layer.cornerRadius = 10;
    if ([model.articleStatus isEqualToString:@"1"]) {//通过
        self.passLabel.layer.borderColor = [UIColor greenColor].CGColor;
        self.passLabel.textColor = [UIColor greenColor];
        self.passLabel.text = @"通过";
    }else{//未通过
        self.passLabel.layer.borderColor = [UIColor redColor].CGColor;
        self.passLabel.textColor = [UIColor redColor];
        self.passLabel.text = @"未通过";
    }
    
}
//- (void)configWithData:(ActivityModel *)model{
//    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"default"]];
//    self.titleLabel.text = model.title;
//    self.contentLabel.text = model.content;
//    UILabel *attentionLabel = [[LabelHelper alloc] buildAttentionLabelWithNumString:model.num regularString:@" 人参加"];
//    [attentionLabel setFrame:CGRectMake(135, 58, attentionLabel.frame.size.width, attentionLabel.frame.size.height)];
//    [self.contentView addSubview:attentionLabel];
//    
//}
@end
