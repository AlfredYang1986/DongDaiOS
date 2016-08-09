//
//  AYSetNapAgesController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapAgesController.h"
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

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y               SCREEN_HEIGHT - 196

@interface AYSetNapAgesController ()<UITextViewDelegate>

@end

@implementation AYSetNapAgesController{
    UITextView *inputTitleTextView;
    UILabel *countlabel;
    NSDictionary *setedAgesData;
    
    UIView *picker;
    
    NSNumber *usl;
    NSNumber *lsl;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *str = [dic objectForKey:kAYControllerChangeArgsKey];
        if (str) {
            setedAgesData = str;
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor clearColor];
    [cmd_nav performWithResult:&c_nav];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"SetNapAges"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
    UILabel *h1 = [[UILabel alloc]init];
    h1 = [Tools setLabelWith:h1 andText:@"希望看护的包包年龄段" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(124);
        make.centerX.equalTo(self.view);
    }];
    
    countlabel = [[UILabel alloc]init];
    countlabel = [Tools setLabelWith:countlabel andText:@"3 — 11岁" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    if (setedAgesData) {
        NSNumber *usl_numb = ((NSNumber *)[setedAgesData objectForKey:@"usl"]);
        NSNumber *lsl_numb = ((NSNumber *)[setedAgesData objectForKey:@"lsl"]);
        NSString *ages = [NSString stringWithFormat:@"%d  —  %d 岁", usl_numb.intValue, lsl_numb.intValue];
//        NSString *args01 = [NSString stringWithFormat:@"%d - %d",usl_numb.intValue, lsl_numb.intValue ];
        countlabel.text = ages;
    }
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(h1.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    countlabel.userInteractionEnabled = YES;
    [countlabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNapBabyAgesClick:)]];
    
    UILabel *hb = [[UILabel alloc]init];
    hb = [Tools setLabelWith:hb andText:@"大的年龄跨度能让您更多的可能接到宝宝哦 ~._.~" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:hb];
    [hb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countlabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [inputTitleTextView becomeFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"保存" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"看护宝宝年龄段";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2 + 20);
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}


-(void)setNapBabyAgesClick:(UIGestureRecognizer*)tap{
    if (picker.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
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
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *sl_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [sl_dic setValue:usl forKey:@"usl"];
    [sl_dic setValue:lsl forKey:@"lsl"];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:sl_dic forKey:@"content"];
    [dic_info setValue:@"nap_ages" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [inputTitleTextView resignFirstResponder];
    //    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您修改的信息已提交$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

-(id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"SetNapAges"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSDictionary *dic = nil;
    [cmd_index performWithResult:&dic];
    
    if (dic) {
        usl = ((NSNumber *)[dic objectForKey:@"usl"]);
        lsl = ((NSNumber *)[dic objectForKey:@"lsl"]);
        NSString *ages = [NSString stringWithFormat:@"%d  —  %d 岁",usl.intValue,lsl.intValue];
        countlabel.text = ages;
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

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
