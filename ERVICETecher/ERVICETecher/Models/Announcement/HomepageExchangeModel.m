//
//  HomepageExchangeModel.m
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "HomepageExchangeModel.h"

@implementation HomepageExchangeModel
- (id)initWithParameter:(NSString *)exchangeId exchangeName:(NSString *)exchangeName exchangeTime:(NSString *)exchangeTime exchangeInfo:(NSString *)exchangeInfo exchangeImageurl:(NSString *)exchangeImageurl{
    HomepageExchangeModel *model = [[HomepageExchangeModel alloc] init];
    model.exchangeId = exchangeId;
    model.exchangeImageurl = exchangeImageurl;
    model.exchangeInfo = exchangeInfo;
    model.exchangName = exchangeName;
    model.exchangeTime = exchangeTime;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *exchangeArray = [NSMutableArray array];
    for (NSDictionary *exchangeDic in data) {
        NSString *exchangeId = exchangeDic[@"id"];
        NSString *exName = exchangeDic[@"ex_name"];
        NSString *exTime = exchangeDic[@"addtime"];
        NSString *exInfo = exchangeDic[@"exc_information"];
        NSString *exImageurl = exchangeDic[@"excimg"];
        HomepageExchangeModel *model = [[HomepageExchangeModel alloc] initWithParameter:exchangeId exchangeName:exName exchangeTime:exTime exchangeInfo:exInfo exchangeImageurl:exImageurl];
        [exchangeArray addObject:model];
    }
    return exchangeArray;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
