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
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		
        titleLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25);
            make.centerY.equalTo(self);
        }];
        
        optionBtn = [[UIButton alloc]init];
        [self addSubview:optionBtn];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
        [optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
		
		CGFloat margin = 20.f;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 63.5, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
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
	btn.selected = !btn.selected;
	
	NSString *titleStr = titleLabel.text;
    id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionBtnClick:"];
    [cmd performWithResult:&titleStr];
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
    
    NSArray *options = [args objectForKey:@"options"];
	NSString *titleStr = [args objectForKey:@"title"];
	
    titleLabel.text = titleStr;
	optionBtn.selected = [options containsObject:titleStr];
	
    return nil;
}

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
