//
//  TeacherUserInfoTableViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/29.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "TeacherUserInfoTableViewController.h"
#import "TalentsViewController.h"

#import "HexColor.h"

#import "PersonalUserInfo.h"
#import "SkillModel.h"
//#import "KGModal.h"
@interface TeacherUserInfoTableViewController ()
{
    BOOL _isEdit;
    PersonalUserInfo *userInfo;
    UITableView *_talentTableView;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *uiserIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *qqNumTextfield;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextfield;
@property (weak, nonatomic) IBOutlet UILabel *talentProjectsLabel;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
- (IBAction)editBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;

@end

@implementation TeacherUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _isEdit = NO;
    [self createTableview];
    [self loadData];
    [self setNavTitle];
    [self createUI];
    [self registerNotice];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2
        ;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 5;
    }else if (section == 3){
        return 1;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isEdit) {
        return;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 3 ) {//性别
            [self choseSex];
        }
    }
    if (indexPath.section == 3) {//擅长项目选择
        [self performSegueWithIdentifier:@"talentListSegue" sender:userInfo.skilledProject];
        
    }
}
#pragma mark - PrivateMethod
- (void)updateUserinfo{
    [self showHudInView:self.view hint:@"提交..."];
    NSMutableString *tablents = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < userInfo.mskills.count; i++) {
        SkillModel *skillModel = [userInfo.mskills objectAtIndex:i];

        if (i >= userInfo.mskills.count-1) {
            [tablents appendFormat:@"%@",skillModel.skillId];
            break;
        }
        [tablents appendFormat:@"%@,",skillModel.skillId];

    }
    
    
    
    
    
    
    [[MyAPI sharedAPI] PersonalInfoModifyWithParameters:self.usernameTextfield.text
                                               realName:self.realNameTextfield.text
                                                    sex:self.sexLabel.text
                                                  email:self.emailTextfield.text
                                                     qq:self.qqNumTextfield.text
                                                 school:self.schoolTextfield.text
                                                talents:tablents
                                                   mDes:self.signatureTextView.text
                                                 result:^(BOOL sucess, NSString *msg) {
                                if (sucess) {
                                    
                                    
                                }else{
                                    
                                }
        
                                                    
    } errorResult:^(NSError *enginerError) {
        
        
    }];
}
- (void)registerNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotice:) name:@"talentsNotice" object:nil];
}
- (void)createTableview{
   _talentTableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 270, 176) style:UITableViewStylePlain];
    _talentTableView.delegate = self;
    _talentTableView.dataSource = self;
    _talentTableView.scrollEnabled = NO;


}
- (void)recieveNotice:(NSNotification *)noti{
    if (userInfo.mskills.count > 0) {
        [userInfo.mskills removeAllObjects];
    }
    userInfo.mskills = noti.userInfo[@"data"];
    [self createUI];
}
- (void)choseSex
{
    [Tools hideKeyBoard];
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    sheet.tag = 888;
    [sheet showInView:self.view];
}
- (void)enableEdit:(BOOL)isEnable{
    self.usernameTextfield.enabled = isEnable;
    self.usernameTextfield.enabled = isEnable;
    self.realNameTextfield.enabled = isEnable;
    self.emailTextfield.enabled = isEnable;
    self.qqNumTextfield.enabled = isEnable;
    self.schoolTextfield.enabled = isEnable;
    self.signatureTextView.editable = isEnable;
}
- (void)createUI{
 
    if (userInfo) {
        self.usernameTextfield.text = userInfo.userName;
        self.realNameTextfield.text = userInfo.realName;
        self.uiserIconImageView.layer.masksToBounds = YES;
        [self.uiserIconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
        self.emailTextfield.text = userInfo.email;
        self.qqNumTextfield.text = userInfo.qqNum;
        self.sexLabel.text = userInfo.sex;
        self.schoolTextfield.text = userInfo.school;
        NSMutableString *tablents = [[NSMutableString alloc]init];
        for (SkillModel *skillModel in userInfo.mskills) {
            [tablents appendFormat:@"%@,",skillModel.skillName];
        }
        self.talentProjectsLabel.text = tablents;
    }
}
- (void)setNavTitle{
    NSString *navTitle = @"个人资料";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"28282F"]];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
}
- (void)loadData{
   // [self showHudInView:self.view hint:@""]
    [[MyAPI sharedAPI] personalDetailInfoWith:^(BOOL success, NSString *msg, id object) {
        if (success) {
            userInfo = object;
            [self createUI];
        }
        
    } errorResult:^(NSError *enginerError) {
        
        
    }];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell;
//
//    if (tableView == _talentTableView) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId" forIndexPath:indexPath];
//    }else{
//        NSString *reuseId = [NSString stringWithFormat:@"%ld",indexPath.section + indexPath.row];
//        cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
//        return nil;
//    }
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TalentsViewController *talentVC = (TalentsViewController *)segue.destinationViewController;
    talentVC.dataSource = sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtn:(UIBarButtonItem *)sender {
    _isEdit = !_isEdit;
    if (_isEdit) {
        [self.editBtn setTitle:@"完成"];
        [self enableEdit:_isEdit];
    }else{
        [self.editBtn setTitle:@"修改"];
        [self enableEdit:_isEdit];
        //提交用户修改信息
        [self updateUserinfo];
    }
}
#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [Tools hideKeyBoard];
    if (buttonIndex == 0) {
        self.sexLabel.text = @"男";
    }else if (buttonIndex == 1){
        self.sexLabel.text = @"女";
        
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"talentsNotice" object:nil];
}
@end
