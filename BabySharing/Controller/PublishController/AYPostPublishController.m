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
}

@synthesize mainContentView = _mainContentView;

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:view_title];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width - 10.5 * 2;
    _mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width - 2 * CARD_CONTENG_MARGIN, img_height)];
    _mainContentView.backgroundColor = [UIColor clearColor];
    _mainContentView.userInteractionEnabled = YES;
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    [container addSubview:_mainContentView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [container addGestureRecognizer:tap];
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /**
     * input method
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//    inputView.isMoved = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
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
    return nil;
}

- (id)SharingSNSWithWechat:(id)args {
    return nil;
}

- (id)SharingSNSWithWeibo:(id)args {
    return nil;
}

- (void)tapElseWhere:(UITapGestureRecognizer*)tap {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyBoard" object:nil];
    id<AYViewBase> container = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd = [container.commands objectForKey:@"resignFirstResponed"];
    [cmd performWithResult:nil];
}

#pragma mark -- keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    if (isUpAnimation) {
        return;
    }
    
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    
    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    CGFloat maxY = CGRectGetMaxY(container.frame);
    diff = self.view.frame.size.height - maxY - keyBoardFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        container.center = CGPointMake(container.center.x, container.center.y + diff);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (!isUpAnimation) {
        return;
    }
    UIView* container = [self.views objectForKey:@"PublishContainer"];
    
    isUpAnimation = !isUpAnimation;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    [UIView animateWithDuration:0.3 animations:^{
        container.center = CGPointMake(container.center.x, container.center.y - diff);
    }];
}
@end
