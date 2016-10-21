//
//  AYHomeTipCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeTipCellView.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagEnumDefines.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"
#import "AppDelegate.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYThumbsAndPushDefines.h"

#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

@implementation AYHomeTipCellView {
    
    UIImageView *headImage;
    UILabel *titleLabel;
    
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
        
//        AYModelFacade* f = LOGINMODEL;
//        CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
//        NSString *name = tmp.who.screen_name;
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH"];
        NSTimeZone* localzone = [NSTimeZone defaultTimeZone];
        [format setTimeZone:localzone];
        NSString *dateStr = [format stringFromDate:nowDate];
        
        NSString *on = nil;
        int timeSpan = dateStr.intValue;
        if (timeSpan >= 6 && timeSpan < 12) {
            on = @"上午好";
        } else if (timeSpan >= 12 && timeSpan < 18) {
            on = @"下午好";
        } else if((timeSpan >= 18 && timeSpan < 24) || (timeSpan >= 0 && timeSpan < 6)){
            on = @"晚上好";
        } else {
            on = @"获取系统时间错误";
        }
        
//        long onTimeSpan = ((long)now /*+ 86400/3*/) % 86400;
//        if (onTimeSpan < 86400 * 0.25) {
//            on = @"上午好";
//        } else if (onTimeSpan < 86400 * 0.5) {
//            on = @"下午好";
//        } else {
//            on = @"晚上好";
//        }
        
        UILabel *hello = [[UILabel alloc]init];
        hello = [Tools setLabelWith:hello andText:on andTextColor:[Tools blackColor] andFontSize:30.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
//        hello.font = [UIFont systemFontOfSize:30.f weight:-0.5];
        hello.font = kAYFontLight(30.f);
//        hello.font = [UIFont systemFontOfSize:16.f];
//        hello.textColor = [UIColor blackColor];
//        NSString *subName = [name substringFromIndex:name.length - 1];
//        NSMutableAttributedString *helloString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@，你好",subName]];
//        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:43.f],NSForegroundColorAttributeName:[Tools themeColor]};
//        [helloString setAttributes:dic range:NSMakeRange(0, subName.length)];
//        hello.attributedText = helloString;
        
        [self addSubview:hello];
        [hello mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(35+35);
        }];
        
        UILabel *say = [[UILabel alloc]init];
        say.text = @"为您的孩子找个好去处";
        say.font = kAYFontLight(24.f);
        say.numberOfLines = 0;
        say.textColor = [Tools blackColor];
        [self addSubview:say];
        [say mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hello);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(hello.mas_bottom).offset(10);
        }];
        
//        UIButton *personal = [[UIButton alloc]init];
//        [personal setTitle:@"我的订单" forState:UIControlStateNormal];
//        personal.backgroundColor = [Tools themeColor];
//        [self addSubview:personal];
//        [personal mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-20);
//            make.left.equalTo(self).offset(20);
//            make.right.equalTo(self).offset(-20);
//            make.height.mas_equalTo(44);
//        }];
//        [personal addTarget:self action:@selector(didPushInfo) forControlEvents:UIControlEventTouchUpInside];
        
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
    id<AYViewBase> cell = VIEW(@"HomeTipCell", @"HomeTipCell");
    
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

-(void)didPushInfo{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didPushInfo"];
    [cmd performWithResult:nil];
}

-(void)foundBtnClick{
    id<AYCommand> cmd = [self.notifies objectForKey:@"foundBtnClick"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args{
    NSDictionary *args = [dic_args objectForKey:@"service"];
    
    NSString* photo_name = [[args objectForKey:@"images"] objectAtIndex:0];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_thum" forKey:@"expect_size"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            headImage.image = img;
        }else{
            [headImage setImage:IMGRESOURCE(@"sample_image")];
        }
    }];
    
    titleLabel.text = [args objectForKey:@"title"];
    
    return nil;
}

@end
