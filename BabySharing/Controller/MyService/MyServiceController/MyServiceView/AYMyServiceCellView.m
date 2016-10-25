//
//  AYCollectServCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMyServiceCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#import "QueryContent.h"
#import "QueryContentItem.h"

@interface AYMyServiceCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIButton *manageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerIconImage;
@end

@implementation AYMyServiceCellView {
    
    NSDictionary *service_info;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _ownerIconImage.layer.cornerRadius = 20.f;
    _ownerIconImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _ownerIconImage.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _ownerIconImage.layer.borderWidth = 2.f;
    _ownerIconImage.clipsToBounds = YES;
    
    _mainImage.contentMode = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds = YES;
    
    _manageBtn.layer.cornerRadius = 4.f;
    _manageBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _manageBtn.clipsToBounds = YES;
    
    _manageBtn.hidden = YES;
    
    //产品逻辑：用户不可点击自己头像
//    _ownerIconImage.userInteractionEnabled = YES;
//    [_ownerIconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
    
    [self setUpReuseCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"MyServiceCell", @"MyServiceCell");
    
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
- (void)ownerIconTap:(UITapGestureRecognizer*)tap {
    id<AYCommand> cmd = [self.notifies objectForKey:@"ownerIconTap:"];
    NSString *info = [service_info objectForKey:@"owner_id"];
    [cmd performWithResult:&info];
}

- (IBAction)didManagerBtnClick:(id)sender {
    
    NSDictionary *args = [service_info copy];
    kAYViewSendNotify(self, @"didManagerBtnClick:", &args)
    
}


- (id)setCellInfo:(id)args {
    service_info = (NSDictionary*)args;
    
//    NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
//    NSMutableDictionary* dic_img = [[NSMutableDictionary alloc]init];
//    [dic_img setValue:photo_name forKey:@"image"];
//    [dic_img setValue:@"img_desc" forKey:@"expect_size"];
//    
//    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//    [cmd performWithResult:[dic_img copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        UIImage* img = (UIImage*)result;
//        if (img != nil) {
//            _mainImage.image = img;
//        }
//    }];
    
    //下载/缓存 全部交给sdwebimage
    NSString* photo_name = [[service_info objectForKey:@"images"] objectAtIndex:0];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    [_mainImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                  placeholderImage:IMGRESOURCE(@"default_image")];
    
    NSString *title = [service_info objectForKey:@"title"];
    _titleLabel.text = title;
    
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    [dic_owner_id setValue:[service_info objectForKey:@"owner_id"] forKey:@"user_id"];
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
//            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//            
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:[result objectForKey:@"screen_photo"] forKey:@"image"];
//            [dic setValue:@"img_icon" forKey:@"expect_size"];
//            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//                UIImage* img = (UIImage*)result;
//                if (img != nil) {
//                    [_ownerIconImage setImage:img];
//                }
//            }];
            
            //下载/缓存 全部交给sdwebimage
            NSString *screen_photo = [result objectForKey:@"screen_photo"];
            [_ownerIconImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
                          placeholderImage:IMGRESOURCE(@"default_user")];
            
        }
    }];
    
    return nil;
}

@end
