//
//  LoginViewController.m
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "LoginViewController.h"
#import "Tools.h"
#import "Marco.h"

#import "AppDelegate.h"
#import "TTGlobalUICommon.h"
@interface LoginViewController ()<EMClientDelegate>
- (IBAction)exitBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtn:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldIsEditing:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Tools hideKeyBoard];
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
- (void)textfieldIsEditing:(NSNotification *)notification{
    if (self.numberInput.text.length >= 11) {
        [self.loginBtn setImage:[UIImage imageNamed:@"login_ennablebtn"] forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
    }else{
        [self.loginBtn setImage:[UIImage imageNamed:@"login_unablebtn"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
    }
}
- (void)LoginSuccess{
    [Tools chooseRootController];
    //环信登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    EMError *error;
    if (!isAutoLogin) {
        error = [[EMClient sharedClient] loginWithUsername:KUserId password:KUserPassword];
    }
    if (!error) {//登录成功
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }else{
        switch (error.code){
                //                    case EMErrorNotFound:
                //                        TTAlertNoTitle(error.errorDescription);
                //                        break;
            case EMErrorNetworkUnavailable:
                TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                break;
            case EMErrorServerNotReachable:
                TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                break;
            case EMErrorUserAuthenticationFailed:
                TTAlertNoTitle(error.errorDescription);
                break;
            case EMErrorServerTimeout:
                TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                break;
            default:
                TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                break;
        };
    }
    //添加回调监听代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}
- (void)didAutoLoginWithError:(EMError *)aError{
    
    
}
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    
    
}
- (void)didLoginFromOtherDevice{
    
    
}
- (void)didRemovedFromServer{
    
}
- (IBAction)exitBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)loginBtn:(UIButton *)sender {
    [Tools hideKeyBoard];    
    NSString *phoneNum = self.numberInput.text;
    NSString *password = self.passwordInput.text;
    [self showHudInView:self.view hint:@"登录中..."];
    NSString *securityString = [Tools loginPasswordSecurityLock:password];
    
    [[MyAPI sharedAPI] LoginWithNumber:phoneNum
                              password:securityString
                                result:^(BOOL sucess, NSString *msg) {
        if (sucess) {
            [self showHint:@"登录成功！"];
            [[Config Instance] saveUserPassword:securityString];
            [self LoginSuccess];
        }else{
            [self showHint:msg];
        }
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"登录出错"];
        [self hideHud];
    }];
   
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
