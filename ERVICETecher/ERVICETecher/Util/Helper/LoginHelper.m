//
//  LoginHelper.m
//  ERVICE
//
//  Created by youyou on 16/4/8.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "LoginHelper.h"
#import "AppDelegate.h"
#import "Config.h"

@interface LoginHelper ()<UIAlertViewDelegate>

@end
@implementation LoginHelper

//登录超时处理
+ (void)loginTimeoutAction{
    [[Config Instance] logOut];
    ApplicationDelegate.mStorybord = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    ApplicationDelegate.window.rootViewController = [ApplicationDelegate.mStorybord instantiateViewControllerWithIdentifier:@"LoginStorybordId"];

}

@end
