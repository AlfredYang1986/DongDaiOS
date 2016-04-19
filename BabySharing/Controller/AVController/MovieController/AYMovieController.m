//
//  AYMovieController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYDongDaSegDefines.h"
#import "OBShapedButton.h"
#import "AYRemoteCallCommand.h"

#import "ProgressLayer.h"

#define UNITLENGTH ([UIScreen mainScreen].bounds.size.width - 4) / 15
#define MOVIE_MAX_SECONDS       15
#define MOVIE_CALL_BACK_STEP    (1.0 / 12.0)
#define FAKE_NAVIGATION_BAR_HEIGHT 64

@interface AYMovieController ()
@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYMovieController {
    OBShapedButton* take_btn;
    ProgressLayer *progress_using_layer;
    UIButton* delete_current_movie_btn;
    NSTimer* timer;
    CGFloat seconds;
}
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    self.current_seg_index = 2;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width;
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height;
#define PHOTO_TAKEN_BTN_WIDTH                   92
#define PHOTO_TAKEN_BTN_HEIGHT                  PHOTO_TAKEN_BTN_WIDTH
#define PHOTO_TAKEN_BTN_MODIFY_MARGIN           -15
    take_btn = [[OBShapedButton alloc] init];
    [take_btn setBackgroundImage:PNGRESOURCE(@"post_movie_btn") forState:UIControlStateNormal];
    [take_btn setBackgroundImage:PNGRESOURCE(@"post_movie_btn_down") forState:UIControlStateHighlighted];
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectRecordMovieBtn) forControlEvents:UIControlEventTouchDown];
    [take_btn addTarget:self action:@selector(didSelectSaveMovieBtn) forControlEvents:UIControlEventTouchUpInside];
    [take_btn addTarget:self action:@selector(didSelectSaveMovieBtn) forControlEvents:UIControlEventTouchUpOutside];
    take_btn.frame = CGRectMake(0, 0, PHOTO_TAKEN_BTN_WIDTH, PHOTO_TAKEN_BTN_HEIGHT);
    take_btn.center = CGPointMake(width / 2, height + last_height / 2 + PHOTO_TAKEN_BTN_MODIFY_MARGIN);
    
    /**
     * delete btn
     */
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    delete_current_movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, screen_height - 44, width, 44)];
    delete_current_movie_btn.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    [delete_current_movie_btn setTitle:@"删 除" forState:UIControlStateNormal];
    delete_current_movie_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [delete_current_movie_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete_current_movie_btn addTarget:self action:@selector(didSelectDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete_current_movie_btn];
    delete_current_movie_btn.hidden = YES;
    
    /**
     * progress bar for movie
     */
    progress_using_layer = [ProgressLayer layer];
    progress_using_layer.borderColor = [UIColor whiteColor].CGColor;
    progress_using_layer.borderWidth = 4.f;
    progress_using_layer.frame = CGRectMake(0, height, 0, 4);
    [self.view.layer addSublayer:progress_using_layer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: MOVIE_CALL_BACK_STEP //1.0 / 12.0
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]]; // stop
    
    {
        id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
        id<AYCommand> cmd_init = [f.commands objectForKey:@"MovieRecordInit"];
        [cmd_init performWithResult:nil];
        
        UIView* tmp = nil;
        id<AYCommand> cmd_query_view = [f.commands objectForKey:@"MovieRecordView"];
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

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordStartCapture"];
    [cmd performWithResult:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordStopCapture"];
    [cmd performWithResult:nil];
}

- (void)clearController {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordRelease"];
    [cmd performWithResult:nil];
    
    [super clearController];
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
    [view addSubview:f_btn_1];
    f_btn_1.center = CGPointMake(width - FUNCTION_BAR_BTN_MARGIN - FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    [super FakeNavBarLayout:view];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = PNGRESOURCE(@"post_cancel");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnImg:"];
    UIImage* right = PNGRESOURCE(@"dongda_next");
    [cmd_right performWithResult:&right];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    [super SetNevigationBarTitleLayout:view];
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"视频";
    return nil;
}

#define SEG_BTN_MARGIN_BETWEEN          45
#define SEG_HEIGHT                      44
- (id)DongDaSegLayout:(UIView*)view {
    [super DongDaSegLayout:view];
    
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setValue:[NSNumber numberWithInt:2] forKey:kAYSegViewCurrentSelectKey];
    
    [cmd_info performWithResult:&dic_user_info];
    return nil;
}

#pragma mark -- actions
- (void)didChangeCameraBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordChangeCamera"];
    [cmd performWithResult:nil];
}

- (void)didSelectRecordMovieBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordStartRecord"];
    [cmd performWithResult:nil];
}

- (void)didSelectSaveMovieBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordStopRecord"];
    [cmd performWithResult:nil];
}

- (void)didSelectDeleteBtn {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MovieRecord"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieRecordDeleteRecord"];
    [cmd performWithResult:nil];
}

- (void)handleTimer:(NSTimer *)sender {
    
    seconds += MOVIE_CALL_BACK_STEP;
    CGFloat presentage = seconds / MOVIE_MAX_SECONDS > 1.0 ? 1.0 : seconds / MOVIE_MAX_SECONDS;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * presentage;
    progress_using_layer.frame = CGRectMake(progress_using_layer.frame.origin.x, progress_using_layer.frame.origin.y, width, progress_using_layer.frame.size.height);
    
    if (seconds > MOVIE_MAX_SECONDS) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didSelectSaveMovieBtn];
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"视频录制时间达到15秒" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        });
        [timer setFireDate:[NSDate distantFuture]];
    }
}

- (id)DidStartMovieRecording {
    [timer setFireDate:[NSDate distantPast]]; // start
    delete_current_movie_btn.hidden = NO;
    return nil;
}

- (id)DidEndMovieRecording {
    [timer setFireDate:[NSDate distantFuture]];
    [progress_using_layer addPointAtEndWith:seconds];
    return nil;
}

- (id)DidDeleteMovieRecord:(id)obj {
    
    NSInteger count = ((NSNumber*)obj).integerValue;
    
    [progress_using_layer deletePoint];
    seconds = [progress_using_layer getCurrentTime];
    if (count == 0) {
        delete_current_movie_btn.hidden = YES;
    }
    return nil;
}
@end
