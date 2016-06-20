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

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AYCLResultCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *friendIcon;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *unLikeBtn;
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
    
    _costLabel.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25f].CGColor;
    line_separator.borderWidth = 1.f;
    line_separator.frame = CGRectMake(0, 289, self.bounds.size.width, 1);
    [self.layer addSublayer:line_separator];
    
    [self setUpReuseCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _unLikeBtn.hidden = YES;
    
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
//    id<AYViewBase> cell = VIEW(@"CLResultCell", @"CLResultCell");
    id<AYViewBase> cell = VIEW(@"ProfilePushCell", @"ProfilePushCell");
    
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
    _descLabel.text = [dic objectForKey:@"title"];
    
    NSNumber *price = [dic objectForKey:@"price"];
    _costLabel.text = [NSString stringWithFormat:@"¥ %.f／小时",price.floatValue];
    
    NSDictionary *dic_loc = [dic objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *pl = [placemarks firstObject];
//        NSLog(@"%@",pl.addressDictionary);
        _adresslabel.text = pl.subLocality;
    }];
    
    _starRangImage.image = IMGRESOURCE(@"star_rang_5");
    
    return nil;
}

#pragma mark -- actions
- (IBAction)didLikeBtnClick:(id)sender {
    
    _likeBtn.hidden = YES;
    _unLikeBtn.hidden = NO;
}
- (IBAction)didUnLikeBtnClick:(id)sender {
    
    _unLikeBtn.hidden = YES;
    _likeBtn.hidden = NO;
}
@end
