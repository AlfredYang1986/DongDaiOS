//
//  AYInputNapDescController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalDescController.h"
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

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   88

@implementation AYPersonalDescController {
    UITextView *inputTitleTextView;
    UILabel *countlabel;
    NSString *setedTitleString;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSString *str = [dic objectForKey:kAYControllerChangeArgsKey];
        if (str) {
            setedTitleString = str;
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
    
    inputTitleTextView = [[UITextView alloc]init];
    [self.view addSubview:inputTitleTextView];
    if (setedTitleString) {
        inputTitleTextView.text = setedTitleString;
    }
    inputTitleTextView.font = [UIFont systemFontOfSize:14.f];
    inputTitleTextView.textColor = [Tools blackColor];
    inputTitleTextView.delegate = self;
    [inputTitleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 200));
    }];
    
    countlabel = [[UILabel alloc]init];
    countlabel = [Tools setLabelWith:countlabel andText:[NSString stringWithFormat:@"还可以输入%lu个字符",LIMITNUMB - setedTitleString.length] andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inputTitleTextView.mas_bottom).offset(-10);
        make.right.equalTo(inputTitleTextView).offset(-10);
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
    
    NSString *title = @"关于我";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
    if (count > LIMITNUMB) {
        inputTitleTextView.text = [textView.text substringToIndex:LIMITNUMB];
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
    [dic setValue:inputTitleTextView.text forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [inputTitleTextView resignFirstResponder];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
