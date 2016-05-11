//
//  PublishTableViewController.m
//  ERVICETecher
//
//  Created by youyou on 16/4/25.
//  Copyright © 2016年 youyou. All rights reserved.
//

#import "PublishTableViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "PublishExchangeModel.h"
#import "ArticleModel.h"
#import "HexColor.h"

@interface PublishTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    PublishExchangeModel *publishModel;
    UIImagePickerController *_picker;
    NSString *imageUrl;//上传成功后返回的url
    NSString *cateTypeId;
}
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *needExchange;
@property (weak, nonatomic) IBOutlet UILabel *needPublishCateLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextfild;
@property (weak, nonatomic) IBOutlet UITextView *publishContentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIView *publishBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
- (IBAction)publishBtn:(UIButton *)sender;

@end

@implementation PublishTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.sectionHeaderHeight = 0;
    //self.tableView.sectionFooterHeight = 0;
    [self setNavtitle];
    [self initPickView];
    [self addRefresh];
    if (_isEdit) {
        [self createUI];
    }
    //隐藏头部sectionview
    self.tableView.contentInset = UIEdgeInsetsMake(-33, 0, 0, 0);
    //下载数据
    [self loadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isPush) {
        self.backBtn.enabled = YES;
        self.backBtn.image = [UIImage imageNamed:@"publish_back"];
        
    }else{
        self.backBtn.enabled = NO;
        self.backBtn.image = [UIImage imageNamed:@"backNoenble"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privateMethod
- (void)addRefresh{
    __weak PublishTableViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself clearData];
        [weakself loadData];
    }];
}
- (void)createUI{
    self.needPublishCateLabel.text = self.model.articleFathercateName;
    cateTypeId = self.model.articleFathercateId;
    self.publishContentTextView.text = self.model.articleContent;
    self.titleTextfild.text = self.model.articleTitle;
    imageUrl = self.model.articleImgUrl;
    [self.addImageView sd_setImageWithURL:[NSURL URLWithString:self.model.articleImgUrl]];
}
- (void)setNavtitle{
    NSString *navTitle;
    if (self.isEdit) {
        navTitle = @"修改信息";
    }else{
        navTitle  = @"发布信息";
    }
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"28282F"]];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
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
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)loadData{
    [[MyAPI sharedAPI] messagePublishReadyInfo:^(BOOL success, NSString *msg, id object) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            publishModel = object;
            self.needExchange.text = publishModel.exchangeName;
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)clearData{
    self.publishContentTextView.text = @"";
    self.needExchange.text = @"点击需要发布的品种";
    self.needPublishCateLabel.text = @"点击需要发布的品种";
    self.titleTextfild.text = @"";
    self.addImageView.image = [UIImage imageNamed:@"announce_image"];
}
#pragma mark-UINavigationControllerDelegate & UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //压缩图片尺寸
    //    UIImage *scaleImage = [image scaleToSize:CGSizeMake(57, 57)];
    //    [self fixOrientation:scaleImage];
    [self showHudInView:self.view hint:@"上传图片..."];
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    [[MyAPI sharedAPI] uploadImage:data result:^(BOOL sucess, NSString *msg) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (sucess) {//上传成功
            self.addImageView.image = image;
            imageUrl = msg;
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

#pragma mark - UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.numberOfButtons-1) {
        [self.titleTextfild resignFirstResponder];
        return;
    }
    //交易所
    if (actionSheet.tag == 100) {
        self.needExchange.text = publishModel.exchangeName;
    }
    //品种
    if (actionSheet.tag == 101) {
        self.needPublishCateLabel.text = [publishModel.exCategoryNameArray objectAtIndex:buttonIndex];
        cateTypeId = [publishModel.exCategoryIds objectAtIndex:buttonIndex];
    }
    //图片选择
    if (actionSheet.tag == 102) {
        if (buttonIndex == 0) {//相机选取
            [self openCamera];
        }else if(buttonIndex == 1){//照片选取
            [self openPhotoAlbum];
        }else{
            return;
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1 || section == 2){
        return 0;
    }else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
//        if (!publishModel) {
//            return;
//        }
        //交易所
        if (indexPath.row == 0) {
            [Tools hideKeyBoard];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            sheet.tag = 100;
            [sheet addButtonWithTitle:publishModel.exchangeName];
            [sheet addButtonWithTitle:@"取消"];
            sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
            [sheet showInView:self.view];
        }
        //品种
        if (indexPath.row == 1) {
            [Tools hideKeyBoard];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            sheet.tag = 101;
            for (NSString *title in publishModel.exCategoryNameArray) {
                [sheet addButtonWithTitle:title];
            }
            [sheet addButtonWithTitle:@"取消"];
            sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
            [sheet showInView:self.view];
        }
    }
    //图片选择
    if (indexPath.section == 2 && indexPath.row == 0) {
        [Tools hideKeyBoard];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册选取", nil];
        sheet.tag = 102;
        [sheet showInView:self.view];
    }
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];

    }

    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
//发布信息
- (IBAction)publishBtn:(UIButton *)sender {
    [Tools hideKeyBoard];
    if (self.titleTextfild.text.length == 0 || [self.needExchange.text isEqualToString:@"点击选择需要的交易所"] || [self.needPublishCateLabel.text isEqualToString:@"点击选择需要发布的品种"] || self.publishContentTextView.text.length == 0) {
        [self showHint:@"请选择交易所，品种，标题和内容"];
        return;
    }
    
    [self showHudInView:self.view hint:@"上传..."];
    if (self.isEdit) {//修改文章
        [[MyAPI sharedAPI] articleModifyWithParameters:self.titleTextfild.text content:self.publishContentTextView.text imageurl:imageUrl categoryId:cateTypeId articleId:self.model.articleId result:^(BOOL sucess, NSString *msg) {
            //登录超时处理
            if ([msg isEqualToString:@"登录超时"]) {
                [self timeOutAction];
            }
            if (sucess) {
                [self clearData];
                [self showHint:@"修改成功!!"];
            }else{
                [self showHint:@"上修改失败!!"];
            }
            [self hideHud];
        } errorResult:^(NSError *enginerError) {
            [self showHint:@"修改出错!!"];
            [self hideHud];
        }];
    }else{//发布文章
        [[MyAPI sharedAPI] publishArticleWithParameters:self.titleTextfild.text
                                                content:self.publishContentTextView.text
                                               imageUrl:imageUrl
                                            articleType:cateTypeId
                                                 result:^(BOOL sucess, NSString *msg) {
                                                     //登录超时处理
                                                     if ([msg isEqualToString:@"登录超时"]) {
                                                         [self timeOutAction];
                                                     }
                                                     if (sucess) {
                                                         [self clearData];
                                                         [self showHint:@"上传成功!!"];
                                                     }else{
                                                         [self showHint:@"上传失败!!"];
                                                     }
                                                     [self hideHud];
                                                     
                                                 } errorResult:^(NSError *enginerError) {
                                                     [self showHint:@"上传出错!!"];
                                                     [self hideHud];
                                                 }];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Tools hideKeyBoard];
}
@end
