//
//  AYCLResultCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCLResultCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
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
#import "AYFacade.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AYCLResultCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *friendIcon;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adresslabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *starRangImage;

@property (nonatomic, strong) CLGeocoder *gecoder;
@end

@implementation AYCLResultCellView{
    NSDictionary *cellInfo;
}

-(CLGeocoder *)gecoder{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _mainImage.contentMode = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds = YES;
    
    _costLabel.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
    
    _ownerIconImage.layer.cornerRadius = 20.f;
    _ownerIconImage.clipsToBounds = YES;
    _ownerIconImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _ownerIconImage.layer.borderColor = [Tools borderAlphaColor].CGColor;
    _ownerIconImage.layer.borderWidth = 2.f;
    
    _ownerIconImage.userInteractionEnabled = YES;
    [_ownerIconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
    
    [self setUpReuseCell];
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
    id<AYViewBase> cell = VIEW(@"CLResultCell", @"CLResultCell");
//    id<AYViewBase> cell = VIEW(@"ProfilePushCell", @"ProfilePushCell");
    
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

- (id)setCellInfo:(id)args{
    NSDictionary *dic = (NSDictionary*)args;
    cellInfo = dic;
    NSLog(@"%@",dic);
    
    NSString* photo_name = [[dic objectForKey:@"images"] objectAtIndex:0];
    NSMutableDictionary* dic_img = [[NSMutableDictionary alloc]init];
    [dic_img setValue:photo_name forKey:@"image"];
    [dic_img setValue:@"img_desc" forKey:@"expect_size"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    [cmd performWithResult:[dic_img copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            _mainImage.image = img;
        }else{
            [_mainImage setImage:IMGRESOURCE(@"sample_image")];
        }
    }];
    
    BOOL isLike = ((NSNumber*)[dic objectForKey:@"is_heart"]).boolValue;
    if (isLike) {
        _likeBtn.selected = YES;
    } else _likeBtn.selected = NO;
    
    NSString *title = [dic objectForKey:@"title"];
    _descLabel.text = title;
    
    NSNumber *price = [dic objectForKey:@"price"];
    _costLabel.text = [NSString stringWithFormat:@"¥ %.f／小时",price.floatValue];
    
    NSDictionary *dic_loc = [dic objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        _adresslabel.text = pl.subLocality;
    }];
    
    _starRangImage.image = IMGRESOURCE(@"star_rang_5");
    
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    [dic_owner_id setValue:[dic objectForKey:@"owner_id"] forKey:@"user_id"];
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[result objectForKey:@"screen_photo"] forKey:@"image"];
            [dic setValue:@"img_icon" forKey:@"expect_size"];
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    [_ownerIconImage setImage:img];
                }
            }];
        }
        
    }];
    
    return nil;
}

#pragma mark -- actions
- (void)ownerIconTap:(UITapGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"ownerIconTap:"];
    NSString *info = [cellInfo objectForKey:@"owner_id"];
    [cmd performWithResult:&info];
}


- (IBAction)didLikeBtnClick:(id)sender {
    
    NSDictionary *info = nil;
    CURRENUSER(info);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setValue:[cellInfo objectForKey:@"service_id"] forKey:@"service_id"];
    
    id<AYControllerBase> controller = DEFAULTCONTROLLER(@"LocationResult");
    if (!_likeBtn.selected) {
        id<AYFacadeBase> facade = [controller.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                _likeBtn.selected = YES;
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    } else {
        id<AYFacadeBase> facade = [controller.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
                _likeBtn.selected = NO;
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请检查网络链接是否正常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
}

@end
