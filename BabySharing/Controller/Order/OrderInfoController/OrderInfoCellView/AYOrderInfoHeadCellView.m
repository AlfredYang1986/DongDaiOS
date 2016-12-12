//
//  AYOrderInfoHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#define kOwnerPhotoWH           50

@implementation AYOrderInfoHeadCellView {
    
    UIImageView *ownerPhoto;
    UILabel *titleLabel;
    UILabel *ownerNameLabel;
    
    NSDictionary *service;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        
        titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"爱画画的插画师妈妈" andTextColor:[Tools blackColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:0];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(15);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-65);
        }];
        
        ownerNameLabel = [[UILabel alloc]init];
        ownerNameLabel = [Tools setLabelWith:ownerNameLabel andText:@"服务妈妈" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:ownerNameLabel];
        [ownerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(17);
            make.left.equalTo(titleLabel);
        }];
        
        /**
         <#Description#>
         */
        
        ownerPhoto = [[UIImageView alloc]init];
        ownerPhoto.image = IMGRESOURCE(@"default_user");
        ownerPhoto.layer.cornerRadius = kOwnerPhotoWH * 0.5;
        ownerPhoto.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
        ownerPhoto.layer.borderWidth = 2.f;
        ownerPhoto.clipsToBounds = YES;
        [self addSubview:ownerPhoto];
        [ownerPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ownerNameLabel);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(kOwnerPhotoWH, kOwnerPhotoWH));
        }];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderInfoHeadCell", @"OrderInfoHeadCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args{
//    NSDictionary *args = [dic_args objectForKey:@"service"];
    
    NSString *user_name = [args objectForKey:@"screen_name"];
    ownerNameLabel.text = [NSString stringWithFormat:@"%@", user_name];
    
    NSString *photo_name = [args objectForKey:@"screen_photo"];
    if (photo_name) {
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        NSString *pre = cmd.route;
        [ownerPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                      placeholderImage:IMGRESOURCE(@"default_user")];
    } else {
        
        ownerPhoto.image = IMGRESOURCE(@"default_user");
    }
    
    titleLabel.text = [args objectForKey:@"title"];
    return nil;
}

@end
