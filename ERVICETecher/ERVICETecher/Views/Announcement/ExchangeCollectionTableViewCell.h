//
//  ExchangeCollectionTableViewCell.h
//  ERVICETecher
//
//  Created by youyou on 16/4/22.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExchangeTableViewCellDelegate<NSObject>
- (void)TapExchangeTableviewCellCollectionViewCellDelegate:(NSIndexPath *)indexPath;
@end
@interface ExchangeCollectionTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *modelArray;
@property (nonatomic,assign) id<ExchangeTableViewCellDelegate>delegate;

@end
