 //
//  MyAPI.m
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import "MyAPI.h"
#define BaseUrl @"http://60.173.235.34:9999/svnupdate/app/"
//tools
#import "Config.h"

//models
#import "UserInfoModel.h"
#import "HomepageBannerModel.h"
#import "HomepageExchangeModel.h"
#import "PublishExchangeModel.h"
#import "FollowModel.h"
#import "PersonalModel.h"
#import "PersonalUserInfo.h"
#import "ArticleModel.h"
#import "HuanXinUserInfo.h"


@interface MyAPI()
@property NSString *mBaseUrl;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end
@implementation MyAPI
- (id)init{
    self = [super init];
    if (self) {

        self.manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BaseUrl]] ;
        self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        [self.manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
        [self.manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}
+ (MyAPI *)sharedAPI{
    static MyAPI *sharedAPIInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAPIInstance = [[self alloc] init];
    });
    return sharedAPIInstance;
}
- (void)cancelAllOperation{
    [self.manager.operationQueue cancelAllOperations];
}

#pragma mark - 登录借口
//************登录
- (void)LoginWithNumber:(NSString *)phoneNumber
               password:(NSString *)password
                 result:(StateBlock)result
            errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                @"phone":phoneNumber,
                                @"userpwd":password
                                 };
    [self.manager POST:@"nos_teacher_login"
            parameters:parameters
               success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *state = responseObject[@"status"];
        NSString *information = responseObject[@"info"];
        if ([state isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            UserInfoModel *userinfo = [[UserInfoModel alloc] buildWithDatas:data];
            //保存个人信息至本地
            [[Config Instance] saveUserid:userinfo.uid
                                 userName:userinfo.username
                             userPhoneNum:userinfo.phone
                                    token:userinfo.token
                                     icon:userinfo.iconUrl
             ];
            result(YES,information);
            
        }else{
            result(NO,information);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
//************退出登录
- (void)logOutWithResult:(StateBlock)result
             errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"userexit" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *info = responseObject[@"info"];
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 修改密码
- (void)reSetPasswordWithOldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                              Result:(StateBlock)result
                         errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"oldpassword":oldPassword,
                                 @"newpassword":newPassword
                                 };
    [self.manager POST:@"nos_Modifypassword" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"1"]){
            result(YES,@"修改成功!!");
        }else{
            result(YES,@"修改失败!!");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
}
#pragma mark - 获取首页信息
- (void)getHomepageDataWithResult:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_teacher_index" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *bannerArray = data[@"banner"];
            NSArray *exchangeArray = data[@"exchangeinfo"];
            //首页滚动视图数据赋值
            NSMutableArray *bannerData = [[HomepageBannerModel alloc] buildData:bannerArray];
            //首页交易所数据赋值
            NSMutableArray *exchangeData = [[HomepageExchangeModel alloc] buildWithData:exchangeArray];
            result(YES,@"获取成功",@[bannerData,exchangeData]);
        }else{
            result(NO,@"获取失败",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
}
#pragma mark - 点击信息发布--准备的相关信息
- (void)messagePublishReadyInfo:(ModelBlock)result
                    errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_teacher_Prerelease"
            parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSString *status = responseObject[@"status"];
                if ([status isEqualToString:@"-1"]) {//超时处理
                    result(NO,@"登录超时",nil);
                }
                NSString *info = responseObject[@"info"];
                if ([status isEqualToString:@"1"]) {
                    NSString *exchangeName = responseObject[@"exchange"];
                    NSMutableArray *array = responseObject[@"ex_name"];
                    PublishExchangeModel *pubModel = [[PublishExchangeModel alloc] buidWithData:array andExchangeName:exchangeName];
                    result(YES,info,pubModel);
                }else{
                    result(NO,info,nil);
                }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

//上传图片
- (void)uploadImage:(NSData *)imageData
             result:(StateBlock)result
        errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameter = @{
                                @"token":KToken,
                                @"image":imageData
                                };
    [self.manager POST:@"nos_userimage" parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSString *imageUrl = data[@"imgthumb"];
            result(YES,imageUrl);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
}
#pragma mark - 老师发布文章
- (void)publishArticleWithParameters:(NSString *)title
                             content:(NSString *)content
                            imageUrl:(NSString *)imageUrl
                         articleType:(NSString *)articleType
                              result:(StateBlock)result
                         errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"title":title,
                                 @"content":content,
                                 @"imgthumb":imageUrl,
                                 @"ctgy":articleType
                                 };
    
    [self.manager POST:@"nos_teacher_release" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]) {
            result(YES,@"上传成功");
        }else{
            result(NO,@"上传失败");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 我的客户
- (void)myCustomerListWithPage:(NSString *)page
                        result:(ArrayBlock)result
                   errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"page":page
                                 };
    [self.manager POST:@"nos_teacher_consumer" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray ;
            if (data.count > 0) {
                modelArray = [[FollowModel alloc] buildWithData:data];
            }
            result(YES,@"加载成功",modelArray);
        }else{
            result(NO,@"加载失败",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 个人信息
- (void)personalInfoWithResult:(ModelBlock)result
                   errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_teacher_personal" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            PersonalModel *model = [[PersonalModel alloc] buidWithData:data];
            result(YES,@"下载完成",model);
            
        }else{
            result(NO,@"下载失败",nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
        
    }];
    
}
#pragma mark - 个人资料
- (void)personalDetailInfoWith:(ModelBlock)result
                   errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_teacher_view" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]){
            NSDictionary *data = responseObject[@"data"];
            PersonalUserInfo *model = [[PersonalUserInfo alloc] buidWithData:data];
            result(YES,info,model);
        }else{
            result(NO,info,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 更换头像
- (void)personalIconWithParameters:(NSString *)iconUrl
                            result:(StateBlock)result
                       errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"imgthumb":iconUrl
                                 };
    [self.manager POST:@"nos_teacher_headimg" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 更换老师背景图片
- (void)personalBackGroundImgWithParameters:(NSString *)backgroundUrl
                                     result:(StateBlock)result
                                errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"backgroundimg":backgroundUrl
                                 };
    [self.manager POST:@"nos_teacher_backgoundimg" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
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
                             errorResult:(ErrorBlock)errorResult
                          {
    NSDictionary *paramters = @{
                                @"token":KToken,
                                @"username":username,
                                @"name":realName,
                                @"sex":sex,
                                @"email":email,
                                @"qq":qq,
                                @"school":school,
                                @"goodat":talents,
                                @"description":description
                                };
    [self.manager POST:@"nos_teacher_modi" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]){
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
}
#pragma mark - 我的文章
- (void)articleListWithPage:(NSString *)page
                     Result:(ArrayBlock)result
                  errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"page":page
                                 };
    [self.manager POST:@"nos_teacher_allarticle" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]){
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray = [[ArticleModel alloc] buidWithData:data];
            result(YES,info,modelArray);
            
        }else{
            result(NO,info,nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 修改老师文章
- (void)articleModifyWithParameters:(NSString *)title
                            content:(NSString *)content
                           imageurl:(NSString *)imageUrl
                         categoryId:(NSString *)categoryId
                          articleId:(NSString *)articleId
                             result:(StateBlock )result
                        errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"articleid":articleId,
                                 @"title":title,
                                 @"content":content,
                                 @"imgthumb":imageUrl,
                                 @"ctgyid":categoryId
                                 };
    [self.manager POST:@"nos_teacher_submitmodi" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]){
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 根据userid获取头像和昵称
- (void)userInfoWithUserId:(NSString *)userid
                    result:(ModelBlock)result
               errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"userid":userid
                                 };
    [self.manager POST:@"nos_chatinfo" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            HuanXinUserInfo *model = [[HuanXinUserInfo alloc] buildWithData:data];
            result(YES,info,model);
        }else{
            result(NO,info,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
@end
