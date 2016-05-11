//
//  UserInfoTableViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "ChatViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface UserInfoTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UILabel *userSexLabel;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *qqNumTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
- (IBAction)editBtn:(UIBarButtonItem *)sender;
- (IBAction)chatBtn:(UIButton *)sender;

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self createUI];
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
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}
#pragma mark - PrivateMethod

- (void)updateUserinfo{
    [Tools hideKeyBoard];
    [self showHudInView:self.view hint:@"修改..."];
   
}
- (void)enableEdit:(BOOL)isEnable{
    self.userNameTextField.enabled = isEnable;
    self.userSexLabel.enabled = isEnable;
    self.mailTextField.enabled = isEnable;
    self.qqNumTextField.enabled = isEnable;
    self.realNameTextField.enabled = isEnable;
}
- (void)createUI{
    self.navigationItem.title = self.userInfo.nickname;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.img_Url] placeholderImage:[UIImage imageNamed:@"login_icon"]];
    self.iconImageView.layer.masksToBounds = YES;
    self.userNameTextField.text = self.userInfo.nickname;
    self.mailTextField.text = self.userInfo.fansEmail;
    self.qqNumTextField.text = self.userInfo.fansQQ;
    
    
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtn:(UIBarButtonItem *)sender {
}

- (IBAction)chatBtn:(UIButton *)sender {
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.userInfo.fansId conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
