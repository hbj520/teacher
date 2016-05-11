//
//  FollowGroupModel.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "FollowGroupModel.h"
#import "PinYinForObjc.h"
#import "FollowModel.h"
@implementation FollowGroupModel

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    NSMutableArray *tempArray = [NSMutableArray array];
    FollowGroupModel *group = [[FollowGroupModel alloc] init];
    for (FollowModel *model in dataArray)
    {
        NSString *str = model.nickname;
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:str];
        if ([header isEqualToString:title])
        {
//            FollowModel *followM = [[FollowModel alloc] init];
//            followM.img_Url = @"";
//            followM.nickname = str;
            [tempArray addObject:model];
        }
    }
    group.groupTitle = title;
    group.follows = tempArray;
    return group;
}
@end
