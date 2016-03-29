//
//  AYUserScreenPhoteSelectVIew.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserScreenPhoteSelectView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "SGActionView.h"
#import "AYViewController.h"

#define NEXT_BTN_MARGIN_BOTTOM  80

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_TOP_MARGIN                 SCREEN_HEIGHT / 6
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     100

#define SCREEN_PHOTO_2_GENDER_BTN_MARGIN        30

@implementation AYUserScreenPhoteSelectView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    self.frame = CGRectMake(0, 0, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_HEIGHT);
    self.layer.cornerRadius = SCREEN_PHOTO_HEIGHT / 2;
    self.clipsToBounds = YES;
    self.tag = -110;
    self.backgroundColor = [UIColor clearColor];
    self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT / 2);
    
    self.clipsToBounds = YES;
    UIImage* img = PNGRESOURCE(@"default_user");
    [self setBackgroundImage:img forState:UIControlStateNormal];
//    [self asyncGetUserImage];
    [self addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
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
    UIImage* img = (UIImage*)obj;
    [self setBackgroundImage:img forState:UIControlStateNormal];
    return nil;
}

- (void)didSelectImgBtn {
    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"打开照相机", @"从相册中选择", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
        switch (index) {
            case 0: {
                
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerCamera" andArgs:[dic copy]];
                }
                break;
            case 1: {
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerPicRoll" andArgs:[dic copy]];
                }
                break;
            default:
                break;
        }
    }];
}
@end
