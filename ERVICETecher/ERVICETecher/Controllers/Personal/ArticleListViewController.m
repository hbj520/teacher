//
//  ArticleListViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/5/3.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "ArticleListViewController.h"
#import "PublishTableViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "ActivityContentTableViewCell.h"
static NSString *reuseId = @"ArticelReuserId";
@interface ArticleListViewController ()<UITableViewDelegate,
                                        UITableViewDataSource>
{
    NSMutableArray *dataSource;//数据源
    NSInteger _page;
}
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    [self addRefresh];
    [self configTabelview];
    [self loadDataWithPage:_page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - PrivateMethod
- (void)addRefresh{
    __weak ArticleListViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
        _page = 1;
        [weakself loadDataWithPage:_page];
    }];
    MJRefreshAutoNormalFooter *footerRefreh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        NSLog(@"%ld",_page);
        [weakself loadDataWithPage:_page];
    }];
    footerRefreh.automaticallyRefresh = NO;
    self.tableView.mj_footer = footerRefreh;
}
- (void)configTabelview{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ActivityContentTableViewCell class] forCellReuseIdentifier:reuseId];
    
}
- (void)loadDataWithPage:(NSInteger)nowPage{
    NSString *page = [NSString stringWithFormat:@"%ld",nowPage];
    [self showHudInView:self.view hint:@"加载中..."];
    [[MyAPI sharedAPI] articleListWithPage:page Result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            if (!dataSource) {
                dataSource = [NSMutableArray array];
            }
            [dataSource addObjectsFromArray:arrays];
            [self.tableView reloadData];
        }else{
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"加载出错!!"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
    }];
}
#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityContentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityContentTableViewCell" owner:self options:nil] lastObject];
    ArticleModel *model = [dataSource objectAtIndex:indexPath.row];
    [cell configWithData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleModel *model = [dataSource objectAtIndex:indexPath.row];
    //点击进入发布页面
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Publish" bundle:[NSBundle mainBundle]];
    PublishTableViewController *pubTabVC = [storybord instantiateViewControllerWithIdentifier:@"PublishStoryId"];
    pubTabVC.model = model;
    pubTabVC.isPush = YES;
    pubTabVC.isEdit = YES;
    [self.navigationController pushViewController:pubTabVC animated:YES];
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
