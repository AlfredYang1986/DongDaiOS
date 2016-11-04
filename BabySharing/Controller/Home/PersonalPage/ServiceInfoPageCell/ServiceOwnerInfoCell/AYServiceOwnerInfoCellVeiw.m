//
//  AYServiceOwnerInfoCellVeiw.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceOwnerInfoCellVeiw.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceOwnerInfoCellVeiw {
    UIImageView *userPhoto;
    UILabel *userName;
    UILabel *adress;
    UILabel *description;
    
    UILabel *readMoreLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CALayer *btm_seprtor = [CALayer layer];
        btm_seprtor.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, 0.5);
        btm_seprtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_seprtor];
        
        userPhoto = [[UIImageView alloc]init];
        userPhoto.image = IMGRESOURCE(@"default_user");
        userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        userPhoto.clipsToBounds = YES;
        userPhoto.layer.cornerRadius = 30.f;
        userPhoto.layer.borderColor = [Tools borderAlphaColor].CGColor;
        userPhoto.layer.borderWidth = 2.f;
        [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        userPhoto.userInteractionEnabled = YES;
        [userPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didUserPhotoClick)]];
        
        userName = [Tools creatUILabelWithText:@"Name" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:userName];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userPhoto.mas_right).offset(10);
            make.bottom.equalTo(userPhoto.mas_centerY).offset(-4);
        }];
        
        adress = [Tools creatUILabelWithText:@"adress" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:adress];
        [adress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userName);
            make.top.equalTo(userPhoto.mas_centerY).offset(4);
        }];
        
        description = [Tools creatUILabelWithText:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:description];
        [description mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userPhoto.mas_bottom).offset(20);
            make.left.equalTo(userPhoto);
            make.right.equalTo(self).offset(-15);
        }];
        
        readMoreLabel.userInteractionEnabled = YES;
        [readMoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReadMoreClick)]];
        
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
    id<AYViewBase> cell = VIEW(@"NoOrderCell", @"NoOrderCell");
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


#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    return nil;
}

@end
