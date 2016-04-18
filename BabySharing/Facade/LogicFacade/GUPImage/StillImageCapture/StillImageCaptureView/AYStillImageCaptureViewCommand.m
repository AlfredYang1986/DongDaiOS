//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureViewCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureViewCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    id result = f.filterView;
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
