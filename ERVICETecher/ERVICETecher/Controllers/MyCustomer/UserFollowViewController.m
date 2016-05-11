//
//  UserFollowViewController.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特 on 15/10/28.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "UserFollowViewController.h"
#import "UserFollowSearchResultViewController.h"
#import "CustomSearchViewController.h"
#import "UserInfoTableViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "SearchResultHandle.h"
#import "FollowGroupModel.h"
#import "FollowModel.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "FollwTableViewCell.h"
#import "NSMutableArray+FilterElement.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "HexColor.h"

@interface UserFollowViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate,CustomSearchViewControllerDelegate,UserFollowSearchResultViewControllerDelegate,UIAlertViewDelegate>
{
    NSInteger _Page;
}

@property (nonatomic,strong) UITableView *tableView; // 表示图
@property (nonatomic,strong) NSMutableArray *dataArray; // 数据源大数组
@property (nonatomic,strong) CustomSearchViewController *searchController; // 搜索的控制器
@property (nonatomic,strong) NSMutableArray *searchList; // 搜索结果的数组
@property (nonatomic,strong) UserFollowSearchResultViewController *resultViewController;//搜索的结果控制器
@property (nonatomic,strong) NSMutableArray *array; // 数据源数组 分组和每个区的模型
@property (nonatomic,strong) NSMutableArray *sectionIndexs; // 放字母索引的数组
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation UserFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    // 创建搜索的控制器
    [self setupSearchController];
    // 加载数据源
    _Page = 1;
    [self loadDatasWithPage:_Page];
    [self addRefresh];
}
- (void)addRefresh{
    __weak UserFollowViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _Page = 1;
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        [weakself loadDatasWithPage:_Page];
    }];
    MJRefreshAutoNormalFooter *footerRefreh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _Page++;
        NSLog(@"%ld",_Page);
        [weakself loadDatasWithPage:_Page];
    }];
    footerRefreh.automaticallyRefresh = NO;
    self.tableView.mj_footer = footerRefreh;
}
/**
 *  加载数据
 */
- (void)setNavTitle{
    if (self.isPush) {
        [self.backBtn setImage:[UIImage imageNamed:@"publish_back"]];
        self.backBtn.enabled = YES;
    }else{
        [self.backBtn setImage:[UIImage imageNamed:@""]];
        self.backBtn.enabled = NO;
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"28282F"]];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *navTitle = @"我的客户";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
    [self.view addSubview:self.tableView];
}
- (void)loadDatasWithPage:(NSInteger)nowPage
{
    [self showHudInView:self.view hint:@"加载..."];
    NSString *Page = [NSString stringWithFormat:@"%ld",nowPage];

    [[MyAPI sharedAPI] myCustomerListWithPage:Page result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];

        }
        if (success) {
           // [self.dataArray addObjectsFromArray:arrays];
            if (!self.dataSource) {
                self.dataSource = [NSMutableArray array];
            }
            [self.dataSource addObjectsFromArray:arrays];
            [self setupDataArray];
        }
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"下载出错"];
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
   
}
- (void)setupDataArray{
    self.array = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
//    self.dataArray = [NSMutableArray arrayWithObjects:@"2dddddd",@"sss",@"sssss",@"ssss",@"百度",@"腾讯",@"阿里巴巴",@"dzb8818082@163.com",@"@#3",@"大兵布莱恩特",@"德克诺维茨基",@"cocoa",@"ez",@"fireman",nil];
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    for (FollowModel *model in self.dataSource) {
        [self.dataArray addObject:model.nickname];
    }
    self.sectionIndexs = [NSMutableArray array];
    for (NSString *string in self.dataArray) {
        NSString *header = [PinYinForObjc chineseConvertToPinYinHead:string];
        [self.sectionIndexs addObject:header];
    }
    // 去除数组中相同的元素
    self.sectionIndexs = [self.sectionIndexs filterTheSameElement];
    // 数组排序
    [self.sectionIndexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2];
    }];
    // 将排序号的首字母数组取出 分成一个个组模型 和组模型下边的一个个 item
    for (NSString *string in self.sectionIndexs) {
        FollowGroupModel *group = [FollowGroupModel getGroupsWithArray:self.dataSource groupTitle:string];
        if ([group.groupTitle isEqualToString:@"#"]) {
            // 默认 #开头的放在数组的最前边 后边才是 A-Z
            [tempArray insertObject:group atIndex:0];
        }else{
            [tempArray addObject:group];
        }
    }
    self.array = tempArray;
    [self.tableView reloadData];
}
/**
 *  初始化搜索控制器
 */
