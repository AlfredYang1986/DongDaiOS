//
//  AYProfileHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 6/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileHeadCellView.h"
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

@interface AYProfileHeadCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *user_screen;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *bobyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rigistimeLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *allowEditIcon;

@end

@implementation AYProfileHeadCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _user_screen.layer.cornerRadius = 30.f;
    _user_screen.clipsToBounds = YES;
    _user_screen.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _user_screen.layer.borderWidth = 2.f;
    _user_screen.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self setUpReuseCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ProfileHeadCell", @"ProfileHeadCell");
    
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

-(id)setCellInfo:(NSDictionary*)args{
	
	NSString *screen_photo = [args objectForKey:kAYProfileArgsScreenPhoto];
	[_user_screen sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, screen_photo]] placeholderImage:IMGRESOURCE(@"default_user")];
    
    NSString *name = [args objectForKey:@"screen_name"];
    if (name && ![name isEqualToString:@""]) {
        _user_name.text = name;
    }
    
    return nil;
}
@end
