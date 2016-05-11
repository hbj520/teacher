//
//  ArticleModel.m
//  ERVICETecher
//
//  Created by youyou on 16/5/4.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel
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
    articleFatherCateName:(NSString *)cateName{
    ArticleModel *model = [[ArticleModel alloc] init];
    model.articleId = articelId;
    model.articelBrief = articleBrief;
    model.articleLikes = articleLikes;
    model.articleTitle = artcleTitle;
    model.articleImgUrl = articleImgUrl;
    model.articleReason = articleReason;
    model.articleStatus = articleStatus;
    model.articleContent = articleContent;
    model.articleCreateTime = articleCreateTime;
    model.articleFathercateId = cateId;
    model.articleFathercateName = cateName;
    return model;
}
- (NSMutableArray *)buidWithData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *status = dic[@"status"];
        NSString *content = dic[@"content"];
        NSString *time = dic[@"ctime"];
        NSString *artId = dic[@"id"];
        NSString *reason = dic[@"reason"];
        NSString *title = dic[@"title"];
        NSString *imgurl = dic[@"imgthumb"];
        NSString *likes = dic[@"hits"];
        NSString *breif = dic[@"about"];
        NSString *cateId = dic[@"ctgyid"];
        NSString *cateName = dic[@"ctgy"];
        ArticleModel *model = [[ArticleModel alloc] initWirthParameters:artId
                                                           articleTitle:title
                                                         articlecontent:content
                                                           articleBrief:breif
                                                           articleLikes:likes
                                                          articleImgUrl:imgurl
                                                      articleCreateTime:time
                                                          articleStatus:status
                                                          articleReason:reason
                                                    articleFatherCateId:cateId
                                                  articleFatherCateName:cateName];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
