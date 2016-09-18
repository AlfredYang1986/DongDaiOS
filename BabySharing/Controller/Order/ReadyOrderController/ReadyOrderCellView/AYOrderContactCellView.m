//
//  AYOrderContactCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderContactCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYOrderContactCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNo;

@end

@implementation AYOrderContactCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.backgroundColor = [Tools garyLineColor].CGColor;
    line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    [self.layer addSublayer:line_separator];
    
    _userPhotoImage.layer.cornerRadius = 25.f;
    _userPhotoImage.clipsToBounds = YES;
    
//    _contactBtn.layer.cornerRadius = 2.f;
//    _contactBtn.clipsToBounds = YES;
//    _contactBtn.layer.borderColor = [Tools themeColor].CGColor;
//    _contactBtn.layer.borderWidth = 1.f;
    
    // Initialization code
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderContactCell", @"OrderContactCell");
    
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

- (IBAction)didContactBtnClick:(id)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didContactBtnClick"];
    [cmd performWithResult:nil];
}

- (id)setCellInfo:(NSDictionary*)args {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    NSString *user_id = [info objectForKey:@"user_id"];
    NSString *order_user_id = [args objectForKey:@"user_id"];
    NSString *order_owner_id = [args objectForKey:@"owner_id"];
    
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    
    if ([user_id isEqualToString:order_owner_id]) {     //我发的服务
        [dic_owner_id setValue:order_user_id forKey:@"user_id"];
    } else {
        [dic_owner_id setValue:order_owner_id forKey:@"user_id"];
    }
    
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        _userNameLabel.text = [result objectForKey:@"screen_name"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[result objectForKey:@"screen_photo"] forKey:@"image"];
        [dic setValue:@"img_icon" forKey:@"expect_size"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* img = (UIImage*)result;
            if (img != nil) {
                [_userPhotoImage setImage:img];
            } else
                _userPhotoImage.image = IMGRESOURCE(@"default_user");
        }];
    }];
    
    
    return nil;
}
@end
