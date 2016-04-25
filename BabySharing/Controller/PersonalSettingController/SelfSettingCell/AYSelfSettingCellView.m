//
//  PersonalSettingCell.m
//  BabySharing
//
//  Created by Alfred Yang on 29/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AYSelfSettingCellView.h"
#import "TmpFileStorageModel.h"

#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYSelfSettingCellDefines.h"

@interface AYSelfSettingCellView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@end

@implementation AYSelfSettingCellView

@synthesize titleLabel = _titleLabel;
@synthesize contentImage = _contentImage;
@synthesize contentLabel = _contentLabel;

- (void)awakeFromNib {
    // Initialization code
    _contentImage.hidden = YES;
    _contentImage.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _contentImage.layer.borderWidth = 1.5f;
    _contentImage.layer.cornerRadius = 13.f;
    _contentImage.clipsToBounds = YES;
    
    _titleLabel.textColor = [UIColor grayColor];
    _contentLabel.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    _contentLabel.font = [UIFont systemFontOfSize:13.f];
    
    [self setUpReuseCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeightWithImage:(BOOL)bImg {
//    if (bImg) return 67;
//    else return 44;
    return 44;
}

- (void)changeCellTitile:(NSString*)title {
    _titleLabel.text = title;
}

- (void)changeCellContent:(NSString*)content {
    _contentLabel.text = content;
}

- (void)changeCellImage:(NSString*)photo_name {
  
    [self.contentImage setImage:PNGRESOURCE(@"default_user")];
    _contentImage.hidden = NO;
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:photo_name forKey:@"image"];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    [cmd performWithResult:[args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img= (UIImage*)result;
        self.contentImage.image = img;
    }];
}

#pragma mark -- AYCommands
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYSelfSettingCellName, kAYSelfSettingCellName);
    
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
- (id)setCellInfo:(id)obj {
   
    NSDictionary* dic = (NSDictionary*)obj;
   
    AYSelfSettingCellView* cell = [dic objectForKey:kAYSelfSettingCellCellKey];
    
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYSelfSettingCellTitleKey]) {
            [cell changeCellTitile:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYSelfSettingCellScreenNameKey]) {
            [cell changeCellContent:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYSelfSettingCellRoleTagKey]) {
            [cell changeCellContent:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYSelfSettingCellScreenPhotoKey]) {
            [cell changeCellImage:[dic objectForKey:key]];
        }
    }
    
    return nil;
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:[AYSelfSettingCellView preferredHeightWithImage:nil]];
}
@end
