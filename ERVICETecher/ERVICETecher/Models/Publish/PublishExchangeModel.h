//
//  PublishExchangeModel.h
//  ERVICETecher
//
//  Created by youyou on 16/4/25.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishExchangeModel : NSObject
@property (nonatomic,strong) NSString *exchangeName;
@property (nonatomic,strong) NSMutableArray *exCategoryNameArray;
@property (nonatomic,strong) NSMutableArray *exCategoryIds;
- (id)initWithExchangeName:(NSString *)exchangeName
       exCategoryNameArray:(NSMutableArray *)array
                 excateIds:(NSMutableArray *)excateIds;
- (id)buidWithData:(NSMutableArray *)data andExchangeName:(NSString *)exchangeName;
@end
