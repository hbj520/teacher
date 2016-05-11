//
//  PublishTableViewController.h
//  ERVICETecher
//
//  Created by youyou on 16/4/25.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleModel;
@interface PublishTableViewController : UITableViewController
@property (nonatomic,assign) BOOL isPush;//从首页进入或者从已发布文章列表
@property (nonatomic,assign) BOOL isEdit;//是否为修改状态
@property (nonatomic,strong) ArticleModel *model;
@end
