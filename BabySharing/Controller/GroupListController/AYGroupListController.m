//
//  AYGroupListController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGroupListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#define TABLE_VIEW_TOP_MARGIN   74

@implementation AYGroupListController {
    
    NSArray* chatGroupArray_mine;
    NSArray* chatGroupArray_recommend;
//    UIView *bkView;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CGPathRef startPath;
    
    CALayer *scaleMaskLayer;
    
    UIViewController* homeVC;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        homeVC = [dic objectForKey:kAYControllerChangeArgsKey];
        
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    UIView* view_fake = [self.views objectForKey:@"FakeNavBar"];
    UIView* view_image = [self.views objectForKey:@"Image"];
    [view_fake addSubview:view_image];
    
    id<AYCommand> cmd = [((id<AYViewBase>)view_fake).commands objectForKey:@"setLeftBtnVisibility:"];
    NSNumber* bHidden = [NSNumber numberWithBool:YES];
    [cmd performWithResult:&bHidden];
    
    [self createNavigationBar];
    [self createAnimateView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

#pragma mark -- layouts
- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, width, height - TABLE_VIEW_TOP_MARGIN);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, screen_width, 64);
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(0, 63, screen_width, 1);
    [view.layer addSublayer:line];
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, 70, 22);
    ((UIImageView*)view).image = PNGRESOURCE(@"home_title_logo");
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 2, 12 + 64 / 2);
    return nil;
}

- (void)createNavigationBar {
    actionView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 38)];
    
    [actionView addTarget:self action:@selector(popToHomeViewController) forControlEvents:UIControlEventTouchUpInside];
    actionView.tag = -99;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    actionView.center = CGPointMake(width - actionView.frame.size.width / 2 + 5, 21 + actionView.frame.size.height / 2);
    actionView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:actionView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = actionView.bounds;
    maskLayer.path = maskPath.CGPath;
    actionView.layer.mask = maskLayer;
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, 30, 30);
    layer.position = CGPointMake(CGRectGetWidth(actionView.frame) / 2 - 4.5, CGRectGetHeight(actionView.frame) / 2);
    layer.contents = (id)PNGRESOURCE(@"home_chat_back").CGImage;
    [actionView.layer addSublayer:layer];
    
    scaleMaskLayer = [[CALayer alloc] init];
    scaleMaskLayer.frame = CGRectMake(0, 0, 15, 15);
    scaleMaskLayer.transform = CATransform3DMakeScale(0, 0, 0);
    scaleMaskLayer.position = CGPointMake(15, 15);
    scaleMaskLayer.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0].CGColor;
    [layer addSublayer:scaleMaskLayer];
   
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];
    [bkView addSubview:actionView];
}

- (void)createAnimateView {
    // 动画的layer
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];
    CGPoint animateCenter = [actionView convertPoint:CGPointMake(19, actionView.frame.size.height / 2) toView:bkView];
    
    // 半径
    radius = sqrt(pow(0 - animateCenter.x, 2) + pow(0 - animateCenter.y, 2));
    animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    animationView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    animationView.center = animateCenter;
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame))];
    circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.path = startCircle.CGPath;
    animationView.layer.mask = circleLayer;
    [bkView addSubview:animationView];
    bkView.clipsToBounds = YES;
    [bkView bringSubviewToFront:actionView];
}

- (void)popToHomeViewController {
    actionView.enabled = NO;
    UIView* bkView = [self.views objectForKey:@"FakeNavBar"];
//    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[HomeViewController class]]) {
//        UIViewController* homeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            // handle completion here
            NSLog(@"pop结束");
            
            CABasicAnimation *maskLayerAnimation = [circleLayer animationForKey:@"path"] ? (CABasicAnimation *)[circleLayer animationForKey:@"path"] : [CABasicAnimation animationWithKeyPath:@"path"];
            //    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            maskLayerAnimation.fromValue = (__bridge id)(circleLayer.path);
            maskLayerAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)].CGPath);
            maskLayerAnimation.duration = 0.3;
            maskLayerAnimation.delegate = self;
            [circleLayer addAnimation:maskLayerAnimation forKey:@"path"];
            circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)].CGPath;
            
            // 设定为缩放
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            // 动画选项设定
            scaleAnimation.duration = 0.4; // 动画持续时间
            scaleAnimation.repeatCount = 1; // 重复次数
            // 缩放倍数
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0]; // 开始时的倍率
            scaleAnimation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
            // 添加动画
            [scaleMaskLayer addAnimation:scaleAnimation forKey:@"scale-layer"];
            
            // 设置各个view的frame
            homeVC.tabBarController.tabBar.hidden = NO;
            homeVC.tabBarController.tabBar.frame = CGRectMake(-CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetMinY(homeVC.tabBarController.tabBar.frame), CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetHeight(homeVC.tabBarController.tabBar.frame));
            homeVC.view.frame = CGRectMake(-CGRectGetWidth(homeVC.view.frame), 0, CGRectGetWidth(homeVC.view.frame), CGRectGetHeight(homeVC.view.frame));
            self.view.frame = CGRectMake(CGRectGetWidth(homeVC.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            bkView.frame = CGRectMake(CGRectGetWidth(bkView.frame), 0, CGRectGetWidth(bkView.frame), CGRectGetHeight(bkView.frame));
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                homeVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(homeVC.view.frame), CGRectGetHeight(homeVC.view.frame));
                bkView.frame = CGRectMake(0, 0, CGRectGetWidth(bkView.frame), CGRectGetHeight(bkView.frame));
                homeVC.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetMinY(homeVC.tabBarController.tabBar.frame), CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetHeight(homeVC.tabBarController.tabBar.frame));
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
                [bkView removeFromSuperview];
                actionView.enabled = YES;
            }];
        }];
        
        [self.navigationController popViewControllerAnimated:NO];
        homeVC.tabBarController.tabBar.hidden = YES;
        // 将当前view加到上一个VC.view
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [homeVC.view addSubview:self.view];
        [homeVC.view bringSubviewToFront:self.view];
        [homeVC.view addSubview:bkView];
        [homeVC.view bringSubviewToFront:bkView];
        [CATransaction commit];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
@end
