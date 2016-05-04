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

@property(strong, nonatomic) UIImage *photoimg;
@end

@implementation AYProfilePushCellView

@synthesize photoimg = _photoimg;

+ (CGFloat)preferedHeight {
    return 80;
}

- (void)awakeFromNib {
    
    _photoImage.layer.cornerRadius = 3.f;
    _photoImage.clipsToBounds = YES;
    
//    _photoImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderImgSelected:)];
//    [_photoImage addGestureRecognizer:tap];
    
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
    
    NSString* content_description = [dic objectForKey:@"content_description"];
    _descLabel.text = content_description;
    
    NSString* owner_name = [dic objectForKey:@"owner_name"];
    _fromLabel.text = owner_name;
    
    NSString* photo_name = [dic objectForKey:@"owner_photo"];
    [self setPhotoImageWithString:photo_name];
    
    NSDate* content_post_date = [dic objectForKey:@"content_post_date"];
    [self setTimeLabelWithDate:content_post_date];

    return nil;
}

-(void)setPhotoImageWithString:(NSString*)photo_name{

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"relase_imge_default"] ofType:@"png"];
    [_photoImage setImage:[UIImage imageNamed:filePath]];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setValue:photo_name forKey:@"image"];
    
    [cmd performWithResult:[dict copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            _photoImage.image = img;
        }
    }];
}

-(void)setTimeLabelWithDate:(NSDate*)date{
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    //    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:localzone];
    //
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSString *destDateString = [dateFormatter stringFromDate:content_post_date];
    _timeLabel.text = result;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end

