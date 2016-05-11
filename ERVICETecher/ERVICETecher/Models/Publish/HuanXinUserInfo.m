//
//  HuanXinUserInfo.m
//  ERVICE
//
//  Created by youyou on 16/5/11.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HuanXinUserInfo.h"

@implementation HuanXinUserInfo
- (id)initWithIcon:(NSString *)icon
          nickname:(NSString *)nickname{
    HuanXinUserInfo *userinfo = [[HuanXinUserInfo alloc] init];
    userinfo.icon = icon;
    userinfo.nickname = nickname;
    return userinfo;
}
- (id)buildWithData:(NSDictionary *)data{
    HuanXinUserInfo *model;
        NSString *nickname = data[@"username"];
        NSString *icon = data[@"imgthumb"];
        model = [[HuanXinUserInfo alloc] initWithIcon:icon nickname:nickname];
    return model;
}
@end
