//
//  AYAddFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAddFriendController.h"
#import "AYModelFacade.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYDongDaSegDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYUserDisplayDefines.h"
#import "AYResourceManager.h"
#import "SearchSegImgTextItem.h"

#import "AppDelegate.h"
#import "AYFacade.h"
#import "AYViewBase.h"
#import "AYModel.h"

#import <Contacts/CNContact.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContactFetchRequest.h>

#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
#import "Tools.h"

// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

// qq sdk
#import "TencentOAuth.h"

#import "WXApiObject.h"
#import "WXApi.h"


#define kSCREENW [UIScreen mainScreen].bounds.size.width
#define kSCREENH [UIScreen mainScreen].bounds.size.height

#define SEARCH_BAR_HEIGHT           0 //44
#define SEGAMENT_HEGHT              46

#define SEARCH_BAR_MARGIN_TOP       0
#define SEARCH_BAR_MARGIN_BOT       -2

#define SEGAMENT_MARGIN_BOTTOM      10.5
#define BOTTOM_BAR_HEIGHT           49


typedef NS_ENUM(NSInteger, ShareResouseTyoe) {
    ShareImage,
    ShareNews,
};

@interface AYAddFriendController ()
@property(assign, nonatomic)BOOL noteIndex;
@end

@implementation AYAddFriendController{

    CNContactStore* tmpAddressBook;
    NSArray* people_all;
    NSMutableArray* people;

    NSArray* friend_profile_lst;
    NSArray* friend_lst;
    NSArray* none_friend_lst;
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _noteIndex = NO;
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_view_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"添加好友";
        ((UILabel*)view_title).textColor = [UIColor colorWithRed:74/255 green:74/255 blue:74/255 alpha:1.f];
        [cmd_view_title performWithResult:&title];
    }
    
//    id<AYViewBase> view_friend = [self.views objectForKey:@"Table2"];
//    id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"ContacterList"];
//    
//    id<AYCommand> cmd_datasource = [view_friend.commands objectForKey:@"registerDatasource:"];
//    id<AYCommand> cmd_delegate = [view_friend.commands objectForKey:@"registerDelegate:"];
//    
//    id obj = (id)cmd_relations;
//    [cmd_datasource performWithResult:&obj];
//    obj = (id)cmd_relations;
//    [cmd_delegate performWithResult:&obj];
    
    id<AYViewBase> view_contacter_table = [self.views objectForKey:@"Table2"];
    id<AYCommand> cmd_hot_cell = [view_contacter_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_hot_cell performWithResult:&class_name];
    
    UIView* headView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREENW, 10)];
    headView1.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView1];
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 138, kSCREENW, 5)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line1 = [CALayer layer];
    line1.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line1.borderWidth = 1.f;
    line1.frame = CGRectMake(0, 0, kSCREENW, 1);
    [headView.layer addSublayer:line1];
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 4, kSCREENW, 1);
    [headView.layer addSublayer:line2];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIView* nava = [self.views objectForKey:@"SetNevigationBarTitle"];
    [self.navigationController.navigationBar addSubview:nava];
    
    UIView* left = [self.views objectForKey:@"SetNevigationBarLeftBtn"];
    [self.navigationController.navigationBar addSubview:left];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIView* nava = [self.views objectForKey:@"SetNevigationBarTitle"];
    [nava removeFromSuperview];
    
    UIView* left =[self.views objectForKey:@"SetNevigationBarLeftBtn"];
    [left removeFromSuperview];
}

#pragma mark -- layout commands
- (id)SearchBarLayout:(UIView*)view {
    
    view.frame = CGRectMake( 20, 20,  kSCREENW - 40, 30);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"搜索昵称";
    [cmd_place_hold performWithResult:&place_holder];
    
//    UITextField *searchField = [view valueForKey:@"_searchField"];
//    searchField.textColor = [UIColor colorWithRed:74/255 green:74/255 blue:74/255 alpha:1.f];
//    [searchField setValue:[UIColor colorWithRed:74/255 green:74/255 blue:74/255 alpha:1.f] forKeyPath:@"_placeholderLabel.textColor"];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundTitleSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

#pragma mark -- searh bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"search friends ....");
    
    id<AYCommand> SearchFriend = DEFAULTCONTROLLER(@"SearchFriend");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:SearchFriend forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [self.navigationController pushViewController:ucenter animated:YES];
    [self performWithResult:&dic];

    return NO;
}

