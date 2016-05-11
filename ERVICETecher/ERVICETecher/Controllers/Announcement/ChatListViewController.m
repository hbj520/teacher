//
//  ChatListViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/19.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "EMClient.h"
#import "EMClientDelegate.h"

#import "SCUserProfileEntity.h"
#import "HuanXinUserInfo.h"
@interface ChatListViewController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.showRefreshHeader = YES;
    self.navigationItem.hidesBackButton = YES;
    [self tableViewDidTriggerHeaderRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
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
#pragma ChatListDelegate
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel{
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversationModel.title conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}
-(id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    // 头像和昵称
    //从本地获取
  __block  NSString *nickName = [SCUserProfileEntity getNickNameWithUsername:conversation.conversationId];
    if (nickName) {
        model.title = nickName;
    } else {
        //本地拿不到，先在这从服务器获取昵称，再保存到本地，比如下面这个“王”就是从服务器获取了后传进来的
        [[MyAPI sharedAPI] userInfoWithUserId:conversation.conversationId result:^(BOOL success, NSString *msg, id object) {
            if (success) {
                HuanXinUserInfo *userinfo = object;
                [SCUserProfileEntity saveUserProfileWithUsername:conversation.conversationId
                                                     forNickName:userinfo.nickname
                                                   avatarURLPath:userinfo.icon];
                //保存到本地后，从本地获取
                model.title = [SCUserProfileEntity getNickNameWithUsername:conversation.conversationId];
                model.avatarURLPath = [SCUserProfileEntity getavatarURLPathWithUsername:conversation.conversationId];
                    nickName = model.title;
                [self.tableView reloadData];
            }else{
                
            }
            
        } errorResult:^(NSError *enginerError) {
            
        }];
    }
    
    NSString *avatarURLPath = [SCUserProfileEntity getavatarURLPathWithUsername:conversation.conversationId];
    if (avatarURLPath) {
        model.avatarURLPath = avatarURLPath;
    } else {
        [SCUserProfileEntity saveUserProfileWithUsername:conversation.conversationId forNickName:nickName avatarURLPath:@"http://pic.58pic.com/58pic/13/04/04/61M58PICdHP.jpg"];
        model.avatarURLPath = [SCUserProfileEntity getavatarURLPathWithUsername:conversation.conversationId];
    }
    return model;
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refresh
{
    [self refreshAndSortView];
}
@end
