//
//  PersonalUserInfo.h
//  ERVICETecher
//
//  Created by youyou on 16/4/29.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalUserInfo : NSObject
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *iconUrl;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *qqNum;
@property (nonatomic,strong) NSString *school;
@property (nonatomic,strong) NSMutableArray *skilledProject;
@property (nonatomic,strong) NSString *exId;
@property (nonatomic,strong) NSString *mDescription;
@property (nonatomic,strong) NSMutableArray *mskills;

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
                mskills:(NSMutableArray *)mskills;
- (id)buidWithData:(NSDictionary *)dic;

@end
