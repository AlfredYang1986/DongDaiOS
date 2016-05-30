//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputRoleView.h"
#import "AYCommandDefines.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "Tools.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"

#import "FoundHotTagBtn.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TAG_MARGIN              20

@interface RoleBtn : UIButton
@property(nonatomic, strong) NSString *roleString;
@end

@implementation RoleBtn

@synthesize roleString = _roleString;

@end

@implementation AYLandingInputRoleView {
    
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UIView  *inputView;
    UITextField *role_area;
    UIButton *othersRoleBtn;
    
    NSArray *queryRoleData;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    input_tips = [[UILabel alloc]init];
    input_tips.font = [UIFont systemFontOfSize:14.f];
    input_tips.textColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f];
    input_tips.textAlignment = NSTextAlignmentLeft;
    input_tips.text = @"说说你是谁？";
    [self addSubview:input_tips];
    [input_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    /* 输入role */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    [inputView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputView.layer.cornerRadius = 6.f;
    inputView.clipsToBounds = YES;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input_tips.mas_bottom).offset(15);
        make.left.equalTo(input_tips);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel* name_icon = [[UILabel alloc]init];
    [inputView addSubview:name_icon];
    name_icon.text = @"角色";
    [name_icon sizeToFit];
    name_icon.font = [UIFont systemFontOfSize:14.f];
    name_icon.textColor = [Tools themeColor];
    [name_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(inputView).offset(19);
        make.width.mas_equalTo(name_icon.bounds.size.width);
    }];
    
    UIImageView* rules2 = [[UIImageView alloc]init];
    [inputView addSubview:rules2];
    rules2.image = PNGRESOURCE(@"rules_themecolor");
    [rules2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name_icon.mas_right).offset(19);
        make.centerY.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    role_area = [[UITextField alloc]init];
    [self addSubview:role_area];
    role_area.backgroundColor = [UIColor clearColor];
    role_area.font = [UIFont systemFontOfSize:14.f];
    role_area.placeholder = @"";
    [role_area setValue:[Tools themeColor] forKeyPath:@"_placeholderLabel.textColor"];
    role_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    role_area.keyboardType = UIKeyboardTypeNumberPad;
    role_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [role_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rules2.mas_right).offset(5);
        make.centerY.equalTo(inputView);
        make.right.equalTo(inputView);
        make.height.mas_equalTo(40);
    }];
    
    CGRect frame = role_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    role_area.leftViewMode = UITextFieldViewModeAlways;
    role_area.leftView = leftview;
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, role_area.frame.size.height)];
    clear_btn.center = CGPointMake(role_area.frame.size.width - 25 / 2, role_area.frame.size.height / 2);
    [role_area addSubview:clear_btn];
    
    /*  */
    othersRoleBtn = [[UIButton alloc]init];
    [othersRoleBtn setTitle:@"看看大家怎么说？" forState:UIControlStateNormal];
    [othersRoleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [othersRoleBtn setBackgroundColor:[UIColor clearColor]];
    othersRoleBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    
    CALayer *bottom_line = [CALayer layer];
    bottom_line.frame = CGRectMake(3, 22, 88, 1);
    bottom_line.borderWidth = 0.5;
    bottom_line.borderColor = [UIColor whiteColor].CGColor;
    [othersRoleBtn.layer addSublayer:bottom_line];
    
    [othersRoleBtn addTarget:self action:@selector(lookingOtherRole:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:othersRoleBtn];
    [othersRoleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(18);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 24));
    }];
    
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

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- handle
-(void)lookingOtherRole:(UIButton*)sender{
    
    CGFloat offset = 0;
    CGFloat preTagWidth = 0;
    CGFloat index = 0;
    for (NSString* tmp in queryRoleData) {
        
        UIFont* font = [UIFont systemFontOfSize:12.f];
        CGSize sz_font = [Tools sizeWithString:tmp withFont:font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake( sz_font.width + 20 , 20);
        
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]init];
        btn.tag_name = tmp;
        btn.alpha = 0;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roleTagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        
        if (index == 0) {
            offset += preTagWidth;
        }else offset += TAG_MARGIN + preTagWidth;
        
        if ((offset + sz.width) > [UIScreen mainScreen].bounds.size.width - 86)
            break;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2*index * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self addSubview:btn];
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.left.equalTo(self).offset(offset);
                make.width.mas_equalTo(sz.width);
                make.height.mas_equalTo(sz.height);
            }];
            [UIView animateWithDuration:0.5 animations:^{
                btn.alpha = 1;
            }];
        });
        
        UIImage *bg = [UIImage imageNamed:@"login_role_bg2"];
        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, sz.width, sz.height)];
        bgView.image = bg;
        [btn addSubview:bgView];
        [btn sendSubviewToBack:bgView];
        
        preTagWidth = sz.width;
        
        UILabel* label = [[UILabel alloc] init];
        [btn addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(12);
            make.right.equalTo(btn).offset(-6);
        }];
        
        label.font = font;
        label.text = tmp;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        index++;
    }
    
    
}

-(void)roleTagBtnSelected:(UITapGestureRecognizer*)tap{
    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
    NSString* role_tag = tmp.tag_name;
    role_area.text = role_tag;
}

- (void)phoneTextFieldChanged:(UITextField*)tf {

    if (![role_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
    } else {
        clear_btn.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == role_area && role_area.text.length >= 4 && ![string isEqualToString:@""]) return NO;
//    else
        return YES;
}


#pragma mark -- view commands
- (id)hideKeyboard {
    if ([role_area isFirstResponder]) {
        [role_area resignFirstResponder];
    }
    return nil;
}

-(id)queryInputRole:(NSString*)args{
    return role_area.text;
}

-(id)changeQueryData:(id)args{
    queryRoleData = (NSArray*)args;
    return nil;
}

@end