- (id)Table2Layout:(UIView*)view {
    
    view.frame = CGRectMake(0, 143, kSCREENW, kSCREENH - 133 - 64 - 10);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 58, kSCREENW, 80);
    {
        id<AYViewBase> seg = (id<AYViewBase>)view;
        id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
        
        id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
        NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
        [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_0 setValue:@"通讯录" forKey:kAYSegViewTitleKey];
        [dic_add_item_0 setValue:PNGRESOURCE(@"friend_address_book") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_0 setValue:PNGRESOURCE(@"friend_address_book_selected") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_0];
        
        NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
        [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_1 setValue:@"微信" forKey:kAYSegViewTitleKey];
        [dic_add_item_1 setValue:PNGRESOURCE(@"friend_wechat") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_1 setValue:PNGRESOURCE(@"friend_wechat") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_1];
        
        NSMutableDictionary* dic_add_item_2 = [[NSMutableDictionary alloc]init];
        [dic_add_item_2 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_2 setValue:@"QQ好友" forKey:kAYSegViewTitleKey];
        [dic_add_item_2 setValue:PNGRESOURCE(@"friend_qq") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_2 setValue:PNGRESOURCE(@"friend_qq") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_2];
        
        NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setValue:[NSNumber numberWithInt:-1] forKey:kAYSegViewCurrentSelectKey];
        [dic_user_info setValue:[NSNumber numberWithFloat:0.0933f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
        
        [cmd_info performWithResult:&dic_user_info];
    }
    
    return nil;
}
- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}
- (id)touchUpInside {
    NSLog(@"search friends btn selected");
    
    return nil;
}

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    NSLog(@"addfriend controller seg cheanged");
    
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    if (index.integerValue == 1) {
        index = [NSNumber numberWithInt:_noteIndex ? 0 : -1];
        NSMutableDictionary *dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setObject:index forKey:kAYSegViewCurrentSelectKey];
        [cmd_info performWithResult:&dic_user_info];
        //*************
        if ([WXApi isWXAppInstalled]) {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"当前手机未安装微信无法分享" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return nil;
        }
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"咚哒";
        message.description = @"我在咚哒，快来加入咚哒吧";
        message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]]);
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = @"https://appsto.re/cn/E_Orbb.i";
        message.mediaObject = webpageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
        //*************
        
    }else if (index.integerValue == 2){
        index = [NSNumber numberWithInt:_noteIndex ? 0 : -1];
        NSMutableDictionary *dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setObject:index forKey:kAYSegViewCurrentSelectKey];
        [cmd_info performWithResult:&dic_user_info];
        //*************
        if (![TencentOAuth iphoneQQInstalled]) {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"当前手机未安装QQ无法分享到QQ空间" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return nil;
        }
        SendMessageToQQReq* req;
        QQApiObject *qqObj;
        
        NSData *previewData = UIImagePNGRepresentation([Tools OriginImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]] scaleToSize:CGSizeMake(100, 100)]);
        qqObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"https://appsto.re/cn/E_Orbb.i"] title:@"咚哒" description:@"快来加入咚哒吧!!!" previewImageData:previewData targetContentType:QQApiURLTargetTypeNews];
        
        req = [SendMessageToQQReq reqWithContent:qqObj];
        if ([QQApiInterface sendReq:req] != EQQAPISENDSUCESS) {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享QQ失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
        //*************
        
    }else if (index.integerValue == 0){
        _noteIndex = YES;
        
        NSMutableDictionary *dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setObject:index forKey:kAYSegViewCurrentSelectKey];
        [cmd_info performWithResult:&dic_user_info];
        
        AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ContatcerInSystem"];
        
        NSDictionary* obj = nil;
        CURRENUSER(obj)
        NSMutableDictionary* dic = [obj mutableCopy];
        
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"ContacterList"];
        id<AYCommand> cmd_get_contacter = [cmd_relations.commands objectForKey:@"getAllPhones"];
        
        NSArray* phones = nil;
        [cmd_get_contacter performWithResult:&phones];
        [dic setValue:phones forKey:@"lst"];
        [dic setValue:@"phone" forKey:@"provider_name"];
        
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"Update user detail remote result: %@", result);
            if (success) {
//                NSArray* reVal = nil;
                NSMutableArray* reVal = (NSMutableArray*)result;
                
                AYModelFacade* f = LOGINMODEL;
                CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
                NSString* phoneNo = tmp.who.phoneNo;
                
                for (int i = 0 ;i < reVal.count; ++i) {
                    for (NSObject* value in [reVal[i] allValues]) {
                        if ([value isKindOfClass:[NSString class]]) {
                            if ( [(NSString*)value isEqualToString:phoneNo]) {
                                [reVal removeObjectAtIndex:i];
                            }
                        }
                    }
                }
                
                id<AYViewBase> view_friend = [self.views objectForKey:@"Table2"];
                id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"ContacterList"];
                
                id<AYCommand> cmd_datasource = [view_friend.commands objectForKey:@"registerDatasource:"];
                id<AYCommand> cmd_delegate = [view_friend.commands objectForKey:@"registerDelegate:"];
                
                id obj = (id)cmd_relations;
                [cmd_datasource performWithResult:&obj];
                obj = (id)cmd_relations;
                [cmd_delegate performWithResult:&obj];
                
//                id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"ContacterList"];
                id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeFriendsData:"];
                [cmd performWithResult:&reVal];
                
                id<AYViewBase> view_contacter = [self.views objectForKey:@"Table2"];
                id<AYCommand> cmd_refresh = [view_contacter.commands objectForKey:@"refresh"];
                [cmd_refresh performWithResult:nil];
            } else {
                NSLog(@"addfriend remote faild");
            }
        }];
    }
    
    NSMutableDictionary *dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setObject:index forKey:kAYSegViewCurrentSelectKey];
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

#pragma mark -- notification pop view controller
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

//michauxs todo://已按照phoneNo从通讯录移除自己
- (id)SamePersonBtnSelected {
    NSLog(@"push to person setting");
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:4];
    [cur setValue:tmp.who.user_id forKey:@"user_id"];
    [cur setValue:tmp.who.auth_token forKey:@"auth_token"];
    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
    [cur setValue:tmp.who.screen_name forKey:@"screen_name"];
    [cur setValue:tmp.who.role_tag forKey:@"role_tag"];
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:cur forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

@end
