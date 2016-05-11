//
//  PersonalModel.h
//  ERVICETecher
//
//  Created by youyou on 16/4/29.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalModel : NSObject
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *iconUrl;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,strong) NSString *backImage;
- (id)initWithParameters:(NSString *)username
                 iconUrl:(NSString *)iconUrl
                     des:(NSString *)des
           backgroundImg:(NSString *)backgroundImg;
- (id)buidWithData:(NSDictionary *)data;

@end
