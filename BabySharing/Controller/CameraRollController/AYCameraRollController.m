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
#define FAKE_NAVIGATION_BAR_HEIGHT  64
#define FUNCTION_BAR_HEIGHT 22

@implementation AYCameraRollController {
    UIView* mainContentView;
    BOOL isMainContentViewShown;
    CALayer* contentLayer;
    NSInteger current_index;
    
    CGPoint point;
    CGFloat last_scale;
    UIImage *img;
    NSURL* cur_movie_url;
    
    NSDictionary* fetch;
    NSArray* albums;
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
   
    
    CGFloat img_height = SCREEN_WIDTH;

    isMainContentViewShown = YES;
    current_index = 0;
    contentLayer = [CALayer layer];
    
    mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, img_height)];
    mainContentView.backgroundColor = [UIColor clearColor];
    mainContentView.userInteractionEnabled = YES;
    mainContentView.clipsToBounds = YES;
    [self.view addSubview:mainContentView];
    [mainContentView.layer addSublayer:contentLayer];
                        
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [mainContentView addGestureRecognizer:pan];
                            
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [mainContentView addGestureRecognizer:pinch];
    
    [self.view sendSubviewToBack:mainContentView];
    
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
    }
    
    {
        id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
        id<AYCommand> cmd = [f_ph.commands objectForKey:@"EnumAlbumName"];
        NSArray* arr = nil;
        [cmd performWithResult:&arr];
        albums = arr;
  
        [self changeGridPhotoContentWithAlbumIndex:0];
        
        id<AYViewBase> view_drop = [self.views objectForKey:@"DropDownList"];
        id<AYCommand> cmd_drop_date = [view_drop.commands objectForKey:@"setListInfo:"];
        [cmd_drop_date performWithResult:&arr];
    }
}

- (void)changeGridPhotoContentWithAlbumIndex:(NSInteger)index {
    id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[albums objectAtIndex:index] forKey:@"fetch"];
    AYRemoteCallCommand* cmd_init_ph_grid = [f_ph.commands objectForKey:@"EnumAllPhotoWithAlbum"];
    [cmd_init_ph_grid performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"Album"];
        id<AYCommand> cmd_change = [cmd_delegate.commands objectForKey:@"changeQueryData:"];
        id arr = (id)result;
        fetch = result;
        [cmd_change performWithResult:&arr];
        
        [self performSelector:@selector(setInitPhoto)];
        [self changeDropDownListTitleWithAlbumIndex:index];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
    }];
}

- (void)changeDropDownListTitleWithAlbumIndex:(NSInteger)index {
   
    id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
    id<AYCommand> cmd_name = [f_ph.commands objectForKey:@"QueryAlbumNameWithAlbum"];
    id args = [albums objectAtIndex:index];
    [cmd_name performWithResult:&args];
    NSString* title = args;
    
    id<AYViewBase> drop = [self.views objectForKey:@"DropDownList"];
    id<AYCommand> cmd = [drop.commands objectForKey:@"setTitle:"];
    NSString* str = title;
    [cmd performWithResult:&str];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setInitPhoto {
    id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[[fetch objectForKey:@"assets"] objectAtIndex:current_index] forKey:@"asset"];
    AYRemoteCallCommand* cmd_real_photo = [f_ph.commands objectForKey:@"QueryRealPhoto"];
    [cmd_real_photo performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        img = (UIImage*)result;
        last_scale = MAX(mainContentView.frame.size.width /  img.size.width, contentLayer.frame.size.height / img.size.height);
        contentLayer.frame = CGRectMake(0, 0, img.size.width * last_scale, img.size.height * last_scale);
        contentLayer.contents = (id)img.CGImage;
    }];
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
   
    CALayer* round_bottom = [CALayer layer];
    round_bottom.frame = CGRectMake(0, 0, 24, 20);
    round_bottom.contents = (id)PNGRESOURCE(@"post_three_line").CGImage;
    round_bottom.position = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    [view.layer addSublayer:round_bottom];
    
    return nil;
}

- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FUNCTION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    {
        id<AYViewBase> bar = (id<AYViewBase>)view;
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = PNGRESOURCE(@"post_cancel");
        [cmd_left performWithResult:&left];
     
#define RIGHT_BTN_WIDTH             25
#define RIGHT_BTN_HEIGHT            RIGHT_BTN_WIDTH
#define RIGHT_BTN_RIGHT_MARGIN      10.5
        UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, RIGHT_BTN_WIDTH, RIGHT_BTN_HEIGHT)];
        [bar_right_btn setTitleColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f] forState:UIControlStateNormal];
        [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(width - RIGHT_BTN_RIGHT_MARGIN - bar_right_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
        
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
        [cmd_right performWithResult:&bar_right_btn];
    }
    
    return nil;
}

#define TITLE_LABEL_WIDTH       100
#define TITLE_LABEL_HEIGHT      44
- (id)DropDownListLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT);
    view.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
   
//    [self changeDropDownListTitleWithAlbumIndex:0];
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
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:SEG_BTN_MARGIN_BETWEEN] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

#pragma mark -- notifications
- (id)leftBtnSelected {
    id<AYCommand> cmd = REVERSMODULE;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd performWithResult:&dic];
    return nil;
}

//michauxs todo
- (id)rightBtnSelected {
    
    CGFloat width = mainContentView.frame.size.width;
    CGFloat height = mainContentView.frame.size.height;
    
    CGFloat scale_x = img.size.width / contentLayer.frame.size.width;
    CGFloat scale_y = img.size.height / contentLayer.frame.size.height;
    
    CGFloat top_margin = 0;
    CGFloat offset_x = fabs(contentLayer.frame.origin.x);
    CGFloat offset_y = fabs(contentLayer.frame.origin.y - top_margin);
    
    img = [self clipImage:img withRect:CGRectMake(offset_x * scale_x, offset_y * scale_y, width * scale_x, height * scale_y)];
    
    AYViewController* des = DEFAULTCONTROLLER(@"PostPhotoPreview");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:img forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
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

- (id)segValueChanged:(id)obj {
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    if (index.integerValue != 0) {
        id<AYCommand> cmd = REVERSMODULE;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:index forKey:kAYControllerChangeArgsKey];
        [cmd performWithResult:&dic];
    }

    return nil;
}

- (id)showDropDownList:(id)obj {
    UIView* tableview = (UIView*)obj;
    tableview.frame = CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, tableview.bounds.size.width, tableview.bounds.size.height);
    [self.view addSubview:tableview];
//    [self.view bringSubviewToFront:bar];
    return nil;
}

- (id)itemDidSelected:(id)obj {
    NSLog(@"drop down lst select item %@", obj);
    NSNumber* index = (NSNumber*)obj;
    [self changeGridPhotoContentWithAlbumIndex:index.integerValue];
    return nil;
}

- (id)queryIsGridSelected:(id)obj {
    NSInteger index = ((NSNumber*)obj).integerValue;
    return [NSNumber numberWithBool:current_index == index];
}

- (id)selectedValueChanged:(id)obj {
    
    UITableView* view_table = [self.views objectForKey:@"Table"];
   
    NSNumber* old = [NSNumber numberWithInteger:current_index];
    NSNumber* new_current = [NSNumber numberWithInteger:((NSNumber*)obj).integerValue];
    
    if (current_index != new_current.integerValue) {
        
        NSInteger old_row = current_index / 3;
        NSIndexPath* old_index = [NSIndexPath indexPathForRow:old_row inSection:0];
        id<AYViewBase> old_view = [view_table cellForRowAtIndexPath:old_index];
        id<AYCommand> old_cmd = [old_view.commands objectForKey:@"unSelectAtIndex:"];
        [old_cmd performWithResult:&old];
        
        current_index = ((NSNumber*)obj).integerValue;

        NSInteger new_row = current_index / 3;
        NSIndexPath* new_index = [NSIndexPath indexPathForRow:new_row inSection:0];
        id<AYViewBase> new_view = [view_table cellForRowAtIndexPath:new_index];
        id<AYCommand> new_cmd = [new_view.commands objectForKey:@"unSelectAtIndex:"];
        [new_cmd performWithResult:&new_current];
       
        [view_table reloadRowsAtIndexPaths:@[old_index, new_index] withRowAnimation:UITableViewRowAnimationNone];
     
        id<AYFacadeBase> f_ph = [self.facades objectForKey:@"PHAsset"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[[fetch objectForKey:@"assets"] objectAtIndex:current_index] forKey:@"asset"];
        AYRemoteCallCommand* cmd_real_photo = [f_ph.commands objectForKey:@"QueryRealPhoto"];
        [cmd_real_photo performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            img = (UIImage*)result;
            last_scale = MAX(mainContentView.frame.size.width /  img.size.width, contentLayer.frame.size.height / img.size.height);
            contentLayer.frame = CGRectMake(0, 0, img.size.width * last_scale, img.size.height * last_scale);
            contentLayer.contents = (id)img.CGImage;
        }];
    }
    
    if (!isMainContentViewShown) {
        [self funcBtnSelected:nil];
    }
    
    return nil;
    
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

