//
//  ExchangeCollectionTableViewCell.m
//  ERVICETecher
//
//  Created by youyou on 16/4/22.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "ExchangeCollectionTableViewCell.h"
#import "ExchageCollectionViewCell.h"
static NSString *reusedCellId = @"reusedCellId";
@interface ExchangeCollectionTableViewCell()
{
    UICollectionView *_collectionView;
}
@end
@implementation ExchangeCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContenView];//初始化
    }
    return self;
}
- (void)initContenView{
    //初始化flowlayout
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowlayout.minimumLineSpacing = 10;
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.itemSize = CGSizeMake((ScreenWidth-30)/3, (ScreenWidth-33)/3);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 270) collectionViewLayout:flowlayout];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"ExchageCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:reusedCellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.bounces = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO; //指士条
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self addSubview:_collectionView];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    ExchageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedCellId forIndexPath:indexPath];
    HomepageExchangeModel *model = [self.modelArray objectAtIndex:indexPath.row];
    [cell configWithData:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        [self.delegate TapExchangeTableviewCellCollectionViewCellDelegate:indexPath];
    }
}
@end
