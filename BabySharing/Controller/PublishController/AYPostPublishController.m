//
//  AYPostPublishController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPublishController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "Tools.h"

#define CARD_CONTENG_MARGIN             10.5

#define FAKE_NAVIGATION_BAR_HEIGHT  64
#define SNS_BUTTON_WIDTH            25
#define SNS_BUTTON_HEIGHT           SNS_BUTTON_WIDTH

#define WECHAT_BTN                  0
#define WEIBO_BTN                   1
#define QQ_BTN                      2

#define SNS_BTN_COUNT               3

#define BOTTON_BAR_HEIGHT           (149.0 / 667.0) * [UIScreen mainScreen].bounds.size.height

#define CARD_CONTENG_MARGIN             10.5

@implementation AYPostPublishController {
    CGRect keyBoardFrame;
    BOOL isUpAnimation;
    CGFloat diff;
    
    UIButton* bar_publich_btn;
    UIButton* bar_cancel_btn;
    UIButton* bar_save_btn;
}

@synthesize mainContentView = _mainContentView;
@synthesize tags = _tags;


@synthesize isShareQQ = _isShareQQ;
@synthesize isShareWechat = _isShareWechat;
@synthesize isShareWeibo = _isShareWeibo;

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat img_height = width - 10.5 * 2;
//    _mainContentView = [[UIImageView alloc]init];
    _mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width - 2 * CARD_CONTENG_MARGIN, width - 2 * CARD_CONTENG_MARGIN)];

    _mainContentView.backgroundColor = [UIColor clearColor];
    _mainContentView.userInteractionEnabled = YES;
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    [container addSubview:_mainContentView];
    [container sendSubviewToBack:_mainContentView];
    [self.view sendSubviewToBack:container];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [container addGestureRecognizer:tap];
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- layouts
- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = [self getNavTitle];
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setRightBtnImg:"];
    UIImage* left = PNGRESOURCE(@"dongda_back_light");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    id right = [NSNumber numberWithBool:YES];
    [cmd_right performWithResult:&right];
    
    bar_publich_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 10.5 - 50, 25, 50, 30)];
    [bar_publich_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_publich_btn setTitle:@"发布" forState:UIControlStateNormal];
    bar_publich_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [bar_publich_btn setBackgroundImage:[Tools imageWithColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.F] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateNormal];
    [bar_publich_btn setBackgroundImage:[Tools imageWithColor:[UIColor darkGrayColor] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateDisabled];
    bar_publich_btn.layer.cornerRadius = 4.f;
    bar_publich_btn.clipsToBounds = YES;
    //    [bar_right_btn sizeToFit];
    [bar_publich_btn addTarget:self action:@selector(didSelectPostBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_publich_btn.center = CGPointMake(width - 10 - bar_publich_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [view addSubview:bar_publich_btn];
    bar_publich_btn.enabled = NO;
    /***************************************************************************************/

#define CANCEL_BTN_WIDTH            30
#define CANCEL_BTN_HEIGHT           CANCEL_BTN_WIDTH
#define CANCEL_BTN_LEFT_MARGIN      10.5
    bar_cancel_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CANCEL_BTN_WIDTH, CANCEL_BTN_HEIGHT)];
    bar_cancel_btn.center = CGPointMake(CANCEL_BTN_WIDTH / 2 + CANCEL_BTN_LEFT_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar_cancel_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    bar_cancel_btn.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    [bar_cancel_btn sizeToFit];
    [bar_cancel_btn addTarget:self action:@selector(didSelectCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_cancel_btn.hidden = YES;
    [view addSubview:bar_cancel_btn];
    /***************************************************************************************/
    
    bar_save_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 10.5 - 50, 25, 50, 30)];
    [bar_save_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_save_btn setTitle:@"保存" forState:UIControlStateNormal];
    bar_save_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [bar_save_btn addTarget:self action:@selector(didSelectSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_save_btn.center = CGPointMake(width - 10 - bar_publich_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    bar_save_btn.hidden = YES;
    [view addSubview:bar_save_btn];
   
    return nil;
}

- (id)PublishContainerLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(CARD_CONTENG_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT + 10, width - 2 * CARD_CONTENG_MARGIN, height - FAKE_NAVIGATION_BAR_HEIGHT - BOTTON_BAR_HEIGHT - CARD_CONTENG_MARGIN);
    view.layer.cornerRadius = 5.f;
    view.clipsToBounds = YES;
    return nil;
}

- (id)SharingSNSLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, height - BOTTON_BAR_HEIGHT, width, BOTTON_BAR_HEIGHT);
    view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    return nil;
}

#pragma mark -- actions
- (NSString*)getNavTitle {
    return nil;
}

- (void)handleTap:(UITapGestureRecognizer*)tap {
    
}

- (void)textFieldChanged:(NSNotification*)notify {

}

#pragma mark -- notifications
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)SharingSNSWithQQ:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    _isShareQQ = ((NSNumber*)[dic valueForKey:@"BtnSelected"]).boolValue;
    return nil;
}

