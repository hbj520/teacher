//
//  PersonalTableViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/28.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "UserFollowViewController.h"

#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"

#import "HexColor.h"
#import "AppDelegate.h"

#import "PersonalModel.h"
@interface PersonalTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    PersonalModel *model;
    UIImagePickerController *_picker;
    BOOL _isIcon;//标记是否选择为头像

}
@property (weak, nonatomic) IBOutlet UIImageView *personalIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visulEfectView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation PersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isIcon = NO;
    [self addRefresh];
    [self initPickView];
    [self setNavtitle];
    [self loadData];
    [self createUI];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 8;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//点击进入修改资料
            [self performSegueWithIdentifier:@"teacherUserInfoSegueId" sender:nil];
        }else if (indexPath.row == 1){//点击进入修改我的文章
            [self performSegueWithIdentifier:@"articleSegue" sender:nil];
        }else if (indexPath.row == 2){//点击进入我的客户
            UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MyCustomer" bundle:[NSBundle mainBundle]];
            UserFollowViewController *myCustomerVC = [storybord instantiateViewControllerWithIdentifier:@"myCustomerStoryId"];
            myCustomerVC.isPush = YES;
            [self.navigationController pushViewController:myCustomerVC animated:YES];
        }else if (indexPath.row == 3){//点击关于我们
            [self performSegueWithIdentifier:@"AboutUsSegue" sender:nil];
        }else if (indexPath.row == 4){//点击修改密码
            [self performSegueWithIdentifier:@"ResetpasswordSegue" sender:nil];
        }
    }else if (indexPath.section == 2){//点击退出登录
        [[MyAPI sharedAPI] logOutWithResult:^(BOOL sucess, NSString *msg) {
            //登录超时处理
            if ([msg isEqualToString:@"登录超时"]) {
                [self timeOutAction];
            }
            if (sucess) {
                //退出成功处理
                [self loginOutConfig];
            }
        } errorResult:^(NSError *enginerError) {
            
        }];
    }
}
#pragma mark - PrivateMethod

- (void)addRefresh{
    __weak PersonalTableViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
}
- (void)loginOutConfig{
    [[Config Instance] logOut];
    ApplicationDelegate.mStorybord = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    ApplicationDelegate.window.rootViewController = [ApplicationDelegate.mStorybord instantiateViewControllerWithIdentifier:@"LoginStorybordId"];
}
- (void)initPickView{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
}
- (void)openPhotoAlbum{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}
- (void)openCamera{
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)loadData{
    [[MyAPI sharedAPI] personalInfoWithResult:^(BOOL success, NSString *msg, id object) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            model = object;
            [self createUI];
        }else{
            
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)createUI{
    self.personalIconImageView.layer.masksToBounds = YES;
//    [self.personalIconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    __weak PersonalTableViewController *weakself = self;

    self.personalIconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconAct:)];
    [self.personalIconImageView sd_setImageWithURL:[NSURL URLWithString:model.backImage] placeholderImage:[UIImage imageNamed:@"announce_backgroud"]];

    [self.personalIconImageView addGestureRecognizer:TapIcon];
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            //[weakself blurryImage:image withBlurLevel:0.5];
         UIImage *bgImg =   [image applyLightEffect];
            self.backgroundImageView.image = bgImg;
        }else{
            UIImage *placeholder = [UIImage imageNamed:@"me.jpg"];
           UIImage *bgImg = [placeholder applyLightEffect];
            self.backgroundImageView.image = bgImg;
            // [weakself blurryImage: withBlurLevel:0.5];
        }
    }];
   // [self.backgroundView ]
    self.backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapBackImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackImg:)];
    [self.backgroundView addGestureRecognizer:TapBackImg];
    
    self.nameLabel.text = model.username;
    self.signatureLabel.text  = model.des;
}
- (void)tapBackImg:(UIGestureRecognizer *)ges{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册选取", nil];
    sheet.tag = 100;
    [sheet showInView:self.view];
}
- (void)tapIconAct:(UIGestureRecognizer *)ges{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册选取", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}

- (void)setNavtitle{
    NSString *navTitle = @"个人";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"28282F"]];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
}
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark-UINavigationControllerDelegate & UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //压缩图片尺寸
    //    UIImage *scaleImage = [image scaleToSize:CGSizeMake(57, 57)];
    //    [self fixOrientation:scaleImage];
    [self showHudInView:self.view hint:@"上传图片..."];
    NSData * data = UIImageJPEGRepresentation(image, 0.9);
    [[MyAPI sharedAPI] uploadImage:data result:^(BOOL sucess, NSString *msg) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (sucess) {//上传成功
            if (_isIcon) {//修改头像
                [[MyAPI sharedAPI] personalIconWithParameters:msg result:^(BOOL sucess, NSString *msg) {
                    if (sucess) {
                        self.personalIconImageView.image = image;

                    }else{
                        
                    }
                } errorResult:^(NSError *enginerError) {
                    
                }];
            }else{
                [[MyAPI sharedAPI] personalBackGroundImgWithParameters:msg result:^(BOOL sucess, NSString *msg) {
                    if (sucess) {
                        UIImage *bgImg = [image applyLightEffect];
                        self.backgroundImageView.image = bgImg;
                    }else{
                        
                    }
                } errorResult:^(NSError *enginerError) {
                    
                }];
            }
        }
        [self hideHud];
        
    } errorResult:^(NSError *enginerError) {
        [self hideHud];
        
    }];
    
    
}
- (void)fixOrientation:(UIImage *)aImage {
    if (aImage==nil || !aImage) {
        return;
    }
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orientation=aImage.imageOrientation;
    int orientation_=orientation;
    switch (orientation_) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (orientation_) {
        case UIImageOrientationUpMirrored:{
            
        }
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    aImage=img;
    img=nil;
    
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        _isIcon = NO;
    }else{
        _isIcon = YES;
    }
        if (buttonIndex == 0) {//相机选取
            [self openCamera];
        }else if(buttonIndex == 1){//照片选取
            [self openPhotoAlbum];
        }else{
            return;
        }
}
@end
