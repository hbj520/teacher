//
//  HomeTabbarViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/19.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "HomeTabbarViewController.h"
#import "HexColor.h"
#import "UIImage+Compress.h"
@interface HomeTabbarViewController ()
{
    NSArray *titlesArrays;
    NSMutableArray *menusVCs;//tabbars的控制器们
}
@property (nonatomic,strong) UIStoryboard *annoucementSB;
@property (nonatomic,strong) UIStoryboard *customerProblemSB;
@property (nonatomic,strong) UIStoryboard *mycustomerSB;
@property (nonatomic,strong) UIStoryboard *personalSB;
@property (nonatomic,strong) UIStoryboard *publishSB;
@end

@implementation HomeTabbarViewController
- (UIStoryboard *)annoucementSB{
    if (!_annoucementSB) {
        _annoucementSB = [UIStoryboard storyboardWithName:@"Announcement" bundle:[NSBundle mainBundle]];
    }
    return _annoucementSB;
}
- (UIStoryboard *)customerProblemSB{
    if (!_customerProblemSB) {
        _customerProblemSB = [UIStoryboard storyboardWithName:@"CustomerProblem" bundle:[NSBundle mainBundle]];
    }
    return _customerProblemSB;
}
- (UIStoryboard *)mycustomerSB{
    if (!_mycustomerSB) {
        _mycustomerSB = [UIStoryboard storyboardWithName:@"MyCustomer" bundle:[NSBundle mainBundle]];
    }
    return _mycustomerSB;
}
- (UIStoryboard *)personalSB{
    if (!_personalSB) {
        _personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:[NSBundle mainBundle]];
    }
    return _personalSB;
}
- (UIStoryboard *)publishSB{
    if (!_publishSB) {
        _publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:[NSBundle mainBundle]];
    }
    return _publishSB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarbackground"];
    self.tabBar.tintColor = [UIColor whiteColor];
    
    UIImage *selectImage = [UIImage imageNamed:@"tabbar_selectImage"];
    selectImage = [selectImage scaleToSize:CGSizeMake(ScreenWidth/5, 75)];
    self.tabBar.selectionIndicatorImage = selectImage;
    menusVCs = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeTabbars" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *array = dict[@"tabBarMenus"];
    for (NSDictionary *dic in array) {
        //tabbar 自定义设置
        UITabBarItem *tabbarItem = [[UITabBarItem alloc] init];
        [tabbarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                             NSForegroundColorAttributeName : [UIColor whiteColor]
                                             } forState:UIControlStateNormal];
        UIImage *tabImage = [UIImage imageNamed:dic[@"image"]];
        [tabbarItem setImage:tabImage];
        tabbarItem.image = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabbarItem setSelectedImage:[UIImage imageNamed:dic[@"select_image"]]];
        [tabbarItem setTitle:dic[@"title"]];
        SEL selector = NSSelectorFromString(dic[@"storybordId"]);
        IMP imp = [self methodForSelector:selector];
        UIStoryboard * (*func)(id,SEL) = (void *)imp;
        UIStoryboard *sb = func(self,selector);
        UIViewController *vc = [sb instantiateInitialViewController];
        vc.tabBarItem = tabbarItem;
        [menusVCs addObject:vc];
        
    }

    
    [self registerNotification];
    self.viewControllers = menusVCs;

}
- (void)registerNotification{
    //[Ea]
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

@end
