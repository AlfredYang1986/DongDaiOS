//
//  AYProfilePushCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfilePushCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYProfilePushCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTitle;

@end

@implementation AYProfilePushCellView

@synthesize imageView = _imageView;

+ (CGFloat)preferedHeight {
    return 80;
}

- (void)awakeFromNib {
    // Initialization code
    
    _photoImage.layer.cornerRadius = 3.f;
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderImgSelected:)];
//    [_imgView addGestureRecognizer:tap];
    
//    CALayer* line = [CALayer layer];
//    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
//    line.borderWidth = 1.f;
//    line.frame = CGRectMake(10.5, 80 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2, 1);
//    [self.layer addSublayer:line];
    
    [self setUpReuseCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

//- (void)setUserImage:(NSString*)photo_name {
//    
//    [self.imgView setImage:PNGRESOURCE(@"default_user")];
//    
//    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:photo_name forKey:@"image"];
//    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        UIImage* img = (UIImage*)result;
//        [self.imgView setImage:img];
//    }];
//}

//- (void)UIImageView:(UIImageView*)imgView setPostImage:(NSString*)photo_name {
//    [imgView setImage:PNGRESOURCE(@"default_user")];
//    
//    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:photo_name forKey:@"image"];
//    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        UIImage* img = (UIImage*)result;
//        if (img != nil) {
//            [imgView setImage:img];
//        }
//    }];
//}


@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYNotificationCellName, kAYNotificationCellName);
    
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

#pragma mark -- messages
- (id)queryCellHeight {
    return [NSNumber numberWithFloat:80.f];
}

- (id)setCellInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    
    return nil;
}

@end

