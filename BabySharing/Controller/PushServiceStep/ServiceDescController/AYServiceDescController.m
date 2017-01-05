//
//  AYInputNapDescController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceDescController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   200

@implementation AYServiceDescController {
    UITextView *descTextView;
    UILabel *countlabel;
    NSString *setedStr;
	UIView *tapView;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSString *str = [dic objectForKey:kAYControllerChangeArgsKey];
        if (str) {
            setedStr = str;
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
    
    descTextView = [[UITextView alloc]init];
    [self.view addSubview:descTextView];
    if (setedStr) {
        descTextView.text = setedStr;
    }
    descTextView.font = [UIFont systemFontOfSize:14.f];
    descTextView.textColor = [Tools blackColor];
	descTextView.scrollEnabled = NO;
    descTextView.delegate = self;
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 200));
		make.width.mas_equalTo(SCREEN_WIDTH - 40);
		make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    countlabel = [[UILabel alloc]init];
    countlabel = [Tools setLabelWith:countlabel andText:[NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB - (int)setedStr.length] andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTextView.mas_bottom).offset(25);
        make.right.equalTo(descTextView).offset(-10);
    }];
	
	
	tapView = [[UIView alloc]init];
	[self.view addSubview:tapView];
	[tapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
	[tapView addGestureRecognizer:tap];
	tapView.alpha = 0;
	
	UIView *statusView = [self.views objectForKey:@"FakeStatusBar"];
	UIView *navView = [self.views objectForKey:kAYFakeNavBarView];
	[self.view bringSubviewToFront:statusView];
	[self.view bringSubviewToFront:navView];
	
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
	
	if ([descTextView isFirstResponder]) {
		[descTextView resignFirstResponder];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [descTextView becomeFirstResponder];
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
    
    NSString *title = @"服务描述";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
    if (count > LIMITNUMB) {
        descTextView.text = [textView.text substringToIndex:LIMITNUMB];
    }
    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count)>=0?(LIMITNUMB - count):0];
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
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:descTextView.text forKey:@"content"];
    [dic_info setValue:@"nap_desc" forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [descTextView resignFirstResponder];
    return nil;
}
#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	tapView.alpha = 0.5;
//	descTextView.userInteractionEnabled = NO;
//	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
//	[UIView animateWithDuration:0.25 animations:^{
//		
//	}];
	
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	tapView.alpha = 0;
//	descTextView.userInteractionEnabled = YES;
//	[UIView animateWithDuration:0.25 animations:^{
//		
//	}];
	return nil;
}
@end
