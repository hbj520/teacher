//
//  HomepageBannerModel.m
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "HomepageBannerModel.h"

@implementation HomepageBannerModel
- (id)initWithLink:(NSString *)link imageurl:(NSString *)imageurl{
    HomepageBannerModel *homeModel = [[HomepageBannerModel alloc]init];
    homeModel.link = link;
    homeModel.imageUrl = imageurl;
    return homeModel;
}
- (NSMutableArray *)buildData:(NSArray *)data{
    NSMutableArray *bannerArray = [NSMutableArray array];
    for (NSDictionary *bannerDic in data) {
        NSString *link = bannerDic[@"link"];
        NSString *imageUrl = bannerDic[@"imgthumb"];
        HomepageBannerModel *model = [[HomepageBannerModel alloc] initWithLink:link imageurl:imageUrl];
        [bannerArray addObject:model];
    }
    return bannerArray;
}
@end
