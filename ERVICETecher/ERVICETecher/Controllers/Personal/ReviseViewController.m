//
//  ReviseViewController.m
//  Things
//
//  Created by 八度网络 on 15/2/6.
//  Copyright (c) 2015年 Razi. All rights reserved.
//

#import "ReviseViewController.h"

@interface ReviseViewController ()

@property (weak, nonatomic) IBOutlet UIButton *reviseBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *revisePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

- (IBAction)reviseAction:(id)sender;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation ReviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    NSString *navTitle = @"修改密码";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,[UIColor whiteColor
                                                                                                                                 ],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
    self.reviseBtn.layer.cornerRadius = 5;
    self.reviseBtn.clipsToBounds = YES;
}

- (IBAction)reviseAction:(id)sender {
    
    [Tools hideKeyBoard];
    
    if (self.oldPasswordField.text.length == 0 || self.revisePasswordField.text.length == 0 || self.confirmPasswordField.text.length == 0) {
        [self showHint:@"输入不能为空"];
        return;
    }
    
    if (!(self.revisePasswordField.text.length >= 6 && self.revisePasswordField.text.length <= 20)) {
        [self showHint:@"密码长度不符合要求"];
        return;
    }
    
    if (!(self.confirmPasswordField.text.length >= 6 && self.confirmPasswordField.text.length <= 20)) {
        [self showHint:@"密码长度不符合要求"];
        return;
    }
    
    if ([self.revisePasswordField.text isEqualToString:self.confirmPasswordField.text]) {
//        NSString *userid = [[Config Instance] getUserID];
        [self showHudInView:self.view hint:@"修改中..."];
        NSString *oldSecurityString = [Tools loginPasswordSecurityLock:self.oldPasswordField.text];
        NSString *newSecurityString = [Tools loginPasswordSecurityLock:self.revisePasswordField.text];
        [[MyAPI sharedAPI] reSetPasswordWithOldPassword:oldSecurityString newPassword:newSecurityString Result:^(BOOL sucess, NSString *msg) {
            if (sucess) {
                [[Config Instance] saveUserPassword:newSecurityString];
                [LoginHelper loginTimeoutAction];
                [self showHint:@"修改成功"];
                }else{
                [self showHint:@"修改失败"];
                }
                [self hideHud];
        } errorResult:^(NSError *enginerError) {
            [self showHint:@"修改出错!!"];
        }];

    }else{
        [self showHint:@"两次密码输入不一样"];
         }
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Tools hideKeyBoard];
}

@end
