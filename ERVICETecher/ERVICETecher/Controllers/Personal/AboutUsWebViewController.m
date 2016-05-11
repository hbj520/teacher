//
//  AboutUsWebViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/5/6.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "AboutUsWebViewController.h"

@interface AboutUsWebViewController ()
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutUsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    NSString *urlString = [NSString stringWithFormat:@"http://60.173.235.34:9999/svnupdate/app/nos_aboutus"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
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

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
