//
//  AYCameraRollController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYCameraRollController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYAlbumDefines.h"
#import "AYDongDaSegDefines.h"

#define PHOTO_PER_LINE  3
//#define FAKE_NAVIGATION_BAR_HEIGHT  49
#define FAKE_NAVIGATION_BAR_HEIGHT  44
#define FAKE_STATUS_BAR_HEIGHT  20
#define FUNCTION_BAR_HEIGHT 22

@implementation AYCameraRollController {
    UIView* mainContaintView;
    BOOL isMainContentViewShown;
    CALayer* contentLayer;
    NSInteger current_index;
}
#pragma mark -- commands
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

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    isMainContentViewShown = YES;
    current_index = 0;
    
    UIView* nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* drop = [self.views objectForKey:@"DropDownList"];
    [nav addSubview:drop];
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"Album"];
        
        id obj = (id)cmd_pubish;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_pubish;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYAlbumTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
        
//        id<AYCommand> cmd_change = [cmd_pubish.commands objectForKey:@"changeQueryData:"];
//        NSArray* arr = [self enumLocalHomeContent];
//        [cmd_change performWithResult:&arr];
    }
    
    {
        id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
        id<AYCommand> cmd = [f_ph.commands objectForKey:@"EnumAlbumName"];
        NSArray* arr = nil;
        [cmd performWithResult:&arr];
  
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:arr.firstObject forKey:@"fetch"];
        AYRemoteCallCommand* cmd_init_ph_grid = [f_ph.commands objectForKey:@"EnumAllPhotoWithAlbum"];
        [cmd_init_ph_grid performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"Album"];
            id<AYCommand> cmd_change = [cmd_delegate.commands objectForKey:@"changeQueryData:"];
            id arr = (id)result;
            [cmd_change performWithResult:&arr];
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
            [cmd_refresh performWithResult:nil];
        }];
        
        id<AYViewBase> view_drop = [self.views objectForKey:@"DropDownList"];
        id<AYCommand> cmd_drop_date = [view_drop.commands objectForKey:@"setListInfo:"];
        [cmd_drop_date performWithResult:&arr];
    }
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width; //width * aspectRatio;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + img_height;//width * aspectRatio;
    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - 44;
    
    view.frame = CGRectMake(0, height, width, tab_bar_height_offset - height);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)FunctionBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width; //width * aspectRatio;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + img_height;//width * aspectRatio;
    view.frame = CGRectMake(0, height - FUNCTION_BAR_HEIGHT, width, FUNCTION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FAKE_STATUS_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, FAKE_STATUS_BAR_HEIGHT, width, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    {
        id<AYViewBase> bar = (id<AYViewBase>)view;
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = PNGRESOURCE(@"post_cancel");
        [cmd_left performWithResult:&left];
        
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnImg:"];
        UIImage* right = PNGRESOURCE(@"dongda_next");
        [cmd_right performWithResult:&right];
    }
    
    return nil;
}

#define TITLE_LABEL_WIDTH       100
#define TITLE_LABEL_HEIGHT      44
- (id)DropDownListLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT);
    view.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    
    {
        id<AYViewBase> drop = (id<AYViewBase>)view;
        id<AYCommand> cmd = [drop.commands objectForKey:@"setTitle:"];
        NSString* str = @"所有照片";
        [cmd performWithResult:&str];
    }
    
    return nil;
}

#define SEG_BTN_MARGIN_BETWEEN          45
#define SEG_HEIGHT                      49
- (id)DongDaSegLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, screen_height - SEG_HEIGHT, width, SEG_HEIGHT);
   
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_0 setValue:@"相册" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_1 setValue:@"拍照" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];

    NSMutableDictionary* dic_add_item_2 = [[NSMutableDictionary alloc]init];
    [dic_add_item_2 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_2 setValue:@"视频" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_2];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
//    [dic_user_info setValue:[NSNumber numberWithFloat:4.f] forKey:kAYSegViewCornerRadiusKey];
    [dic_user_info setValue:[UIColor colorWithWhite:0.1098 alpha:1.f] forKey:kAYSegViewBackgroundColorKey];
    [dic_user_info setValue:[NSNumber numberWithBool:NO] forKey:kAYSegViewLineHiddenKey];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:SEG_BTN_MARGIN_BETWEEN] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

#pragma mark -- notifications
- (id)leftBtnSelected {
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
    return nil;
}

- (id)rightBtnSelected {
    return nil;
}

- (id)segValueChanged:(id)obj {
    return nil;
}

- (id)showDropDownList:(id)obj {
    UIView* tableview = (UIView*)obj;
    tableview.frame = CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT + FAKE_STATUS_BAR_HEIGHT, tableview.bounds.size.width, tableview.bounds.size.height);
    [self.view addSubview:tableview];
//    [self.view bringSubviewToFront:bar];
    return nil;
}

- (id)queryIsGridSelected:(id)obj {
    NSInteger index = ((NSNumber*)obj).integerValue;
    return [NSNumber numberWithBool:current_index == index];
}

- (id)funcBtnSelected:(id)obj {
#define FUNCTION_BAR_TOP_MARGIN             20
    static const CGFloat kAnimationDuration = 0.3f; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width;//width * aspectRatio;
    CGRect f_bar_start = CGRectMake(0, height - FUNCTION_BAR_HEIGHT, width, FUNCTION_BAR_HEIGHT);
    CGRect f_bar_end = CGRectMake(0, FUNCTION_BAR_TOP_MARGIN, width, FUNCTION_BAR_HEIGHT);
    
    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - SEG_HEIGHT;
    CGRect table_view_start = CGRectMake(0, height, width, tab_bar_height_offset - height);
    CGRect table_view_end = CGRectMake(0, FUNCTION_BAR_HEIGHT + FUNCTION_BAR_TOP_MARGIN, width, tab_bar_height_offset - FUNCTION_BAR_HEIGHT - FUNCTION_BAR_TOP_MARGIN);
    
    UIView* f_bar = [self.views objectForKey:@"FunctionBar"];
    UIView* albumView = [self.views objectForKey:@"Table"];
    UIView* nav = [self.views objectForKey:@"FakeNavBar"];
    
    if (isMainContentViewShown) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            f_bar.frame = f_bar_end;
            albumView.frame = table_view_end;
        } completion:^(BOOL finished) {
            isMainContentViewShown = NO;
            nav.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            f_bar.frame = f_bar_start;
            albumView.frame = table_view_start;
        } completion:^(BOOL finished) {
            isMainContentViewShown = YES;
            nav.hidden = NO;
        }];
    }
    return nil;
}
@end
