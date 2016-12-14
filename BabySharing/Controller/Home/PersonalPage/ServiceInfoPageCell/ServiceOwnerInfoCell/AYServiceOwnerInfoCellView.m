//
//  AYServiceOwnerInfoCellVeiw.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceOwnerInfoCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceOwnerInfoCellView {
    UIImageView *userPhoto;
    UILabel *userName;
    UILabel *adress;
//    UILabel *description;
    UITextView *description;
    NSMutableParagraphStyle *paraStyle;
    
    UILabel *readMoreLabel;
    
    NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (CLGeocoder *)gecoder {
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CALayer *btm_seprtor = [CALayer layer];
        btm_seprtor.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        btm_seprtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:btm_seprtor];
        
        self.clipsToBounds = YES;
        
        userPhoto = [[UIImageView alloc]init];
        userPhoto.image = IMGRESOURCE(@"default_user");
        userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        userPhoto.clipsToBounds = YES;
        userPhoto.layer.cornerRadius = 30.f;
        userPhoto.layer.borderColor = [Tools borderAlphaColor].CGColor;
        userPhoto.layer.borderWidth = 2.f;
        [self addSubview:userPhoto];
        [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        userPhoto.userInteractionEnabled = YES;
        [userPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOwnerPhotoClick)]];
        
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
        
//        description = [Tools creatUILabelWithText:@"Description is not set" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
//        description.numberOfLines = 0;
        
        description = [[UITextView alloc]init];
        description.font = kAYFontLight(14.f);
        description.textColor = [Tools blackColor];
        description.textAlignment = NSTextAlignmentLeft;
        description.text = @"Description is not set";
        description.scrollEnabled = NO;
        description.editable = NO;
        [self addSubview:description];
        [description mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userPhoto.mas_bottom).offset(5);
            make.left.equalTo(userPhoto);
            make.right.equalTo(self).offset(-15);
        }];
        
        readMoreLabel = [Tools creatUILabelWithText:@"阅读更多" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        readMoreLabel.hidden = YES;
        [self addSubview:readMoreLabel];
        readMoreLabel.userInteractionEnabled = YES;
        [readMoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReadMoreClick)]];
        [readMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(description.mas_bottom).offset(1);
            make.left.equalTo(description).offset(5);
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

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceOwnerInfoCell", @"ServiceOwnerInfoCell");
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
- (void)didOwnerPhotoClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}
- (void)didReadMoreClick {
    
    NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:[Tools blackColor],NSFontAttributeName:kAYFontLight(14.f)};
    
    NSString *desc = [service_info objectForKey:@"description"];
    if ([readMoreLabel.text isEqualToString:@"阅读更多"]) {
        readMoreLabel.text = @"收起";
    } else {
        readMoreLabel.text = @"阅读更多";
        desc = [desc substringToIndex:60];
        desc = [desc stringByAppendingString:@"..."];
    }
    
    NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
    description.attributedText = descAttri;
    
    CGSize filtSize = [description sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)];
    NSNumber *activeHeight = [NSNumber numberWithFloat:filtSize.height];
    id<AYCommand> reload = [self.notifies objectForKey:@"showMoreOrHideDescription:"];
    [reload performWithResult:&activeHeight];
    
}
#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    service_info = (NSDictionary*)args;
    
    NSString *desc = [service_info objectForKey:@"description"];
    if (desc) {
        
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 4;
        paraStyle.hyphenationFactor = 0;
        paraStyle.paragraphSpacingBefore = 0.1f;
        NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:[Tools blackColor],NSFontAttributeName:kAYFontLight(14.f)};
        
        if (desc.length > 60) {
            desc = [desc substringToIndex:60];
            desc = [desc stringByAppendingString:@"..."];
            readMoreLabel.hidden = NO;
        }
        
        NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
        description.attributedText = descAttri;
    }
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    
    NSString *user_id = [service_info objectForKey:@"owner_id"];
    NSNumber *pre_mode = [service_info objectForKey:@"perview_mode"];
    if (pre_mode) {     //用户预览
        NSDictionary *user_info;
        CURRENUSER(user_info)
        user_id = [user_info objectForKey:@"user_id"];
        
        id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
        AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
        NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
        [dic_owner_id setValue:user_id forKey:@"user_id"];
        [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                
                userPhoto.userInteractionEnabled = YES;
                userName.text = [result objectForKey:@"screen_name"];
                
                NSString* photo_name = [result objectForKey:@"screen_photo"];
                [userPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                             placeholderImage:IMGRESOURCE(@"default_user")];
            } else {
                userPhoto.userInteractionEnabled = NO;
            }
        }];
    } else {
        
        userName.text = [service_info objectForKey:@"screen_name"];
        
        NSString *screen_photo = [service_info objectForKey:@"screen_photo"];
        if (screen_photo) {
            [userPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
                         placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
        } else {
            userPhoto.image = IMGRESOURCE(@"default_user");
        }
    }
    
    NSDictionary *dic_loc = [service_info objectForKey:@"location"];
    if (dic_loc) {
        
        NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
        NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
        [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *pl = [placemarks firstObject];
            NSLog(@"%@",pl.addressDictionary);
            if (pl.locality && pl.subLocality) {
                
                adress.text = [NSString stringWithFormat:@"%@, %@",pl.locality,pl.subLocality];
            }
        }];
    }
    
    return nil;
}

@end
