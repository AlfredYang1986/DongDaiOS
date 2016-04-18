//
//  AYCameraController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYCameraController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYDongDaSegDefines.h"
#import "OBShapedButton.h"

#import <AVFoundation/AVFoundation.h>

#define FAKE_NAVIGATION_BAR_HEIGHT 64

@interface AYCameraController ()
@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYCameraController {
    AVCaptureFlashMode flashMode;
    OBShapedButton* take_btn;
}

@synthesize filterView = _filterView;

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
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width;
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height;
    take_btn = [[OBShapedButton alloc] init];
    [take_btn setBackgroundImage: PNGRESOURCE(@"post_take_btn") forState:UIControlStateNormal];
    [take_btn setBackgroundImage: PNGRESOURCE(@"post_take_btn_down") forState:UIControlStateHighlighted];
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectTakePicBtn) forControlEvents:UIControlEventTouchUpInside];
    
#define PHOTO_TAKEN_BTN_WIDTH                   92
#define PHOTO_TAKEN_BTN_HEIGHT                  PHOTO_TAKEN_BTN_WIDTH
#define PHOTO_TAKEN_BTN_MODIFY_MARGIN           -15
    
    take_btn.frame = CGRectMake(0, 0, PHOTO_TAKEN_BTN_WIDTH, PHOTO_TAKEN_BTN_HEIGHT);
    take_btn.center = CGPointMake(width / 2, height + last_height / 2 + PHOTO_TAKEN_BTN_MODIFY_MARGIN);
    
    {
        id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
        id<AYCommand> cmd_init = [f.commands objectForKey:@"StillImageCaptureInit"];
        [cmd_init performWithResult:nil];
        
        UIView* tmp = nil;
        id<AYCommand> cmd_query_view = [f.commands objectForKey:@"StillImageCaptureView"];
        [cmd_query_view performWithResult:&tmp];
        _filterView = tmp;
        
        float width = self.view.frame.size.width;
        CGFloat aspectRatio = 4.0 / 3.0;
        float height = self.view.frame.size.width * aspectRatio;
        _filterView.frame = CGRectMake(0, width - height + FAKE_NAVIGATION_BAR_HEIGHT, width, height);
        [self.view addSubview:_filterView];
        [self.view sendSubviewToBack:_filterView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    id<AYCommand> cmd = [f.commands objectForKey:@"StillImageCaptureStart"];
    [cmd performWithResult:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    id<AYCommand> cmd = [f.commands objectForKey:@"StillImageCaptureStop"];
    [cmd performWithResult:nil];
}

- (void)clearController {
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    id<AYCommand> cmd = [f.commands objectForKey:@"StillImageCaptureStop"];
    [cmd performWithResult:nil];

    [super clearController];
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- layout
#define FUNCTION_BAR_HEIGHT         44
#define FUNCTION_BAR_BTN_WIDTH      25
#define FUNCTION_BAR_BTN_HEIGHT     25
#define FUNCTION_BAR_BTN_MARGIN     8
- (id)FunctionBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width;
    view.frame = CGRectMake(0, height - FUNCTION_BAR_HEIGHT, width, FUNCTION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    {
        UIButton* f_btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_WIDTH + 5, FUNCTION_BAR_BTN_HEIGHT + 5)];
        [f_btn_1 setBackgroundImage:PNGRESOURCE(@"post_change_camera") forState:UIControlStateNormal];
        [f_btn_1 addTarget:self action:@selector(didChangeCameraBtn) forControlEvents:UIControlEventTouchDown];
        f_btn_1.center = CGPointMake(width - FUNCTION_BAR_BTN_MARGIN - FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);
        [view addSubview:f_btn_1];
        
        UIButton* f_btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_WIDTH, FUNCTION_BAR_BTN_HEIGHT)];
        [f_btn_2 setBackgroundImage:PNGRESOURCE(@"post_flash_off") forState:UIControlStateNormal];
        [f_btn_2 addTarget:self action:@selector(didChangeFreshLight) forControlEvents:UIControlEventTouchDown];
        f_btn_2.center = CGPointMake(FUNCTION_BAR_BTN_MARGIN + FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);
        [view addSubview:f_btn_2];
        //    isFlash = NO;
        flashMode = AVCaptureFlashModeOff;
    }
    
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:1.f];
    
    {
        id<AYViewBase> bar = (id<AYViewBase>)view;
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = PNGRESOURCE(@"post_cancel");
        [cmd_left performWithResult:&left];
        
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
        id right = [NSNumber numberWithBool:YES];
        [cmd_right performWithResult:&right];
    }
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"拍照";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    return nil;
}

#define SEG_BTN_MARGIN_BETWEEN          45
#define SEG_HEIGHT                      44
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
    [dic_user_info setValue:[NSNumber numberWithInt:1] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:SEG_BTN_MARGIN_BETWEEN] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    id<AYCommand> cmd = REVERSMODULE;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    return nil;
}

- (id)segValueChanged:(id)obj {
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    if (index.integerValue != 1) {
        id<AYCommand> cmd = REVERSMODULE;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:index forKey:kAYControllerChangeArgsKey];
        [cmd performWithResult:&dic];
    }
    
    return nil;
}

#pragma mark -- actions
- (void)didSelectTakePicBtn {
    
}

- (void)didChangeCameraBtn {
    
}

- (void)didChangeFreshLight {
    
}
@end