- (id)SharingSNSWithWechat:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    _isShareWechat = ((NSNumber*)[dic valueForKey:@"BtnSelected"]).boolValue;
    return nil;
}

- (id)SharingSNSWithWeibo:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    _isShareWeibo = ((NSNumber*)[dic valueForKey:@"BtnSelected"]).boolValue;
    return nil;
}

- (id)canPublish:(id)args {
    BOOL b = ((NSNumber*)args).boolValue;
    bar_publich_btn.enabled = b;
    return nil;
}

- (void)tapElseWhere:(UITapGestureRecognizer*)tap {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyBoard" object:nil];
    id<AYViewBase> container = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd = [container.commands objectForKey:@"resignFirstResponed"];
    [cmd performWithResult:nil];
}

#pragma mark -- keyboard
- (void)KeyboardShowKeyboard:(id)args {
    NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
    if (isUpAnimation) {
        return;
    }
    
    self.status = AYPostPublishControllerStatusInputing;
    
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    
    isUpAnimation = !isUpAnimation;
    CGFloat maxY = CGRectGetMaxY(container.frame);
    diff = self.view.frame.size.height - maxY - step.floatValue;
    
    [UIView animateWithDuration:0.3 animations:^{
        container.center = CGPointMake(container.center.x, container.center.y - fabsf(diff));
    }];
}

- (void)KeyboardHideKeyboard:(id)args {
    if (!isUpAnimation) {
        return;
    }
    
    self.status = AYPostPublishControllerStatusReady;
    
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    
    isUpAnimation = !isUpAnimation;
    [UIView animateWithDuration:0.3 animations:^{
        container.center = CGPointMake(container.center.x, container.center.y + fabsf(diff));
    }];
}

#pragma mark -- actions
- (void)didSelectPostBtn {
    bar_publich_btn.userInteractionEnabled = NO;
}

- (void)didSelectCancelBtn {
    id<AYViewBase> container = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd = [container.commands objectForKey:@"clearInputs"];
    [cmd performWithResult:nil];
}

- (void)didSelectSaveBtn {
    id<AYViewBase> container = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd = [container.commands objectForKey:@"resignFirstResponed"];
    [cmd performWithResult:nil];
}

- (void)setCurrentStatus:(AYPostPublishControllerStatus)status {
    if (_status != status) {
        _status = status;
        
        id<AYViewBase> bar = [self.views objectForKey:@"FakeNavBar"];
        id<AYCommand> cmd = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
        id hidden = nil;
        switch (_status) {
            case AYPostPublishControllerStatusReady: {
                    bar_save_btn.hidden = YES;
                    bar_cancel_btn.hidden = YES;
                    bar_publich_btn.hidden = NO;

                    hidden = [NSNumber numberWithBool:NO];
                }
                break;
            case AYPostPublishControllerStatusInputing: {
                    bar_save_btn.hidden = NO;
                    bar_cancel_btn.hidden = NO;
                    bar_publich_btn.hidden = YES;

                    hidden = [NSNumber numberWithBool:YES];
                }
                break;
            default:
                break;
        }
        [cmd performWithResult:&hidden];
    }
}
@end
