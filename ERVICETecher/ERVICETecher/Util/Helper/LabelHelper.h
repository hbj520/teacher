//
//  LabelHelper.h
//  ERVICE
//
//  Created by youyou on 16/4/8.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelHelper : NSObject
//参加活动人数label／报名参加人数
- (UILabel *)buildAttentionLabelWithNumString:(NSString *)numString
                                regularString:(NSString *)regularString;
// 财经分析参加人数label
- (UILabel *)buildApartLabelWithNumString:(NSString *)numString
                            regularString:(NSString *)regularString;
@end
