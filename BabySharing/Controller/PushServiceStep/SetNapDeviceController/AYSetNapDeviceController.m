//
//  AYSetNapDeviceController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapDeviceController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"

#import "OptionOfPlayingView.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   228

@implementation AYSetNapDeviceController {
    
    NSString *customString;
    
    UITextField *customField;
//    NSMutableArray *optionsData;
    long notePow;
    CGFloat setY;
    
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_facility = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_facility) {
            customString = [dic_facility objectForKey:@"option_custom"];
            notePow = ((NSNumber*)[dic_facility objectForKey:@"facility"]).longValue;
            
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetNapCost"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&class_name];
    
    
    id<AYCommand> cmd_query = [cmd_notify.commands objectForKey:@"queryData:"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (notePow) {
        NSNumber *numb = [NSNumber numberWithLong:notePow];
        [dic setValue:numb forKey:@"options"];
    }
    if (customString) {
        [dic setValue:customString forKey:@"custom"];
    }
    [cmd_query performWithResult:&dic];
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
//    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"场地友好性及设施";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 20.f;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
//    if ([customField isFirstResponder]) {
//        [customField resignFirstResponder];
//    }
}

-(id)didOptionBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        notePow += pow(2, btn.tag);
    }else {
        notePow -= pow(2, btn.tag);
    }
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    
    if (notePow == 0) {
        
        NSString *title = @"您还没有添加友好设施";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:[NSNumber numberWithLong:notePow] forKey:@"facility"];
    [dic_info setValue:customString forKey:@"option_custom"];
    [dic_info setValue:@"nap_device" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
//    if ([customField isFirstResponder]) {
//        [customField resignFirstResponder];
//    }
    return nil;
}

-(id)textChange:(NSString*)text {
    customString = text;
    return nil;
}

@end
