//
//  HuanXinUserInfo.h
//  ERVICE
//
//  Created by youyou on 16/5/11.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuanXinUserInfo : NSObject
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *nickname;
- (id)initWithIcon:(NSString *)icon
          nickname:(NSString *)nickname;
- (id)buildWithData:(NSDictionary *)data;
@end
