//
//  FollowModel.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特  All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel
- (id)initWithParameters:(NSString *)imgUrl
                nickName:(NSString *)nickName
                  fansId:(NSString *)fansId
               fansEmail:(NSString *)fansEmail
                  fansQQ:(NSString *)fansQQ{
    FollowModel *model = [[FollowModel alloc] init];
    model.img_Url = imgUrl;
    model.nickname = nickName;
    model.fansId = fansId;
    model.fansEmail = fansEmail;
    model.fansQQ = fansQQ;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{

    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *username = dic[@"username"];
        NSString *userid = dic[@"id"];
        NSString *email = dic[@"email"];
        NSString *qq = dic[@"qq"];
        NSString *imgthumb = dic[@"imgthumb"];
        FollowModel *model = [[FollowModel alloc] initWithParameters:imgthumb nickName:username fansId:userid fansEmail:email fansQQ:qq];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
