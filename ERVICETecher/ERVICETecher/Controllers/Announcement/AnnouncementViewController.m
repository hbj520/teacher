//
//  AnnouncementViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/20.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "PublishTableViewController.h"

#import "SDCycleScrollView.h"
#import "BBBadgeBarButtonItem.h"
#import "ChatListViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "ExchangeCollectionTableViewCell.h"
#import "AnnounceTitleTableViewCell.h"

#import "HomepageBannerModel.h"

static NSString *reuseTitleCellId = @"reuseTitleCellId";
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface AnnouncementViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
ExchangeTableViewCellDelegate>
{
    SDCycleScrollView *_headerView;
    NSMutableArray *bannerData;//滚动视图数据
    NSMutableArray *exchangeData;//交易所数据

    BBBadgeBarButtonItem *_chatBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 隐藏底部 TabBar 的上横线
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1
            ) {
            UIImageView *ima = (UIImageView *)view;
            //            ima.backgroundColor = [UIColor redColor];
            ima.hidden = YES;
        }
    }
    
    [self createUI];
    [self loadData];
    //添加刷新
    [self addRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *navTitle = @"V家金服";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = navTitle;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privateMethod
- (void)addRefresh{
    //添加刷新
    __weak AnnouncementViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)congfigTableView{
    
    [self.tableView registerClass:[ExchangeCollectionTableViewCell class] forCellReuseIdentifier:@"reuseCellId"];
}
- (void)loadData{
    [self showHudInView:self.view hint:@"加载..."];
    [[MyAPI sharedAPI] getHomepageDataWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            bannerData = arrays[0];
            exchangeData = arrays[1];
            //头部滚动视图
            [self configPageViews];
            [self congfigTableView];
            [self.tableView reloadData];
            [self hideHud];
        }else{
            [self hideHud];
        }
        [self.tableView.mj_header endRefreshing];
        
    } errorResult:^(NSError *enginerError) {
        
        [self showHint:@"下载出错"];
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)createUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.tableView registerClass:[AnnounceTitleTableViewCell class] forCellReuseIdentifier:reuseTitleCellId];

   
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorline"]];
    headerImageView.frame = CGRectMake(0, 64, ScreenWidth, 2);
    [self.view addSubview:headerImageView];
    [self.view bringSubviewToFront:headerImageView];
    [self addChatBtn];
}
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in bannerData) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
}
- (void)addChatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"announce_chaticon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chatAct:) forControlEvents:UIControlEventTouchUpInside];
    _chatBtn = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
    _chatBtn.badgeFont = [UIFont systemFontOfSize:10.0f];
    _chatBtn.badgeOriginX = 15.5;
    _chatBtn.badgeOriginY = -2.5;
    _chatBtn.badgePadding = 2;
    _chatBtn.badgeValue = @"0";
    
    NSMutableArray *arryBtn = [NSMutableArray arrayWithObjects:_chatBtn, nil];
    self.navigationItem.leftBarButtonItems = arryBtn;
}
- (void)chatAct:(id)sender{
    [self performSegueWithIdentifier:@"chatlistSegue" sender:nil];
}
#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2 || section == 1) {
        return 1;
    }
    return 0;
    ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AnnounceTitleTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AnnounceTitleTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        ExchangeCollectionTableViewCell *cell = [[ExchangeCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCellId"];
        cell.delegate = self;
        cell.modelArray = exchangeData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 10
                                                                  )];
        bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        return bgView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 270;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 45;
    }else if (indexPath.section == 2){
        return 270;
    }
    return 0;
}

#pragma mark - CollectionViewCellDelegate
- (void)TapExchangeTableviewCellCollectionViewCellDelegate:(NSIndexPath *)indexPath{
    //点击进入发布页面
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Publish" bundle:[NSBundle mainBundle]];
    PublishTableViewController *pubTabVC = [storybord instantiateViewControllerWithIdentifier:@"PublishStoryId"];
    pubTabVC.isPush = YES;
    [self.navigationController pushViewController:pubTabVC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}

@end
