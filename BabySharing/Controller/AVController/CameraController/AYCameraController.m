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
#import "AYRemoteCallCommand.h"

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
    
    self.current_seg_index = 1;
    
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
    [super FunctionBarLayout:view];
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
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
    f_btn_2.tag = -99;
    //    isFlash = NO;
    flashMode = AVCaptureFlashModeOff;

    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    [super FakeNavBarLayout:view];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = PNGRESOURCE(@"post_cancel");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];

    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    [super SetNevigationBarTitleLayout:view];
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"拍照";
    return nil;
}

#pragma mark -- notification
- (id)rightBtnSelected {
    return nil;
}

#pragma mark -- actions
- (void)didSelectTakePicBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"StillImageCaptureTake"];
    [cmd performWithResult:nil andFinishBlack:^(BOOL success, NSDictionary * result) {
//        UIImage* img = (UIImage*)result;
        NSLog(@"save btn success");
    }];
}

- (void)didChangeCameraBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    id<AYCommand> cmd = [f.commands objectForKey:@"StillImageCaptureChangeCamera"];
    [cmd performWithResult:nil];
}

- (void)didChangeFreshLight {
    NSNumber* result = [NSNumber numberWithInt:flashMode];
    id<AYFacadeBase> f = [self.facades objectForKey:@"StillImageCapture"];
    id<AYCommand> cmd = [f.commands objectForKey:@"StillImageCaptureChangeFlash"];
    [cmd performWithResult:&result];
    flashMode = result.intValue;
   
    UIView* func = [self.views objectForKey:@"FunctionBar"];
    UIButton* btn = [func viewWithTag:-99];
    switch (flashMode) {
        case AVCaptureFlashModeOff:
            [btn setBackgroundImage:PNGRESOURCE(@"post_flash_off") forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeOn:
            [btn setBackgroundImage:PNGRESOURCE(@"post_flash_on") forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeAuto:
            [btn setBackgroundImage:PNGRESOURCE(@"post_flash_auto") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
@end
