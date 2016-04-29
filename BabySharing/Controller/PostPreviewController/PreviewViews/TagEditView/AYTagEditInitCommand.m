//
//  AYTagEditInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagEditInitCommand.h"

#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"

#import "AYTagEditView.h"
#import "AYPhotoTagView.h"

@implementation AYTagEditInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYPhotoTagView* effect_view = (AYPhotoTagView*)*obj;
    AYTagEditView* v = [[AYTagEditView alloc]init];
    [v postPerform];
    [v setUpReuseCommands];
    v.tag_type = effect_view.type;
    v.effect_view = effect_view;
    *obj = v;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
