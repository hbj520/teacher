//
//  PersonalUserInfo.m
//  ERVICETecher
//
//  Created by youyou on 16/4/29.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "PersonalUserInfo.h"
#import "SkillModel.h"
@implementation PersonalUserInfo
- (id)initWithParameters:(NSString *)userName
                realName:(NSString *)realName
                 iconUrl:(NSString *)iconUrl
                     sex:(NSString *)sex
                   email:(NSString *)email
                   aaNum:(NSString *)qqNum
                  school:(NSString *)school
          skilledProject:(NSMutableArray *)skilledProject
                    exId:(NSString *)exId
                    mDes:(NSString *)mDes
                mskills:(NSMutableArray *)mskills
{
    PersonalUserInfo *userInfo = [[PersonalUserInfo alloc] init];
    userInfo.userName = userName;
    userInfo.realName = realName;
    userInfo.iconUrl = iconUrl;
    userInfo.sex = sex;
    userInfo.email = email;
    userInfo.qqNum = qqNum;
    userInfo.school = school;
    userInfo.skilledProject = skilledProject;
    userInfo.exId = exId;
    userInfo.mDescription = mDes;
    userInfo.mskills = mskills;
    return userInfo;
}
- (id)buidWithData:(NSDictionary *)dic{
    PersonalUserInfo *personalInfo ;
        NSString *des = dic[@"description"];
        NSString *email = dic[@"email"];
        NSString *exid = dic[@"exid"];
        NSMutableArray *skills = dic[@"goodat"];
        NSString *name = dic[@"admin"];
        NSString *qq = dic[@"qq"];
        NSString *school = dic[@"school"];
        NSString *sex = dic[@"sex"];
        NSArray *projects = dic[@"specialty"];
        NSMutableArray *proArry = [NSMutableArray array
                                   ];
        NSMutableArray *mskills = [NSMutableArray array];
        for (NSDictionary *proDic in projects) {
            NSString *skillID = proDic[@"id"];
            NSString *skillName = proDic[@"splname"];
            SkillModel *model = [[SkillModel alloc] init];
            model.skillId = skillID;
            model.skillName = skillName;
            [proArry addObject:model];
        }
    for (NSDictionary *mskDic in skills) {
        NSString *skillID = mskDic[@"id"];
        NSString *skillName = mskDic[@"splname"];
        SkillModel *model = [[SkillModel alloc] init];
        model.skillId = skillID;
        model.skillName = skillName;
        [mskills addObject:model];
    }
        NSString *username = dic[@"username"];
        NSString *imgthumb = dic[@"imgthumb"];
        personalInfo = [[PersonalUserInfo alloc] initWithParameters:username
                                                           realName:name
                                                            iconUrl:imgthumb
                                                                sex:sex
                                                              email:email
                                                              aaNum:qq
                                                             school:school
                                                     skilledProject:proArry
                                                               exId:exid
                                                               mDes:des
                                                           mskills:mskills];
    return personalInfo;
}
@end
