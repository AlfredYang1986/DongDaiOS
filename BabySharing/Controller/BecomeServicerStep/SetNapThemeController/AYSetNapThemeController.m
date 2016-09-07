//
//  AYSetNapCostController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapThemeController.h"
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
#import "Tools.h"

#import "OptionOfPlayingView.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define LIMITNUMB                   228
#define kTableFrameY                64

@interface AYSetNapThemeController ()<UITextViewDelegate>

@end

@implementation AYSetNapThemeController {
    
    BOOL isAllowLeave;
    long notePow;
    BOOL isShow;
    
    CGFloat setY;
    UIButton *tmpNoteBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            isAllowLeave = ((NSNumber*)[dic_cost objectForKey:@"allow_leave"]).boolValue;
            notePow = ((NSNumber*)[dic_cost objectForKey:@"cans"]).longValue;
            
            isShow = ((NSNumber*)[dic_cost objectForKey:@"show"]).boolValue;
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
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetNapTheme"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&class_name];
    
    id<AYCommand> cmd_query = [cmd_notify.commands objectForKey:@"queryData:"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSNumber numberWithBool:isAllowLeave] forKey:@"allow_leave"];
    [dic setValue:[NSNumber numberWithBool:isShow] forKey:@"isShow"];
    if (notePow) {
        NSNumber *numb = [NSNumber numberWithLong:notePow];
        [dic setValue:numb forKey:@"nap_theme"];
    }
    
    [cmd_query performWithResult:&dic];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [costTextField becomeFirstResponder];
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"价格设置";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    if (isShow) {
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
        id right = [NSNumber numberWithBool:YES];
        [cmd_right performWithResult:&right];
        
    } else {
        UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        [bar_right_btn setTitle:@"保存" forState:UIControlStateNormal];
        bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
        [cmd_right performWithResult:&bar_right_btn];
    }
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 20.f;
    view.frame = CGRectMake(margin, kTableFrameY, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - kTableFrameY);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {

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
    //整合数据
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
    [dic_options setValue:[NSNumber numberWithLong:notePow] forKey:@"cans"];
    [dic_options setValue:[NSNumber numberWithBool:isAllowLeave] forKey:@"allow_leave"];
    [dic_options setValue:@"nap_theme" forKey:@"key"];
    [dic setValue:dic_options forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)didSetNoteBtn:(UIButton*)btn {
    tmpNoteBtn = btn;
    return nil;
}

- (id)didOptionBtnClick:(UIButton*)btn {
    
    btn.selected = !btn.selected;
    if (btn.tag != 99) {
        if (btn.selected) {
            notePow = pow(2, btn.tag);
        }else {
            notePow = 0;
        }
        
        if (tmpNoteBtn) {
            tmpNoteBtn.selected = NO;
        }
        tmpNoteBtn = tmpNoteBtn==btn?nil:btn;
        
    } else isAllowLeave = !isAllowLeave;
    
    return nil;
}

-(id)textChange:(NSString*)text {
    
    return nil;
}
@end
