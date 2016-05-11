//
//  PublishExchangeModel.m
//  ERVICETecher
//
//  Created by youyou on 16/4/25.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "PublishExchangeModel.h"

@implementation PublishExchangeModel
- (id)initWithExchangeName:(NSString *)exchangeName
       exCategoryNameArray:(NSMutableArray *)array
                 excateIds:(NSMutableArray *)excateIds{
    PublishExchangeModel *publishModel = [[PublishExchangeModel alloc] init];
    publishModel.exchangeName = exchangeName;
    publishModel.exCategoryNameArray = array;
    publishModel.exCategoryIds = excateIds;
    return publishModel;
}
- (id)buidWithData:(NSMutableArray *)data andExchangeName:(NSString *)exchangeNam{
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *idArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *name = dic[@"ex_class"];
        NSString *cateId = dic[@"ex_classid"];
        [nameArray addObject:name];
        [idArray addObject:cateId];
    }
    PublishExchangeModel *pubModel = [[PublishExchangeModel alloc] initWithExchangeName:exchangeNam
                                                                    exCategoryNameArray:nameArray
                                                                              excateIds:idArray];

    return pubModel;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
