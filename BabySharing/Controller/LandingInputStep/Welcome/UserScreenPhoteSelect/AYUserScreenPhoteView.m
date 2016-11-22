//
//  AYUserScreenPhoteSelectVIew.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserScreenPhoteView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "SGActionView.h"
#import "AYViewController.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYFactoryManager.h"

@implementation AYUserScreenPhoteView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    self.layer.cornerRadius = 100 / 2;
    self.clipsToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.borderColor = [Tools borderAlphaColor].CGColor;
    self.layer.borderWidth = 3.f;
    
    self.userInteractionEnabled = YES;
    self.image = IMGRESOURCE(@"default_user");
    self.contentMode = UIViewContentModeScaleAspectFill;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImgBtn)]];
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

- (id)changeScreenPhoto:(id)obj {
    
    if ([obj isKindOfClass:[UIImage class]]) {
        
        UIImage* img = (UIImage*)obj;
        self.image = img;
        
    } else {
        NSString* photo_name = (NSString*)obj;
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        
        NSString *pre = cmd.route;
        [self sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
                placeholderImage:IMGRESOURCE(@"default_image")];
    }
    
    return nil;
}

- (id)canPhotoBtnClicked:(id)obj {
//    BOOL b = ((NSNumber*)obj).boolValue;
//    if (!b) {
//        self.enabled = NO;
//        [self removeTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        [self addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
//    }
    return nil;
}

- (void)didSelectImgBtn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"tapGestureScreenPhoto"];
    [cmd performWithResult:nil];
    
}

-(id)albumBtnClicked {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerPicRoll" andArgs:[dic copy]];
    return nil;
}

-(id)takePhotoBtnClicked {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerCamera" andArgs:[dic copy]];
    return nil;
}

@end
