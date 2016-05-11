//
//  MyAPI.h
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
// 下载类

#import <Foundation/Foundation.h>
typedef void (^VoidBlock) (void);
typedef void (^StateBlock) (BOOL sucess, NSString *msg);
typedef void (^ModelBlock) (BOOL success, NSString *msg, id object);
typedef void (^ArrayBlock) (BOOL success, NSString *msg, NSMutableArray *arrays);
typedef void (^ErrorBlock) (NSError *enginerError);

@interface MyAPI : NSObject
+ (MyAPI *)sharedAPI;

//取消所有网路全部请求
- (void)cancelAllOperation;

#pragma mark - 登录借口
//************登录
//
- (void)LoginWithNumber:(NSString *)phoneNumber
               password:(NSString *)password
                 result:(StateBlock)result
            errorResult:(ErrorBlock)errorResult;
//************退出登录
- (void)logOutWithResult:(StateBlock)result
             errorResult:(ErrorBlock)errorResult;

#pragma mark - 修改密码
- (void)reSetPasswordWithOldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                              Result:(StateBlock)result
                         errorResult:(ErrorBlock)errorResult;
#pragma mark - 获取首页信息
- (void)getHomepageDataWithResult:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult;

#pragma mark - 点击信息发布--准备的相关信息
- (void)messagePublishReadyInfo:(ModelBlock)result
                    errorResult:(ErrorBlock)errorResult;

#pragma mark - 上传图片
- (void)uploadImage:(NSData *)imageData
             result:(StateBlock)result
        errorResult:(ErrorBlock)errorResult;
#pragma mark - 老师发布文章
- (void)publishArticleWithParameters:(NSString *)title
                             content:(NSString *)content
                            imageUrl:(NSString *)imageUrl
                         articleType:(NSString *)articleType
                              result:(StateBlock)result
                         errorResult:(ErrorBlock)errorResult;
#pragma mark - 我的客户
- (void)myCustomerListWithPage:(NSString *)page
                        result:(ArrayBlock)result
                   errorResult:(ErrorBlock)errorResult;

#pragma mark - 个人信息
- (void)personalInfoWithResult:(ModelBlock)result
                   errorResult:(ErrorBlock)errorResult;

#pragma mark - 个人资料
- (void)personalDetailInfoWith:(ModelBlock)result
                   errorResult:(ErrorBlock)errorResult;
#pragma mark - 更换头像
- (void)personalIconWithParameters:(NSString *)iconUrl
                            result:(StateBlock)result
                       errorResult:(ErrorBlock)errorResult;
#pragma mark - 更换老师背景图片
- (void)personalBackGroundImgWithParameters:(NSString *)backgroundUrl
                                     result:(StateBlock)result
                                errorResult:(ErrorBlock)errorResult;
#pragma mark - 修改资料
- (void)PersonalInfoModifyWithParameters:(NSString *)username
                                realName:(NSString *)realName
                                     sex:(NSString *)sex
                                   email:(NSString *)email
                                      qq:(NSString *)qq
                                  school:(NSString *)school
                                 talents:(NSString *)talents
                                    mDes:(NSString *)description
                                  result:(StateBlock)result
                             errorResult:(ErrorBlock)errorResult;
#pragma mark - 我的文章
- (void)articleListWithPage:(NSString *)page
                     Result:(ArrayBlock)result
                  errorResult:(ErrorBlock)errorResult;
#pragma mark - 修改老师文章
- (void)articleModifyWithParameters:(NSString *)title
                            content:(NSString *)content
                           imageurl:(NSString *)imageUrl
                         categoryId:(NSString *)categoryId
                          articleId:(NSString *)articleId
                             result:(StateBlock )result
                        errorResult:(ErrorBlock)errorResult;
#pragma mark - 根据userid获取头像和昵称
- (void)userInfoWithUserId:(NSString *)userid
                    result:(ModelBlock)result
               errorResult:(ErrorBlock)errorResult;
@end
