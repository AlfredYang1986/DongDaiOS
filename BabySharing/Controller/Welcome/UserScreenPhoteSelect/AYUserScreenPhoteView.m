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


@implementation AYUserScreenPhoteView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    
    self.layer.cornerRadius = 100 / 2;
    self.clipsToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.tag = -110;
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.255].CGColor;
    self.layer.borderWidth = 3.f;
    
    [self setBackgroundImage:IMGRESOURCE(@"default_user") forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageView.clipsToBounds = YES;
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

- (id)canPhotoBtnClicked:(id)obj {
    BOOL b = ((NSNumber*)obj).boolValue;
    if (!b) {
        self.enabled = NO;
        [self removeTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return nil;
}

- (void)didSelectImgBtn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"tapGestureScreenPhoto"];
    [cmd performWithResult:nil];//michauxs
    
//    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"打开照相机", @"从相册中选择", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
//        switch (index) {
//            case 0: {
//                
//                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerCamera" andArgs:[dic copy]];
//                }
//                break;
//            case 1: {
//                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//                    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//                    [_controller performForView:self andFacade:nil andMessage:@"OpenUIImagePickerPicRoll" andArgs:[dic copy]];
//                }
//                break;
//            default:
//                break;
//        }
//    }];
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