- (void)setupSearchController
{
    self.resultViewController = [[UserFollowSearchResultViewController alloc] init];
    self.resultViewController.delegate = self;
    _searchController = [[CustomSearchViewController alloc] initWithSearchResultsController:self.resultViewController];
    _searchController.delegate = self;
    _searchController.delegateCustom = self;
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.placeholder = @"请输入搜索的的内容";
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.returnKeyType = UIReturnKeyDone;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - 懒加载一些内容
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.sectionIndexColor = [UIColor lightGrayColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchController.active?1:self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return 0;
    }
    FollowGroupModel *group = self.array[section];
    return group.follows.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FollwTableViewCell";
    FollwTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [FollwTableViewCell viewFromBundle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FollowGroupModel *group = self.array[indexPath.section];
    FollowModel *followM = group.follows[indexPath.row];
    cell.nickNmaeLabel.text = followM.nickname;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:followM.img_Url] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    cell.headImageView.layer.masksToBounds = YES;
    return cell;
}
/**
 *   右侧的索引标题数组
 *
 *   @param tableView 标示图
 *
 *   @return 数组
 */
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.searchController.active?nil:self.sectionIndexs;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FollowGroupModel *group = self.array[indexPath.section];
    FollowModel *followM = group.follows[indexPath.row];
    [self performSegueWithIdentifier:@"CustomerInfo" sender:followM];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FollowGroupModel *group = self.array[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 30)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    //bgView.backgroundColor = [UIColor redColor];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEF_SCREEN_WIDTH-40, 30)];
    label.text = group.groupTitle;
    label.font = FONT_SIZE(15);
    [bgView addSubview:label];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchController.active?0:30;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    // 移除搜索结果数组的数据
    [self.searchList removeAllObjects];
    //过滤数据
    self.searchList= [SearchResultHandle getSearchResultBySearchText:searchString dataArray:self.dataSource];
    if (searchString.length==0&&self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [self.searchList filterTheSameElement];
//    NSMutableArray *dataSource = nil;
//    if ([self.searchList count]>0) {
//        dataSource = [NSMutableArray array];
//        // 结局了数据重复的问题
//        for (NSString *str in self.searchList) {
//            FollowModel *model = [[FollowModel alloc] init];
//            model.nickname = str;
//            model.img_Url = nil;
//            [dataSource addObject:model];
//        }
//    }
    //刷新表格
    self.resultViewController.dataSource = self.searchList;
    [self.resultViewController.tableView reloadData];
    [self.tableView reloadData];
}

#pragma mark - 设置 tableViewcell横线左对齐
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchControllerDissmiss];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchControllerDissmiss];
}
#pragma mark - CustomSearchViewControllerDelegate
/**
 *  搜索控制器的自定义导航条返回按钮
 *
 *  @param searchController 搜索的控制器
 */
- (void)searchControllerBackButtonClick:(UISearchController *)searchController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UserFollowSearchResultViewControllerDelegate
/**
 *  点击了搜索的结果的 cell
 *
 *  @param resultVC  搜索结果的控制器
 *  @param follow    搜索结果信息的模型
 */
- (void)resultViewController:(UserFollowSearchResultViewController *)resultVC didSelectFollowModel:(FollowModel *)follow
{
    [self searchControllerDissmiss];
}
/**
 *  搜索的控制器消失了
 */
- (void)searchControllerDissmiss
{
    self.searchController.searchBar.text = @"";
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - PerformSegueDelegate 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UserInfoTableViewController *userInfoVC = (UserInfoTableViewController *)segue.destinationViewController;
    userInfoVC.userInfo = sender;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
