//
//  AYSetNapOptionsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapOptionsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYSetNapOptionsCellView {
    
    UILabel *titleLabel;
    UIButton *optionBtn;
    int index;
    UITextField *customField;
    
    NSDictionary *service;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        self.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
        }];
        
        optionBtn = [[UIButton alloc]init];
        [self addSubview:optionBtn];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
        [optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        CALayer *btm_line = [[CALayer alloc]init];
        btm_line.frame = CGRectMake(0, 44.5, SCREEN_WIDTH - 40, 0.5);
        btm_line.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_line];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetNapOptionsCell", @"SetNapOptionsCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
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
-(void)didOptionBtnClick:(UIButton*)btn {
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionBtnClick:"];
    [cmd performWithResult:&btn];
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
    
    NSNumber *options = [args objectForKey:@"options"];
    
    NSInteger index_tag = ((NSNumber*)[args objectForKey:@"index"]).integerValue;
    optionBtn.tag = index_tag;
    
    NSInteger notePow = options.integerValue;
    optionBtn.selected = ((notePow & (long)pow(2, index_tag)) != 0);
    
    titleLabel.text = [args objectForKey:@"title"];
    
    return nil;
}

//- (id)setCellInfo:(NSDictionary*)args {
//    
//    BOOL isCustom = [args objectForKey:@"isCustom"];
//    NSDictionary *options = [args objectForKey:@"options"];
//    
//    NSInteger index_tag = ((NSNumber*)[args objectForKey:@"index"]).integerValue;
//    
//    BOOL isShow = ((NSNumber*)[options objectForKey:@"isShow"]).boolValue;
//    if (isCustom) {
//        customField = [[UITextField alloc]init];
//        [self addSubview:customField];
//        NSString *customString = [options objectForKey:@"custom"];
//        if (customString) {
//            customField.text = customString;
//        }
//        customField.textColor = [Tools blackColor];
//        customField.font = [UIFont systemFontOfSize:14.f];
//        customField.backgroundColor = [UIColor whiteColor];
//        customField.layer.cornerRadius = 4.f;
//        customField.clipsToBounds = YES;
//        customField.delegate = self;
//        UILabel*paddingView= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
//        paddingView.backgroundColor= [UIColor clearColor];
//        customField.leftView = paddingView;
//        customField.leftViewMode = UITextFieldViewModeAlways;
//        customField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        if (isShow) {
//            customField.enabled = NO;
//        }
//        [customField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.left.equalTo(self).offset(80);
//            make.right.equalTo(self).offset(-15);
//            make.height.mas_equalTo(30);
//        }];
//        
//    } else {
//        
//        if (isShow) {
//            optionBtn.userInteractionEnabled = NO;
//        }
//        optionBtn.tag = index_tag;
//        NSInteger notePow = ((NSNumber*)[options objectForKey:@"option"]).integerValue;
//        optionBtn.selected = ((notePow & (long)pow(2, index_tag)) != 0);
//    }
//    titleLabel.text = [[options objectForKey:@"title"] objectAtIndex:index_tag];
//    
//    return nil;
//}
#pragma mark -- UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    id<AYCommand> cmd_textchange = [self.notifies objectForKey:@"textChange:"];
//    NSString *text = textField.text;
//    [cmd_textchange performWithResult:&text];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    id<AYCommand> cmd_textchange = [self.notifies objectForKey:@"textChange:"];
    NSString *text = textField.text;
    text = [text stringByAppendingString:string];
    [cmd_textchange performWithResult:&text];
    return YES;
}

- (id)queryCustom:(NSString*)args {
    return customField.text;
}
@end
