//
//  AYSelfSettingView.m
//  BabySharing
//
//  Created by Alfred Yang on 7/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSelfSettingView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewController.h"
#import "Tools.h"

@implementation AYSelfSettingView{
    UITextField *user_name;
    UITextField *address;
    UILabel *boby;
    UILabel *registTime;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    UILabel *nameLabel = [[UILabel alloc]init];
    [self addSubview:nameLabel];
    nameLabel = [Tools setLabelWith:nameLabel andText:@"姓名" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(15);
    }];
    
    user_name = [[UITextField alloc]init];
    [self addSubview:user_name];
    user_name.text = @"姓名";
    user_name.clearButtonMode = UITextFieldViewModeWhileEditing;
    user_name.placeholder = @"请输入姓名";
    user_name.font = [UIFont systemFontOfSize:14.f];
    user_name.textColor = [Tools blackColor];
    [user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(self).offset(90);
        make.right.equalTo(self);
    }];
    
    UIView *line01 = [[UIView alloc]init];
    [self addSubview:line01];
    line01.backgroundColor = [UIColor lightGrayColor];
    [line01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
    
    UILabel *addressLabel = [[UILabel alloc]init];
    [self addSubview:addressLabel];
    addressLabel = [Tools setLabelWith:addressLabel andText:@"所在城市" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line01.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
    }];
    
    address = [[UITextField alloc]init];
    [self addSubview:address];
    address.text = @"北京市朝阳区";
    address.clearButtonMode = UITextFieldViewModeWhileEditing;
    address.placeholder = @"请输入地址";
    address.font = [UIFont systemFontOfSize:14.f];
    address.textColor = [Tools blackColor];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressLabel);
        make.left.equalTo(user_name);
        make.right.equalTo(self);
    }];
    
    UIView *line02 = [[UIView alloc]init];
    [self addSubview:line02];
    line02.backgroundColor = [UIColor lightGrayColor];
    [line02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
    
    UILabel *bobyLabel = [[UILabel alloc]init];
    [self addSubview:bobyLabel];
    bobyLabel = [Tools setLabelWith:bobyLabel andText:@"宝宝信息" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [bobyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line02.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(14);
    }];
    
    boby = [[UILabel alloc]init];
    [self addSubview:boby];
    boby = [Tools setLabelWith:boby andText:@"2岁9个月男宝宝，2岁9个月男宝宝，2岁9个月男宝宝" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    boby.numberOfLines = 0;
    [boby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bobyLabel);
        make.left.equalTo(self).offset(90);
        make.right.equalTo(self).offset(-50);
    }];
    boby.userInteractionEnabled = YES;
    [boby addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bobySet:)]];
    
    UIImageView *nextIcon = [[UIImageView alloc]init];
    [self addSubview:nextIcon];
    nextIcon.image = IMGRESOURCE(@"chan_group_back");
    [nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bobyLabel);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    nextIcon.userInteractionEnabled = YES;
    [nextIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bobySet:)]];
    
    UIView *line03 = [[UIView alloc]init];
    [self addSubview:line03];
    line03.backgroundColor = [UIColor lightGrayColor];
    [line03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boby.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/

    UILabel *timeLabel = [[UILabel alloc]init];
    [self addSubview:timeLabel];
    timeLabel = [Tools setLabelWith:timeLabel andText:@"注册时间" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line03.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
    }];
    
    registTime = [[UILabel alloc]init];
    [self addSubview:registTime];
    registTime = [Tools setLabelWith:registTime andText:@"2016.6.12" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [registTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(self).offset(90);
    }];
    
    UIView *line04 = [[UIView alloc]init];
    [self addSubview:line04];
    line04.backgroundColor = [UIColor lightGrayColor];
    [line04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
-(void)bobySet:(UIGestureRecognizer*)tap{
    NSLog(@"BabyInfo view controller");
    id<AYCommand> setting = DEFAULTCONTROLLER(@"BabyInfo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)hideKeyboard {
    if ([user_name isFirstResponder]) {
        [user_name resignFirstResponder];
    }
    if ([address isFirstResponder]) {
        [address resignFirstResponder];
    }
    return nil;
}
@end
