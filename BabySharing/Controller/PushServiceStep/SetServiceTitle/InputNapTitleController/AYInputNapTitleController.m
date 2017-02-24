//
//  AYInputNapTitleController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputNapTitleController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYInsetLabel.h"
#import "AYServiceArgsDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   18

@implementation AYInputNapTitleController {
    UITextView *inputTitleTextView;
	UILabel *placeHolder;
    UILabel *countlabel;
    UIImageView *access;
    UILabel *signLabel;
    
//    NSMutableDictionary *titleAndCourseSignInfo;
	NSString *setedTitleStr;
	
    BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        setedTitleStr = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
//        NSDictionary *args_info = [dic objectForKey:kAYControllerChangeArgsKey];
//        NSString *coustom = [args_info objectForKey:kAYServiceArgsCourseCoustom];
//        NSNumber *courseSignIndex = [args_info objectForKey:kAYServiceArgsCourseSign];
//        if (coustom) {
//            [titleAndCourseSignInfo setValue:coustom forKey:kAYServiceArgsCourseCoustom];
////            [titleAndCourseSignInfo removeObjectForKey:kAYServiceArgsCourseSign];
//			[titleAndCourseSignInfo setValue:@-1 forKey:kAYServiceArgsCourseSign];		//服务器默认返回-1，兼容设置-1
//        }
//        else if (courseSignIndex) {
//            [titleAndCourseSignInfo setValue:courseSignIndex forKey:kAYServiceArgsCourseSign];
//            [titleAndCourseSignInfo removeObjectForKey:kAYServiceArgsCourseCoustom];
//            coustom = [args_info objectForKey:@"signStr"];
//        }
//        
//        if (coustom && ![coustom isEqualToString:@""]) {
//            
//            access.hidden = YES;
//            signLabel.hidden = NO;
//            signLabel.text = coustom;
//            
//            if (!isAlreadyEnable) {
//                UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
//                kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//                isAlreadyEnable = YES;
//            }
//            
//        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"标题" andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    inputTitleTextView = [[UITextView alloc]init];
    [self.view addSubview:inputTitleTextView];
    inputTitleTextView.font = [UIFont systemFontOfSize:14.f];
    inputTitleTextView.textColor = [Tools blackColor];
    inputTitleTextView.delegate = self;
    [inputTitleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 90));
    }];
	placeHolder = [Tools creatUILabelWithText:@"一个有吸引力的标题" andTextColor:[Tools garyColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[inputTitleTextView addSubview:placeHolder];
	[placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputTitleTextView).offset(5);
		make.top.equalTo(inputTitleTextView).offset(8);
	}];
	
    countlabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB] andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inputTitleTextView.mas_bottom).offset(-10);
        make.right.equalTo(inputTitleTextView).offset(-10);
    }];
	
	if (setedTitleStr && ![setedTitleStr isEqualToString:@""]) {
		inputTitleTextView.text = setedTitleStr;
		countlabel.text = [NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB - (int)setedTitleStr.length];
		placeHolder.hidden = YES;
	}
	
//    NSString *setedTitleStr = [titleAndCourseSignInfo objectForKey:kAYServiceArgsTitle];
//    if (setedTitleStr) {
//        NSInteger count = setedTitleStr.length;
//        inputTitleTextView.text = setedTitleStr;
//        countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count) >= 0 ? (LIMITNUMB - count) : 0];
//    }
//    
//    ServiceType service_type = ((NSNumber*)[titleAndCourseSignInfo objectForKey:kAYServiceArgsServiceCat]).intValue;
//    switch (service_type) {
//        case ServiceTypeLookAfter:
//        {
//            
//            self.view.backgroundColor = [Tools whiteColor];
//        }
//            break;
//        case ServiceTypeCourse:
//        {
//            AYInsetLabel *courseSignLabel = [[AYInsetLabel alloc]initWithTitle:@"添加服务标签" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
//            courseSignLabel.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//            [self.view addSubview:courseSignLabel];
//            [courseSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(inputTitleTextView.mas_bottom).offset(20);
//                make.centerX.equalTo(self.view);
//                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 44));
//            }];
//            courseSignLabel.userInteractionEnabled = YES;
//            [courseSignLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCourseSignLabelTap)]];
//            
//            access = [[UIImageView alloc]init];
//            [self.view addSubview:access];
//            access.image = IMGRESOURCE(@"plan_time_icon");
//            [access mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(courseSignLabel.mas_right).offset(-15);
//                make.centerY.equalTo(courseSignLabel);
//                make.size.mas_equalTo(CGSizeMake(15, 15));
//            }];
//            
//            signLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
//            [self.view addSubview:signLabel];
//            [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(access);
//                make.centerY.equalTo(courseSignLabel);
//            }];
//            
//            //服务标签show
//            if (((NSNumber*)[titleAndCourseSignInfo objectForKey:kAYServiceArgsCourseCat]).intValue == -1) {
//                
//            } else {
//                
//                NSString* coustomStr = [titleAndCourseSignInfo objectForKey:kAYServiceArgsCourseCoustom];
//                if (coustomStr && ![coustomStr isEqualToString:@""]) {
//                    access.hidden = YES;
//                    signLabel.text = coustomStr;
//                } else {
//                    NSNumber* courseSign = [titleAndCourseSignInfo objectForKey:kAYServiceArgsCourseSign];
//                    if (courseSign) {
//                        NSNumber *type = [titleAndCourseSignInfo objectForKey:kAYServiceArgsCourseCat];
//                        NSArray *courseAllArr = kAY_service_course_title_ofall;
//                        NSArray *titleArr = [courseAllArr objectAtIndex:type.integerValue];
//                        
//                        if (courseSign.integerValue < titleArr.count) {
//                            NSString *courseTitle = [titleArr objectAtIndex:courseSign.integerValue];
//                            access.hidden = YES;
//                            signLabel.text = courseTitle;
//                        }
//                    } else {
//                        signLabel.hidden = YES;
//                    }
//                }
//            }
//            
//            
//        }
//            break;
//        default:
//            break;
//    }

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [inputTitleTextView becomeFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
//    NSString *title = @"标题";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
    bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
	placeHolder.hidden = count != 0;
    if (!isAlreadyEnable) {
        UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
        isAlreadyEnable = YES;
    }
    
    if (count > LIMITNUMB) {
        inputTitleTextView.text = [textView.text substringToIndex:LIMITNUMB];
    }
    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count)>=0?(LIMITNUMB - count):0];
}

#pragma mark -- actions
- (void)didCourseSignLabelTap {
    
//    if (((NSNumber*)[titleAndCourseSignInfo objectForKey:kAYServiceArgsCourseCat]).intValue == -1) {
//        kAYUIAlertView(@"提示", @"您需要重新设置服务主题，才能进行服务标签设置");
//        return;
//    }
//    
//    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetCourseSign");
//    
//    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
//    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    [dic_push setValue:titleAndCourseSignInfo forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = PUSH;
//    [cmd performWithResult:&dic_push];
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
    
    [inputTitleTextView resignFirstResponder];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:kAYServiceArgsTitle forKey:@"key"];
	
    if (![inputTitleTextView.text isEqualToString:@""]) {
        [tmp setValue:inputTitleTextView.text forKey:kAYServiceArgsTitle];
    }
    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
