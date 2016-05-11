//
//  GuideViewController.m
//  Things
//
//  Created by 八度网络 on 15/2/6.
//  Copyright (c) 2015年 Razi. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

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
    //创建UIScrollView
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scrollV];
    
    CGFloat imageW = scrollV.frame.size.width;
    CGFloat imageH = scrollV.frame.size.height;
    
    NSArray *imageNames = @[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg"];
    for (int i=0; i<imageNames.count; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*imageW, 0, imageW, imageH)];
        imageV.image = [UIImage imageNamed:imageNames[i]];
        if (i == imageNames.count-1) {
            [self setStartBtnWithImageView:imageV];
        }
        [scrollV addSubview:imageV];
    }
    scrollV.contentSize = CGSizeMake(imageW * imageNames.count, 0);
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.pagingEnabled = YES;
    scrollV.bounces = NO;
}

//在最后一张图片加一个按钮
- (void)setStartBtnWithImageView:(UIImageView *)imageV
{
    imageV.userInteractionEnabled = YES;
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(0, imageV.frame.size.height * 0.1, imageV.frame.size.width, imageV.frame.size.height );
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:startBtn];
}

- (void)startBtnClick
{
    if (_isPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        AppDelegate *delegate =  [[UIApplication sharedApplication] delegate];
        [delegate changeToMain];
    }

}
@end
