//
//  AYSetServiceTypeController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceTypeController.h"

@interface AYSetServiceTypeController ()

@end

@implementation AYSetServiceTypeController {
    BOOL isFromConfirmFlow;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		if ([tmp isKindOfClass:[NSString class]]) {
			isFromConfirmFlow = YES;
		}
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	self.view.backgroundColor = [Tools themeColor];
	
    UILabel *titleLabel = [Tools creatUILabelWithText:@"选择您即将发布\n的服务类型?" andTextColor:[Tools themeColor] andFontSize:624.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 200/667);
		make.width.mas_equalTo(240);
    }];
	
	CGFloat unitHeight = 100.f;
	
    UIView *locBGView = [[UIView alloc] init];
    locBGView.backgroundColor = [Tools whiteColor];
    [self.view addSubview:locBGView];
    [locBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, unitHeight * 2));
    }];
	[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:locBGView];
	
    UILabel *norseLabel = [Tools creatUILabelWithText:@"看顾服务" andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [locBGView addSubview:norseLabel];
    [norseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locBGView.mas_top).offset(unitHeight * 0.5);
        make.left.equalTo(locBGView).offset(20);
        make.right.equalTo(locBGView).offset(-20);
    }];
    norseLabel.userInteractionEnabled = YES;
    [norseLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNorseLabelTap)]];
    
    UIImageView *access = [[UIImageView alloc]init];
    [locBGView addSubview:access];
    access.image = IMGRESOURCE(@"plan_time_icon");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(locBGView).offset(-20);
        make.centerY.equalTo(norseLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
	[Tools creatCALayerWithFrame:CGRectMake(10, unitHeight, SCREEN_WIDTH - 20, 0.5) andColor:[Tools garyLineColor] inSuperView:locBGView];
    
    UILabel *courseLabel = [Tools creatUILabelWithText:@"课程" andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [locBGView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locBGView.mas_bottom).offset(-unitHeight * 0.5);
        make.left.equalTo(locBGView).offset(20);
        make.right.equalTo(locBGView).offset(-20);
    }];
    courseLabel.userInteractionEnabled = YES;
    [courseLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCourseLabelTap)]];
    
    UIImageView *access2 = [[UIImageView alloc]init];
    [locBGView addSubview:access2];
    access2.image = IMGRESOURCE(@"plan_time_icon");
    [access2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(locBGView).offset(-20);
        make.centerY.equalTo(courseLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
//    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
//    view.backgroundColor = [UIColor whiteColor];
    
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
//	NSString *title = @"服务类型";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- actions
- (void)didNorseLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceTheme");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithInt:ServiceTypeNursery] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didCourseLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceTheme");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[NSNumber numberWithInt:ServiceTypeCourse] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
    if (isFromConfirmFlow) {
        [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    }
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

@end
