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
//    self.view.backgroundColor = [UIColor colorWithWhite:0.3098 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.current_seg_index = 1;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];
    
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + SCREEN_WIDTH;
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height;
    take_btn = [[OBShapedButton alloc] init];
    [take_btn setBackgroundImage: PNGRESOURCE(@"post_take_btn") forState:UIControlStateNormal];
    [take_btn setBackgroundImage: PNGRESOURCE(@"post_take_btn_down") forState:UIControlStateHighlighted];
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectTakePicBtn) forControlEvents:UIControlEventTouchUpInside];
    
#define PHOTO_TAKEN_BTN_WIDTH                   92
#define PHOTO_TAKEN_BTN_HEIGHT                  PHOTO_TAKEN_BTN_WIDTH
#define PHOTO_TAKEN_BTN_MODIFY_MARGIN           -15
    
    [take_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_bottom).offset(-(last_height / 2 + 22));
        make.width.mas_equalTo(PHOTO_TAKEN_BTN_WIDTH);
        make.height.mas_equalTo(PHOTO_TAKEN_BTN_HEIGHT);
    }];
    
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
//        _filterView.frame = CGRectMake(0, width - height + FAKE_NAVIGATION_BAR_HEIGHT, width, height);
        [self.view addSubview:_filterView];
        
        [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(width - height + FAKE_NAVIGATION_BAR_HEIGHT);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
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
#define FUNCTION_BAR_BTN_WIDTH      30
#define FUNCTION_BAR_BTN_HEIGHT     30
#define FUNCTION_BAR_BTN_MARGIN     8
- (id)FunctionBarLayout:(UIView*)view {
    [super FunctionBarLayout:view];
  
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIButton* f_btn_1 = [[UIButton alloc]init];
    [f_btn_1 setBackgroundImage:PNGRESOURCE(@"post_change_camera") forState:UIControlStateNormal];
    [f_btn_1 addTarget:self action:@selector(didChangeCameraBtn) forControlEvents:UIControlEventTouchDown];
    [view addSubview:f_btn_1];
    [f_btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-FUNCTION_BAR_BTN_MARGIN);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(FUNCTION_BAR_BTN_WIDTH);
        make.height.mas_equalTo(FUNCTION_BAR_BTN_HEIGHT);
    }];
    
    UIButton* f_btn_2 = [[UIButton alloc]init];
    [f_btn_2 setBackgroundImage:PNGRESOURCE(@"post_flash_off") forState:UIControlStateNormal];
    [f_btn_2 addTarget:self action:@selector(didChangeFreshLight) forControlEvents:UIControlEventTouchDown];
    [view addSubview:f_btn_2];
    f_btn_2.tag = -99;
    [f_btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(FUNCTION_BAR_BTN_MARGIN);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(FUNCTION_BAR_BTN_WIDTH - 4);
        make.height.mas_equalTo(FUNCTION_BAR_BTN_HEIGHT - 5);
    }];
    //    isFlash = NO;
    flashMode = AVCaptureFlashModeOff;

    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    {
        id<AYViewBase> bar = (id<AYViewBase>)view;
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = PNGRESOURCE(@"post_cancel");
        [cmd_left performWithResult:&left];
        
        UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [bar_right_btn setTitleColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f] forState:UIControlStateNormal];
        [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
        
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
        [cmd_right performWithResult:&bar_right_btn];
    }
    
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
        UIImage* img = (UIImage*)result;
        img = [self clipImage:img withRect:CGRectMake(0, img.size.height - img.size.width, img.size.width, img.size.width)];
        NSLog(@"save btn success");
        
        AYViewController* des = DEFAULTCONTROLLER(@"PostPhotoPreview");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:img forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    }];
}
- (UIImage*)clipImage:(UIImage*)image withRect:(CGRect)rect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    //    UIGraphicsBeginImageContext(smallBounds.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //    UIGraphicsEndImageContext();
    
    return smallImage;
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
