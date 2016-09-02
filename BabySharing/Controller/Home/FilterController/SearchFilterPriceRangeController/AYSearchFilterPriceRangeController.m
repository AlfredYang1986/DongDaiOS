//
//  AYSearchFilterPriceRangController.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterPriceRangeController.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "Tools.h"
#import "AYCommandDefines.h"

#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height

#define STATUS_HEIGHT                       20
#define NAV_HEIGHT                          45

#define TEXT_COLOR                          [UIColor redColor]
#define LINE_COLOR                          [UIColor redColor]

#define CONTROLLER_MARGIN                   10.f

#define TEXT_FIELD_MARGIN_BETWEEN           40.f

#define FIELD_HEIGHT                        80

@implementation AYSearchFilterPriceRangeController {
    id dic_split_value;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        dic_split_value = [dic objectForKey:kAYControllerSplitValueKey];
        
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
    //    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel* title = [[UILabel alloc]init];
    title.text = @"您期望的价格?";
    title.font = [UIFont systemFontOfSize:30.f];
    title.textColor = TEXT_COLOR;
    [title sizeToFit];
    title.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN, SCREEN_WIDTH - 2 * CONTROLLER_MARGIN, title.frame.size.height);
    
    [self.view addSubview:title];
    
    {
        UITextField* field = [[UITextField alloc]init];
        field.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height, SCREEN_WIDTH / 2 - 2 * CONTROLLER_MARGIN - TEXT_FIELD_MARGIN_BETWEEN / 2, FIELD_HEIGHT);
        field.textAlignment = NSTextAlignmentCenter;
        field.placeholder = @"最低价格";
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, field.frame.size.height - 1, field.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = LINE_COLOR.CGColor;
        [field.layer addSublayer:bottomBorder];
        [self.view addSubview:field];
    }
   
    {
        UITextField* field = [[UITextField alloc]init];
        field.frame = CGRectMake(CONTROLLER_MARGIN + SCREEN_WIDTH / 2 + TEXT_FIELD_MARGIN_BETWEEN / 2, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height, SCREEN_WIDTH / 2 - 2 * CONTROLLER_MARGIN - TEXT_FIELD_MARGIN_BETWEEN / 2, FIELD_HEIGHT);
        field.textAlignment = NSTextAlignmentCenter;
        field.placeholder = @"最高价格";
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, field.frame.size.height - 1, field.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = LINE_COLOR.CGColor;
        [field.layer addSublayer:bottomBorder];
        [self.view addSubview:field];
    }
    
    {
        CALayer* line = [CALayer layer];
        line.frame = CGRectMake(0, 0, 20, 1);
        line.position = CGPointMake(SCREEN_WIDTH / 2, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height + FIELD_HEIGHT / 2);
        line.borderWidth = 1.f;
        line.borderColor = LINE_COLOR.CGColor;
        [self.view.layer addSublayer:line];
    }
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    {
        UIImage* img = IMGRESOURCE(@"content_close");
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setLeftBtnImg:"];
        [cmd performWithResult:&img];
    }
    
    return nil;
}

#pragma mark -- commands
- (id)leftBtnSelected {
    id<AYCommand> cmd = POPSPLIT;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    // TODO : reset search filter conditions
    return nil;
}
@end
