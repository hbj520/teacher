//
//  Config.m
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config *instance = nil;
+ (Config *)Instance{
    @synchronized(self) {
        if (nil == instance) {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
//保存用户userid 用户name 用户phone token
- (void)saveUserid:(NSString *)userid
          userName:(NSString *)username
      userPhoneNum:(NSString *)PhoneNum
             token:(NSString *)token
              icon:(NSString *)icon{
    
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"userid"];
    [settings setObject:userid forKey:@"userid"];
    
    [settings removeObjectForKey:@"username"];
    [settings setObject:username forKey:@"username"];
    
    [settings removeObjectForKey:@"userPhoneNum"];
    [settings setObject:PhoneNum forKey:@"userPhoneNum"];
    
    [settings removeObjectForKey:@"token"];
    [settings setObject:token forKey:@"token"];
    
    [settings removeObjectForKey:@"icon"];
    [settings setObject:icon forKey:@"icon"];
    
    [settings synchronize];
}
- (void)saveIcon:(NSString *)icon{
    NSUserDefaults *setttings = [NSUserDefaults standardUserDefaults];
    [setttings removeObjectForKey:@"icon"];
    [setttings setObject:icon forKey:@"icon"];
    [setttings synchronize];
}
//获取本地保存的用户userid 用户name 用户phone token
- (NSString *)getUserid{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"userid"];
}
//保存密码
- (void)saveUserPassword:(NSString *)password{
    NSUserDefaults *setttings = [NSUserDefaults standardUserDefaults];
    [setttings removeObjectForKey:@"password"];
    [setttings setObject:password forKey:@"password"];
    [setttings synchronize];
}
- (NSString *)getUserName{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"username"];
}
- (NSString *)getUserPhoneNum{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"userPhoneNum"];
}
- (NSString *)getToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"token"];
}
- (NSString *)getUserIcon{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"icon"];
}
- (NSString *)getPassword{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings stringForKey:@"password"];
}
//退出登录
- (void)logOut{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"userid"];
    [settings removeObjectForKey:@"username"];
    [settings removeObjectForKey:@"userPhoneNum"];
    [settings removeObjectForKey:@"token"];

}
@end
