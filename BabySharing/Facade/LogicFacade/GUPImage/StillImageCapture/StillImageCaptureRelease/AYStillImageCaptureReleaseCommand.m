//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureReleaseCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureReleaseCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    [f.filterView removeFromSuperview];
    [f.stillCamera stopCameraCapture];
    f.filterView = nil;
    f.filter = nil;
    f.stillCamera = nil;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
