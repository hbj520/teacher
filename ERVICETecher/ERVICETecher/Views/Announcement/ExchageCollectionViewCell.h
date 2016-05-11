//
//  ExchageCollectionViewCell.h
//  ERVICETecher
//
//  Created by youyou on 16/4/22.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomepageExchangeModel;
@interface ExchageCollectionViewCell : UICollectionViewCell
- (void)configWithData:(HomepageExchangeModel *)data;
@end
