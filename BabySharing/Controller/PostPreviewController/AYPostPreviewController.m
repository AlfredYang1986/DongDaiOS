//
//  AYPostPreviewController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPreviewController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYDongDaSegDefines.h"

#define FAKE_NAVIGATION_BAR_HEIGHT      64
#define FUNC_BAR_HEIGHT                 47

@implementation AYPostPreviewController
@synthesize mainContentView = _mainContentView;
@synthesize status = _status;

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width;
    _mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, width, img_height)];
    _mainContentView.backgroundColor = [UIColor clearColor];
    _mainContentView.userInteractionEnabled = YES;
    _mainContentView.clipsToBounds = YES;
    [self.view addSubview:_mainContentView];
    [self.view sendSubviewToBack:_mainContentView];
    
    //    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewHandleTap:)];
    //    [_mainContentView addGestureRecognizer:tap];
    
    self.status = AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn;
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- layout
- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setRightBtnImg:"];
    UIImage* left = PNGRESOURCE(@"dongda_back_light");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnImg:"];
    UIImage* right = PNGRESOURCE(@"dongda_next");
    [cmd_right performWithResult:&right];
    
    return nil;
}

#define SEG_BTN_MARGIN_BETWEEN  80
- (id)DongDaSegLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + img_height; //width * aspectRatio;
    view.frame = CGRectMake(0, height, width, FUNC_BAR_HEIGHT);
    
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
   
    NSArray* items = [self getFunctionBarItems];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
//    [dic_add_item_0 setValue:@"标签" forKey:kAYSegViewTitleKey];
    [dic_add_item_0 setValue:items.firstObject forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
//    [dic_add_item_1 setValue:@"滤镜" forKey:kAYSegViewTitleKey];
    [dic_add_item_1 setValue:items.lastObject forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    //    [dic_user_info setValue:[NSNumber numberWithFloat:4.f] forKey:kAYSegViewCornerRadiusKey];
    [dic_user_info setValue:[UIColor colorWithWhite:0.0706 alpha:1.f] forKey:kAYSegViewBackgroundColorKey];
    [dic_user_info setValue:[NSNumber numberWithBool:NO] forKey:kAYSegViewLineHiddenKey];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:SEG_BTN_MARGIN_BETWEEN] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = [self getNavTitle]; //@"编辑图片";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    return nil;
}

- (id)TagPreviewLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width; //width * aspectRatio;
    CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - FUNC_BAR_HEIGHT;
    view.frame = CGRectMake(0, height + FUNC_BAR_HEIGHT, width, prefered_height);
    view.hidden = YES;
    return nil;
}

- (id)TagEntryLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width - FUNC_BAR_HEIGHT;
    
    view.frame = CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, width, height);
    view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    view.hidden = YES;
    return nil;
}

- (id)FilterPreviewLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width; //width * aspectRatio;
    CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - FUNC_BAR_HEIGHT;
    view.frame = CGRectMake(0, height + FUNC_BAR_HEIGHT, width, prefered_height);
    view.hidden = YES;
    return nil;
}

#pragma mark -- status
- (void)setCurrentStatus:(AYPostPhotoPreviewControllerType)status {
    _status = status;
    
    switch (_status) {
        case AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn: {
            UIView* view_tag = [self.views objectForKey:@"TagPreview"];
            view_tag.hidden = NO;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = NO;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = YES;
            }
            break;
        case AYPostPhotoPreviewControllerTypeSegAtTags: {
            UIView* view_tag = [self.views objectForKey:@"TagPreview"];
            view_tag.hidden = NO;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = YES;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = YES;
            }
            break;
        case AYPostPhotoPreviewControllerTypeSegAtFilter: {
            UIView* view_tag = [self.views objectForKey:@"TagPreview"];
            view_tag.hidden = YES;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = YES;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = NO;
            }
            break;
            
        default:
            break;
    }
}

- (NSString*)getNavTitle {
    return nil;
}

- (NSArray*)getFunctionBarItems {
    return nil;
}

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
  
    switch (index.integerValue) {
        case 0:
            self.status = AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn;
            break;
        case 1:
            self.status = AYPostPhotoPreviewControllerTypeSegAtFilter;
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (id)entryViewTaped {
    self.status = AYPostPhotoPreviewControllerTypeSegAtTags;
    return nil;
}

- (id)didTagEntrySelected:(id)obj {
    
    NSNumber* tag_type = (NSNumber*)obj;
   
    AYViewController* des = DEFAULTCONTROLLER(@"TagSearch");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:tag_type forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}
@end
