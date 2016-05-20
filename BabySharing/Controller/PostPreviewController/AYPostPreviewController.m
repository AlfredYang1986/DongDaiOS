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
#import "PhotoTagEnumDefines.h"

#import "AYPhotoTagView.h"

#define FAKE_NAVIGATION_BAR_HEIGHT      64
#define FUNC_BAR_HEIGHT                 47

@interface AYPostPreviewController ()
@property (nonatomic, weak) UIView* edit_tag_view;
@end

@implementation AYPostPreviewController  {
    CGPoint point;
}
@synthesize mainContentView = _mainContentView;
@synthesize status = _status;
@synthesize edit_tag_view = _edit_tag_view;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        [self addTagToPreview:[dic objectForKey:kAYControllerChangeArgsKey]];
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
    CGFloat img_height = width;
    _mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, width, img_height)];
    _mainContentView.backgroundColor = [UIColor clearColor];
    _mainContentView.userInteractionEnabled = YES;
    _mainContentView.clipsToBounds = YES;
    [self.view addSubview:_mainContentView];
    [self.view sendSubviewToBack:_mainContentView];
    
    self.status = AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainContentTaped:)];
    [_mainContentView addGestureRecognizer:tap];
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

- (id)MovieCoverLayout:(UIView*)view {
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
            UIView* view_cover = [self.views objectForKey:@"MovieCover"];
            view_cover.hidden = NO;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = NO;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = YES;
            [self.edit_tag_view removeFromSuperview];
            }
            break;
        case AYPostPhotoPreviewControllerTypeSegAtTags: {
            UIView* view_tag = [self.views objectForKey:@"TagPreview"];
            view_tag.hidden = NO;
            UIView* view_cover = [self.views objectForKey:@"MovieCover"];
            view_cover.hidden = NO;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = YES;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = YES;
            [self.edit_tag_view removeFromSuperview];
            }
            break;
        case AYPostPhotoPreviewControllerTypeSegAtFilter: {
            UIView* view_tag = [self.views objectForKey:@"TagPreview"];
            view_tag.hidden = YES;
            UIView* view_cover = [self.views objectForKey:@"MovieCover"];
            view_cover.hidden = YES;
            UIView* view_entry = [self.views objectForKey:@"TagEntry"];
            view_entry.hidden = YES;
            UIView* view_filter = [self.views objectForKey:@"FilterPreview"];
            view_filter.hidden = NO;
            [self.edit_tag_view removeFromSuperview];
            }
            break;
            
        default:
            break;
    }
}

- (void)clearPhotoTagWithType:(NSInteger)t {
    for (id<AYViewBase> tmp in [self.mainContentView.subviews copy]) {
        id<AYCommand> cmd = [tmp.commands objectForKey:@"queryTagType"];
        NSNumber* result = nil;
        [cmd performWithResult:&result];
        
        if (result.integerValue == t) {
            [((UIView*)tmp) removeFromSuperview];
        }
    }
}

- (void)addTagToPreview:(NSDictionary*)dic {
    NSMutableDictionary* args = [dic mutableCopy];
    [args setValue:[NSNumber numberWithFloat:self.mainContentView.bounds.size.width] forKey:@"width"];
    [args setValue:[NSNumber numberWithFloat:self.mainContentView.bounds.size.height] forKey:@"height"];
  
    id<AYCommand> cmd = [self.commands objectForKey:@"PhotoTagInit"];
    [cmd performWithResult:&args];
    id<AYViewBase> tag_view = (id<AYViewBase>)args;
  
    {
        id<AYCommand> cmd = [tag_view.commands objectForKey:@"queryTagType"];
        NSNumber* result = nil;
        [cmd performWithResult:&result];
        [self clearPhotoTagWithType:result.integerValue];
    }
    
    [self.mainContentView addSubview:(UIView*)tag_view];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTaped:)];
    [(UIView*)tag_view addGestureRecognizer:tap];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [(UIView*)tag_view addGestureRecognizer:pan];
    
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [(UIView*)tag_view addGestureRecognizer:lp];
    
    self.status = AYPostPhotoPreviewControllerTypeSegAtTags;
}

- (void)mainContentTaped:(UIGestureRecognizer*)tap {
    if (self.status == AYPostPhotoPreviewControllerTypeSegAtTags) {
        self.status = AYPostPhotoPreviewControllerTypeShowingTagsEntryBtn;
    }
}

- (NSString*)getNavTitle {
    return nil;
}

- (NSArray*)getFunctionBarItems {
    return nil;
}

#pragma mark -- tap
- (void)tagTaped:(UITapGestureRecognizer*)tap {
    NSLog(@"tag taped");
    [self.edit_tag_view removeFromSuperview];
    id<AYViewBase> view = (id<AYViewBase>)tap.view;
    id<AYCommand> cmd = [view.commands objectForKey:@"changeTagDirection"];
    [cmd performWithResult:nil];
}

#pragma mark -- handle long press
- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"long gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
      
        id<AYCommand> cmd = [self.commands objectForKey:@"TagEditInit"];
        UIView* view = gesture.view;
        [cmd performWithResult:&view];
        ((id<AYViewBase>)view).controller = self;
        if (self.edit_tag_view != nil) {
            [self.edit_tag_view removeFromSuperview];
        }
   
        self.edit_tag_view = view;
        self.edit_tag_view.center = CGPointMake(gesture.view.center.x, /*FAKE_NAVIGATION_BAR_HEIGHT +*/ gesture.view.center.y - gesture.view.bounds.size.height / 2 - self.edit_tag_view.bounds.size.height / 2);
        [self.mainContentView addSubview:self.edit_tag_view];
    }
}

