//
//  AYOtherNoticeTextController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOtherNoticeTextController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYServiceArgsDefines.h"

#define LIMITNUMB                   88

@implementation AYOtherNoticeTextController {
    UITextView *descTextView;
    UILabel *countlabel;
    NSString *setedStr;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        setedStr = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    descTextView = [[UITextView alloc]init];
    [self.view addSubview:descTextView];
    if (setedStr) {
        descTextView.text = setedStr;
    }
    descTextView.font = [UIFont systemFontOfSize:14.f];
    descTextView.textColor = [Tools blackColor];
    descTextView.delegate = self;
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 200));
    }];
    
    countlabel = [[UILabel alloc]init];
    countlabel = [Tools setLabelWith:countlabel andText:[NSString stringWithFormat:@"还可以输入%lu个字符",LIMITNUMB - setedStr.length] andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(descTextView.mas_bottom).offset(-10);
        make.right.equalTo(descTextView).offset(-10);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [descTextView becomeFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    NSString *title = @"其他守则";
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
    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count) >= 0 ? (LIMITNUMB - count) : 0];
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
    [dic_info setValue:descTextView.text forKey:kAYServiceArgsNotice];
    [dic_info setValue:kAYServiceArgsNotice forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [descTextView resignFirstResponder];
    return nil;
}

@end
