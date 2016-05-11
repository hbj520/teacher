//
//  PersonalModel.m
//  ERVICETecher
//
//  Created by youyou on 16/4/29.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "PersonalModel.h"

@implementation PersonalModel
- (id)initWithParameters:(NSString *)username
                 iconUrl:(NSString *)iconUrl
                     des:(NSString *)des
           backgroundImg:(NSString *)backgroundImg{
    PersonalModel *model = [[PersonalModel alloc] init];
    model.username = username;
    model.iconUrl = iconUrl;
    model.des = des;
    model.backImage = backgroundImg;
    return model;
}
- (id)buidWithData:(NSDictionary *)data{
        NSString *username = data[@"username"];
        NSString *imgIcon = data[@"imgthumb"];
        NSString *des = data[@"description"];
        NSString *backImg = data[@"backgroundimg"];
        PersonalModel *model = [[PersonalModel alloc] initWithParameters:username
                                                                iconUrl:imgIcon
                                                                    des:des
                                                          backgroundImg:backImg];
        
    return model;
}
@end
