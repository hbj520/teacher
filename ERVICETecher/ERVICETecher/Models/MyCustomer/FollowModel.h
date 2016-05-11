//
//  FollowModel.h
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   联系人的模型
 */
@interface FollowModel : NSObject

/**
 *  img_Url
 */
@property (nonatomic,copy) NSString *img_Url;

/**
 *  nickname 粉丝姓名
 */
@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *fansId;
@property (nonatomic,copy) NSString *fansEmail;
@property (nonatomic,copy) NSString *fansQQ;
- (id)initWithParameters:(NSString *)imgUrl
                nickName:(NSString *)nickName
                  fansId:(NSString *)fansId
               fansEmail:(NSString *)fansEmail
                  fansQQ:(NSString *)fansQQ;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
