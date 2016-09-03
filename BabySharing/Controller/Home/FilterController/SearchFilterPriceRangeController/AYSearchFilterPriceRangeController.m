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

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y           SCREEN_HEIGHT - 196

#define STATUS_HEIGHT                       20
#define NAV_HEIGHT                          45

#define TEXT_COLOR                          [Tools blackColor]
#define LINE_COLOR                          [Tools blackColor]

#define CONTROLLER_MARGIN                   10.f

#define TEXT_FIELD_MARGIN_BETWEEN           40.f

#define FIELD_HEIGHT                        80

@implementation AYSearchFilterPriceRangeController {
    id dic_split_value;
    
    UIView *picker;
    NSNumber *usl;
    NSNumber *lsl;
    
    UILabel *uslLabel;
    UILabel *lslLabel;
    
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
    title.font = [UIFont systemFontOfSize:24.f];
    title.textColor = TEXT_COLOR;
    [title sizeToFit];
    title.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN, SCREEN_WIDTH - 2 * CONTROLLER_MARGIN, title.frame.size.height);
    [self.view addSubview:title];
    
//    {
//        UITextField* field = [[UITextField alloc]init];
//        field.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height, SCREEN_WIDTH / 2 - 2 * CONTROLLER_MARGIN - TEXT_FIELD_MARGIN_BETWEEN / 2, FIELD_HEIGHT);
//        field.textAlignment = NSTextAlignmentCenter;
//        field.placeholder = @"最低价格";
//        
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.frame = CGRectMake(0.0f, field.frame.size.height - 1, field.frame.size.width, 1.0f);
//        bottomBorder.backgroundColor = LINE_COLOR.CGColor;
//        [field.layer addSublayer:bottomBorder];
//        [self.view addSubview:field];
//    }
//   
//    {
//        UITextField* field = [[UITextField alloc]init];
//        field.frame = CGRectMake(CONTROLLER_MARGIN + SCREEN_WIDTH / 2 + TEXT_FIELD_MARGIN_BETWEEN / 2, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height, SCREEN_WIDTH / 2 - 2 * CONTROLLER_MARGIN - TEXT_FIELD_MARGIN_BETWEEN / 2, FIELD_HEIGHT);
//        field.textAlignment = NSTextAlignmentCenter;
//        field.placeholder = @"最高价格";
//        
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.frame = CGRectMake(0.0f, field.frame.size.height - 1, field.frame.size.width, 1.0f);
//        bottomBorder.backgroundColor = LINE_COLOR.CGColor;
//        [field.layer addSublayer:bottomBorder];
//        [self.view addSubview:field];
//    }
    
//    {
//        CALayer* line = [CALayer layer];
//        line.frame = CGRectMake(0, 0, 20, 1);
//        line.position = CGPointMake(SCREEN_WIDTH / 2, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height + FIELD_HEIGHT / 2);
//        line.borderWidth = 1.f;
//        line.borderColor = LINE_COLOR.CGColor;
//        [self.view.layer addSublayer:line];
//    }
    
    
    UIView *rangeSign = [[UIView alloc]init];
    rangeSign.backgroundColor = [Tools themeColor];
    [self.view addSubview:rangeSign];
    [rangeSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(190);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(20, 1));
    }];
    
    lslLabel = [[UILabel alloc]init];
    lslLabel = [Tools setLabelWith:lslLabel andText:@"预期价格范围" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lslLabel];
    [lslLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rangeSign);
        make.right.equalTo(rangeSign.mas_left).offset(-50);
    }];
    
    uslLabel = [[UILabel alloc]init];
    uslLabel = [Tools setLabelWith:uslLabel andText:@"预期价格范围" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:uslLabel];
    [uslLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rangeSign);
        make.left.equalTo(rangeSign.mas_right).offset(50);
    }];
    
    uslLabel.userInteractionEnabled = YES;
    [uslLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNapBabyAgesClick:)]];
    lslLabel.userInteractionEnabled = YES;
    [lslLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNapBabyAgesClick:)]];
    
    /**
     * 保存按钮
     */
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(10, SCREEN_HEIGHT - 10 - 45, SCREEN_WIDTH - 2 * 10, 45);
    btn.backgroundColor = [Tools themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:4.f];
    [btn addTarget:self action:@selector(saveBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"SearchFilterPriceRange"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
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

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

#pragma mark -- actions
-(void)setNapBabyAgesClick:(UIGestureRecognizer*)tap{
    if (picker.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
}

- (void)saveBtnSelected {
    
    id<AYCommand> cmd = POPSPLIT;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *sl_dic = [[NSMutableDictionary alloc]init];
    if (usl && lsl) {
        [sl_dic setValue:usl forKey:@"usl"];
        [sl_dic setValue:lsl forKey:@"lsl"];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"错误" message:@"设置错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return ;
    }
    
    [dic setValue:sl_dic forKey:kAYControllerChangeArgsKey];
    [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
    
    [cmd performWithResult:&dic];
    
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

-(id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"SearchFilterPriceRange"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSDictionary *dic = nil;
    [cmd_index performWithResult:&dic];
    
    if (dic) {
        usl = ((NSNumber *)[dic objectForKey:@"usl"]);
        lsl = ((NSNumber *)[dic objectForKey:@"lsl"]);
        
        NSString *uslStr = [NSString stringWithFormat:@"%d元",usl.intValue];
        NSString *lslStr = [NSString stringWithFormat:@"%d元",lsl.intValue];
        
        uslLabel.text = uslStr;
        lslLabel.text = lslStr;
    }
    
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}
-(id)didCancelClick {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}
@end