- (id)scrollForMoreSize {
    static const CGFloat kAnimationDuration = 0.3f; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect f_bar_end = CGRectMake(0, FUNCTION_BAR_TOP_MARGIN, width, FUNCTION_BAR_HEIGHT);
    
    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - SEG_HEIGHT;
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
    }
    return nil;
}

#pragma mark -- handle gesture
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:self.view];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHer];
        CGFloat move_y = [self distanceMoveVer];
//        [self moveView:move_x and:move_y];
        [CATransaction begin];
        contentLayer.position = CGPointMake(move_x + contentLayer.position.x, move_y + contentLayer.position.y);
        [CATransaction commit];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changed");
        CGPoint newPoint = [gesture translationInView:mainContentView];
        
        contentLayer.position = CGPointMake(contentLayer.position.x + (newPoint.x - point.x), contentLayer.position.y + (newPoint.y - point.y));
        point = newPoint;
    }
}

- (CGFloat)distanceMoveVer {
    CGFloat top_margin = 0;
    if (contentLayer.frame.origin.y > top_margin)
        return -contentLayer.frame.origin.y + top_margin;
    else if (contentLayer.frame.origin.y + contentLayer.frame.size.height < mainContentView.frame.size.height)
        return mainContentView.frame.size.height - (contentLayer.frame.origin.y + contentLayer.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHer {
    
    if (contentLayer.frame.origin.x > 0)
        return -contentLayer.frame.origin.x;
    else if (contentLayer.frame.origin.x + contentLayer.frame.size.width < mainContentView.frame.size.width)
        return mainContentView.frame.size.width - (contentLayer.frame.origin.x + contentLayer.frame.size.width);
    else return 0;
}

#pragma mark -- scale the pic
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    NSLog(@"pinch gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self checkScale];
        
        last_scale = MAX(mainContentView.frame.size.width /  img.size.width, mainContentView.frame.size.height / img.size.height);
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changed");
        //        mainContentPhotoLayer.transform = CGAffineTransformScale(mainContentPhotoLayer.transform, gesture.scale,gesture.scale);
        CGPoint cp = contentLayer.position;
        CGFloat scale = 1 + (gesture.scale - 1) * 0.1;
        contentLayer.frame = CGRectMake(contentLayer.frame.origin.x, contentLayer.frame.origin.y, contentLayer.frame.size.width * scale, contentLayer.frame.size.height * scale);
        contentLayer.position = cp;
    }
}

- (void)checkScale {
    CGFloat top_margin = 0;
    if (contentLayer.bounds.size.width > contentLayer.bounds.size.height) {
        if (contentLayer.frame.size.height < mainContentView.frame.size.height) {
            CGFloat width = (mainContentView.frame.size.height - top_margin) / contentLayer.frame.size.height * contentLayer.frame.size.width;
            [self scaleView:contentLayer.frame and:CGRectMake(0, top_margin, width, mainContentView.frame.size.height)];
        }
    } else {
        if (contentLayer.frame.size.width < mainContentView.frame.size.width) {
            CGFloat height = mainContentView.frame.size.width / contentLayer.frame.size.width * contentLayer.frame.size.height;
            [self scaleView:contentLayer.frame and:CGRectMake(0, top_margin, mainContentView.frame.size.width, height - top_margin)];
        }
    }
}

- (void)scaleView:(CGRect)frame_old and:(CGRect)frame_new {
    
    [CATransaction begin];
    contentLayer.frame = frame_new;
    [CATransaction setCompletionBlock:^{
        CGFloat move_x = [self distanceMoveHer];
        CGFloat move_y = [self distanceMoveVer];
        [CATransaction begin];
        contentLayer.position = CGPointMake(move_x + contentLayer.position.x, move_y + contentLayer.position.y);
        [CATransaction commit];
    }];
    [CATransaction commit];
}
@end
