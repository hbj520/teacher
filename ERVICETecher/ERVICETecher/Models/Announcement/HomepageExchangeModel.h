//
//  HomepageExchangeModel.h
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageExchangeModel : NSObject
@property (nonatomic,strong) NSString *exchangeId;
@property (nonatomic,strong) NSString *exchangName;
@property (nonatomic,strong) NSString *exchangeTime;
@property (nonatomic,strong) NSString *exchangeInfo;
@property (nonatomic,strong) NSString *exchangeImageurl;
- (id)initWithParameter:(NSString *)exchangeId exchangeName:(NSString *)exchangeName exchangeTime:(NSString *)exchangeTime exchangeInfo:(NSString *)exchangeInfo exchangeImageurl:(NSString *)exchangeImageurl;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
