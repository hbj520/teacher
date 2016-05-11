//
//  HomepageBannerModel.h
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//  首页滚动视图

#import <Foundation/Foundation.h>

@interface HomepageBannerModel : NSObject
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *imageUrl;
- (id)initWithLink:(NSString *)link imageurl:(NSString *)imageurl;
- (NSMutableArray *)buildData:(NSArray *)data;
@end
