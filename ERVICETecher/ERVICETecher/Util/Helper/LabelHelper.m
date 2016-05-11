//
//  LabelHelper.m
//  ERVICE
//
//  Created by youyou on 16/4/8.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "LabelHelper.h"
//#import "Marco.h"
@implementation LabelHelper
//关注人数自定义label
- (UILabel *)buildAttentionLabelWithNumString:(NSString *)numString regularString:(NSString *)regularString {
    NSInteger length = numString.length;
    NSString *contentString = [numString stringByAppendingString:regularString];
    NSInteger contenLenth = contentString.length;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(255, 80, 0, 1.0) range:NSMakeRange(0, length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(length+1, contenLenth-length-1)];
   return  [self buildAttributeLabel:attributeString];
}
// 财经分析参加人数label
- (UILabel *)buildApartLabelWithNumString:(NSString *)numString
                            regularString:(NSString *)regularString{
    NSInteger length = numString.length;
    NSString *contentString = [numString stringByAppendingString:regularString];
    NSInteger contenLenth = contentString.length;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(24, 189, 117, 1.0) range:NSMakeRange(0, length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(length+1, contenLenth-length-1)];
    return  [self buildAttributeLabel:attributeString];
}
- (UILabel *)buildAttributeLabel:(NSMutableAttributedString *)str{
    CGSize size = [Tools stringToAttributeSize:str];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setFont:[UIFont fontWithName:@"Arial" size:13]];
    label.attributedText = str;
    return label;
}
@end