#pragma mark -- paste img pan handle
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    [self.edit_tag_view removeFromSuperview];
    AYPhotoTagView* tmp = (AYPhotoTagView*)gesture.view;
    
    static CGFloat or_x = 0;
    static CGFloat or_y = 0;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:self.mainContentView];
        [self.mainContentView bringSubviewToFront:tmp];
        
        or_x = tmp.frame.origin.x;
        or_y = tmp.frame.origin.y;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
//        point = CGPointMake(-1, -1);
        if (tmp.frame.origin.x < 0) {
            CGRect tmpRect = CGRectMake(0, tmp.frame.origin.y, tmp.bounds.size.width, tmp.bounds.size.height);
            tmp.frame = tmpRect;
        }
        else if (tmp.frame.origin.y < 0) {
            CGRect tmpRect = CGRectMake(tmp.frame.origin.x, 0, tmp.bounds.size.width, tmp.bounds.size.height);
            tmp.frame = tmpRect;
        }
        else if (CGRectGetMaxX(tmp.frame) > CGRectGetMaxX(self.mainContentView.frame)) {
            CGRect tmpRect = CGRectMake(CGRectGetMaxX(self.mainContentView.frame)-tmp.bounds.size.width, tmp.frame.origin.y, tmp.bounds.size.width, tmp.bounds.size.height);
            tmp.frame = tmpRect;
        }
        else if (CGRectGetMaxY(tmp.frame) > CGRectGetMaxY(self.mainContentView.frame)) {
            CGRect tmpRect = CGRectMake(tmp.frame.origin.x, CGRectGetMaxY(self.mainContentView.frame)-tmp.bounds.size.height, tmp.bounds.size.width, tmp.bounds.size.height);
            tmp.frame = tmpRect;
        }
        
        tmp.offset_x = tmp.frame.origin.x / self.mainContentView.bounds.size.width;
        tmp.offset_y = tmp.frame.origin.y / self.mainContentView.bounds.size.height;
        
        CGFloat move_x = [self distanceMoveHerWithView:tmp andOrx:or_x];
        CGFloat move_y = [self distanceMoveVerWithView:tmp andOry:or_y];
        [self moveView:move_x and:move_y withView:tmp];
        point = CGPointMake(move_x, move_y);
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        if ([gesture locationInView:self.mainContentView].y > self.mainContentView.frame.size.height - self.mainContentView.frame.size.height * 0.1) {
            return;
        } else {
            tmp.center = [gesture locationInView:self.mainContentView];
                }
//        tmp.center = [gesture locationInView:self.mainContentView];
        
    }
}

- (void)moveView:(float)move_x and:(float)move_y withView:(UIView*)view {
    [UIView animateWithDuration:0.3f animations:^{
//        view.center = CGPointMake(view.center.x + move_x, view.center.y + move_y);
        view.center = CGPointMake(view.center.x , view.center.y );
    }];
}

- (CGFloat)distanceMoveVerWithView:(UIView*)view andOry:(CGFloat)y{
//    if (view.frame.origin.y < 0)
//        return -view.frame.origin.y;
//    else if (view.frame.origin.y + view.frame.size.height > self.mainContentView.frame.size.height)
//        return -(view.frame.origin.y + view.frame.size.height - self.mainContentView.frame.size.height);
//    else return 0;
    return view.frame.origin.y - y;
}

- (CGFloat)distanceMoveHerWithView:(UIView*)view andOrx:(CGFloat)x{
    
//    if (view.frame.origin.x < 0)
//        return -view.frame.origin.x;
//    else if (view.frame.origin.x + view.frame.size.width > self.mainContentView.frame.size.width)
//        return -(view.frame.origin.x + view.frame.size.width - self.mainContentView.frame.size.width);
//    else return 0;
    return view.frame.origin.x - x;
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

- (id)didSelectedFilterPhoto:(id)obj {
    return nil;
}

- (id)didSelectedFilterMovie:(id)obj {
    return nil;
}

- (void)pushToTagSearchController:(id)args {
    AYViewController* des = DEFAULTCONTROLLER(@"TagSearch");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push]; 
}

- (NSArray*)photoTagToDictionary {
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (id<AYViewBase> tmp in [self.mainContentView.subviews copy]) {
        NSDictionary* dic = nil;
        id<AYCommand> cmd = [tmp.commands objectForKey:@"queryContentInfo"];
        [cmd performWithResult:&dic];
        if (dic) {
            [arr addObject:dic];
        }
    }
    return [arr copy];
}

- (id)didTagEntrySelected:(id)obj {
    NSNumber* tag_type = (NSNumber*)obj;
    [self pushToTagSearchController:tag_type];
    return nil;
}

- (id)EditBtnSelected:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;
    NSNumber* tag_type = [dic objectForKey:@"tag_type"];
    [self pushToTagSearchController:tag_type];
    [self.edit_tag_view removeFromSuperview];
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

- (id)rightBtnSelected {
    return nil;
}
@end
