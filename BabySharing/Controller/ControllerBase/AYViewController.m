//
//  AYViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYViewLayoutDefines.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "AYRemoteCallCommand.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYCommentServiceController.h"

#import "MBProgressHUD.h"

#define btmAlertViewH                   80

@implementation AYViewController{
    int count_loading;
    int time_count;
    NSTimer *timer_loding;
    
    UIView *maskView;
    UIView *btmAlertView;
}


@synthesize para = _para;

@synthesize commands = _commands;
@synthesize views = _views;
@synthesize delegates = _delegates;
@synthesize facades = _facades;

@synthesize loading = _loading;

- (NSString*)getControllerName {
//    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Landing"] stringByAppendingString:kAYFactoryManagerControllersuffix];
    return NSStringFromClass([self class]);
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.backgroundColor = [Tools whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	count_loading = 0;
	
    for (NSString* view_name in self.views.allKeys) {
        NSLog(@"view name is : %@", view_name);
        SEL selector = NSSelectorFromString([[view_name stringByAppendingString:kAYViewLayoutSuffix] stringByAppendingString:@":"]);
        id (*func)(id, SEL, id) = (id(*)(id, SEL, id))[self methodForSelector:selector];
        UIView* view = [self.views objectForKey:view_name];
        func(self, selector, view);
        ((id<AYViewBase>)view).controller = self;
        [self.view addSubview:view];
    }
    
    for (id<AYDelegateBase> delegate in self.delegates.allValues) {
        delegate.controller = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (timer_loding) {
		[timer_loding invalidate];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	});
	
	[self deallocBtmAlertWithVCWillDisapper];
}

- (void)dealloc {
    [self clearController];
}

- (void)clearController {
    for (id<AYCommand> facade in self.facades.allValues) {
        NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
        [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
        [reg setValue:kAYNotifyFunctionKeyUnregister forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:self forKey:kAYNotifyControllerKey];
        
        [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
        
        [facade performWithResult:&reg];
    }
    
    AYModel* m = MODEL;
    NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
    [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
    [reg setValue:kAYNotifyFunctionKeyUnregister forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:self forKey:kAYNotifyControllerKey];
    [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
    [m performWithResult:&reg];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    for (id<AYCommand> cmd in self.commands.allValues) {
        [cmd postPerform];
    }

    for (id<AYCommand> cmd in self.facades.allValues) {
        [cmd postPerform];
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    *obj = self;
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    id<AYCommand> cmd = nil;
    if (facade_name == nil) {
        cmd = [self.commands objectForKey:command_name];
        CHECKCMD(cmd);
    } else {
        id<AYFacadeBase> facade = [self.facades objectForKey:facade_name];
        CHECKFACADE(facade);
        cmd = [facade.commands objectForKey:command_name];
        CHECKCMD(cmd);
    }
    
    if ([cmd isKindOfClass:[AYRemoteCallCommand class]]) {
        dispatch_queue_t q = dispatch_queue_create("remote call", nil);
        dispatch_async(q, ^{
            [((AYRemoteCallCommand*)cmd) performWithResult:args andFinishBlack:^(BOOL success, NSDictionary * result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = NSSelectorFromString([[command_name stringByAppendingString:kAYRemoteCallResultKey] stringByAppendingString:kAYRemoteCallResultArgsKey]);
                    IMP imp = [self methodForSelector:selector];
                    if (imp) {
                        id (*func)(id, SEL, BOOL, NSDictionary*)= (id (*)(id, SEL, BOOL, NSDictionary*))imp;
                        func(self, selector, success, result);
                    }
                });
            }];
        });
    
    } else {
        [cmd performWithResult:&args];
    }
    return (id)args;
}

- (id)startRemoteCall:(id)obj {
    
    time_count = 30;            //star a new remote, so reset time count to 120
    if (count_loading == 0) {
        timer_loding = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [timer_loding fire];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
    }
    count_loading++;
    return nil;
}

- (id)endRemoteCall:(id)obj {
    
    count_loading --;
    if (count_loading == 0) {
        [timer_loding invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    
    return nil;
}

- (void)timerRun {
    time_count -- ;
    if (time_count == 0) {
        count_loading = 0;
        [timer_loding invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

#pragma mark -- order
- (id)OrderAccomplished:(id)args {
  
    UIViewController *activeVC = [Tools activityViewController];
    if (![activeVC isKindOfClass:[AYCommentServiceController class]]) {
    id<AYCommand> des = DEFAULTCONTROLLER(@"CommentService");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
        [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:activeVC forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd_show_module = SHOWMODULEUP;
        [cmd_show_module performWithResult:&dic];       
    }
    return nil;
}

- (id)NotifyTheServant:(id)args {
	NSString *title = @"您有订单状态发生改变，请及时处理";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	return nil;
}

- (id)NotifyTheCommon:(id)args {
	NSString *title = @"您有订单状态发生改变，请及时处理";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	return nil;
}

#pragma mark -- btm alert
- (id)ShowBtmAlert:(id)args {
    
    if (btmAlertView) {
        [self deallocBtmAlertWithVCWillDisapper];
    }
    
    btmAlertView = [[UIView alloc]init];
    btmAlertView.backgroundColor = [Tools whiteColor];
    
    //添加view到window
    [[UIApplication sharedApplication].keyWindow addSubview:btmAlertView];
    
    CALayer *topLine = [CALayer layer];
    topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    topLine.backgroundColor = [Tools garyLineColor].CGColor;
    [btmAlertView.layer addSublayer:topLine];
    
    btmAlertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, btmAlertViewH);
    [UIView animateWithDuration:0.25 animations:^{
        btmAlertView.center = CGPointMake(btmAlertView.center.x, SCREEN_HEIGHT - btmAlertViewH*0.5);
    }];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(didBtmAlertViewCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btmAlertView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btmAlertView).offset(-5);
        make.centerY.equalTo(btmAlertView);
        make.size.mas_equalTo(CGSizeMake(49, 49));
    }];
    
    NSDictionary *alert_info = (NSDictionary*)args;
    int type_alert = ((NSNumber*)[alert_info objectForKey:@"type"]).intValue;
    
    NSString *titleStr = [alert_info objectForKey:@"title"];
    UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools blackColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 0;
    [btmAlertView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btmAlertView);
        make.left.equalTo(btmAlertView).offset(15);
        make.right.equalTo(closeBtn.mas_left).offset(-10);
    }];
    
    switch (type_alert) {
        case BtmAlertViewTypeCommon:
        case BtmAlertViewTypeHideWithAction:
        {
            
        }
            break;
        case BtmAlertViewTypeHideWithTimer:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    btmAlertView.center = CGPointMake(btmAlertView.center.x, SCREEN_HEIGHT + btmAlertViewH*0.5);
				} completion:^(BOOL finished) {
					[btmAlertView removeFromSuperview];
					btmAlertView = nil;
				}];
            });
        }
            break;
        case BtmAlertViewTypeWitnBtn:
        {
            
            UIViewController *rootVC = self.tabBarController;
            if (!rootVC) {
                rootVC = self.navigationController;
            }
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            maskView.backgroundColor = [Tools borderAlphaColor];
            [rootVC.view addSubview:maskView];
            
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btmAlertView).offset(15);
                make.left.equalTo(btmAlertView).offset(15);
                make.right.equalTo(closeBtn.mas_left).offset(-10);
            }];
            
            NSString *btnTitleStr = @"确认";
            UIButton *otherBtn = [Tools creatBtnWithTitle:btnTitleStr titleColor:[Tools theme] fontSize:14.f backgroundColor:nil];
            [otherBtn addTarget:self action:@selector(BtmAlertOtherBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btmAlertView addSubview:otherBtn];
            [otherBtn sizeToFit];
            [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel);
                make.top.equalTo(titleLabel.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(otherBtn.bounds.size.width + 10, otherBtn.bounds.size.height));
            }];
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)didBtmAlertViewCloseBtnClick {
	
	NSLog(@"BtmAlertViewClose");
	[UIView animateWithDuration:0.25 animations:^{
		btmAlertView.center = CGPointMake(btmAlertView.center.x, SCREEN_HEIGHT + btmAlertViewH*0.5);
		maskView.alpha = 0;
	} completion:^(BOOL finished) {
		[btmAlertView removeFromSuperview];
		[maskView removeFromSuperview];
		btmAlertView = nil;
	}];
		
}

- (void)BtmAlertOtherBtnClick {
    [self didBtmAlertViewCloseBtnClick];
}

- (id)HideBtmAlert:(id)args {
    [self didBtmAlertViewCloseBtnClick];
    return nil;
}

- (void)deallocBtmAlertWithVCWillDisapper {
	[btmAlertView removeFromSuperview];
	[maskView removeFromSuperview];
	btmAlertView = nil;
}

#pragma mark -- tabBarViewController selectedIndex
- (void)tabBarVCSelectIndex:(NSInteger)index {
    
    dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
		[dic_tmp setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
		[dic_tmp setValue:self forKey:kAYControllerActionSourceControllerKey];
		id<AYCommand> cmd = POPTOROOT;
		[cmd performWithResult:&dic_tmp];
    });
	
    UITabBarController* tabVC = [Tools activityViewController].tabBarController;
    DongDaTabBar* concret = [tabVC.tabBar viewWithTag:-99];
    concret.selectIndex = index;
    tabVC.selectedIndex = index;
}
@end
