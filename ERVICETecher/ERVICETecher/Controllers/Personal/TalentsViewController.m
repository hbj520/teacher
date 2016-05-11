//
//  TalentsViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/5/3.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "TalentsViewController.h"
#import "SkillModel.h"
@interface TalentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *talentData;
}
- (IBAction)backBtn:(UIBarButtonItem *)sender;
- (IBAction)confirmBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TalentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    talentData = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseId"];
    // Do any additional setup after loading the view.
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"reuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    SkillModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.skillName;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SkillModel *model = [self.dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [talentData removeObject:model];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [talentData addObject:model];
    }
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtn:(UIBarButtonItem *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"talentsNotice" object:nil userInfo:@{@"data":talentData}];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
