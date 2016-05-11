//
//  ArticleModel.h
//  ERVICETecher
//
//  Created by youyou on 16/5/4.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject
@property (nonatomic,strong) NSString *articleId;
@property (nonatomic,strong) NSString *articleTitle;
@property (nonatomic,strong) NSString *articleContent;
@property (nonatomic,strong) NSString *articelBrief;
@property (nonatomic,strong) NSString *articleLikes;
@property (nonatomic,strong) NSString *articleImgUrl;
@property (nonatomic,strong) NSString *articleCreateTime;
@property (nonatomic,strong) NSString *articleStatus;
@property (nonatomic,strong) NSString *articleReason;
@property (nonatomic,strong) NSString *articleFathercateId;
@property (nonatomic,strong) NSString *articleFathercateName;
- (id)initWirthParameters:(NSString *)articelId
             articleTitle:(NSString *)artcleTitle
           articlecontent:(NSString *)articleContent
             articleBrief:(NSString *)articleBrief
             articleLikes:(NSString *)articleLikes
            articleImgUrl:(NSString *)articleImgUrl
        articleCreateTime:(NSString *)articleCreateTime
            articleStatus:(NSString *)articleStatus
            articleReason:(NSString *)articleReason
      articleFatherCateId:(NSString *)cateId
    articleFatherCateName:(NSString *)cateName;
- (NSMutableArray *)buidWithData:(NSArray *)data;
@end
