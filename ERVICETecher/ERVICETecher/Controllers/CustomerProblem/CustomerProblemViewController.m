//
//  CustomerProblemViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/26.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "CustomerProblemViewController.h"

@interface CustomerProblemViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation CustomerProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (void)setNavTitle{
    NSString *navTitle = @"客户答疑";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self.tabBarController setSelectedIndex:0];
    }];
}
@end
