//
//  AYNapPhotosCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapPhotosCellView.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@interface AYNapPhotosCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation AYNapPhotosCellView {
    NSString *title;
    NSString *content;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _photoImage.userInteractionEnabled = YES;
    [_photoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPhoto:)]];
    
//    _subTitleLabel.text = @"高质量的图片\n可以更好的展现您的服务或场地";
    self.backgroundColor = [Tools garyBackgroundColor];
    
    [self setUpReuseCell];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"NapPhotosCell", @"NapPhotosCell");
    
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
- (void)editPhoto:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"addPhotosAction"];
    [cmd performWithResult:nil];
}

- (IBAction)addPhotoBtnClick:(id)sender {
    id<AYCommand> cmd = [self.notifies objectForKey:@"addPhotosAction"];
    [cmd performWithResult:nil];
}

- (id)setCellInfo:(id)args {
    _photoImage.hidden = NO;
    
    if ([args isKindOfClass:[UIImage class]]) {
        _photoImage.image = (UIImage*)args;
    } else if ([args isKindOfClass:[NSString class]]) {
        
        NSString* photo_name = (NSString*)args;
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:photo_name forKey:@"image"];
//        [dic setValue:@"img_local" forKey:@"expect_size"];
//        
//        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//            UIImage* img = (UIImage*)result;
//            if (img != nil) {
//                _photoImage.image = img;
//            }
//        }];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        NSString *pre = cmd.route;
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                      placeholderImage:IMGRESOURCE(@"default_image")];
        
    }
    
    _addPhotoBtn.hidden = YES;
    _subTitleLabel.hidden = YES;
    return nil;
}
@end
