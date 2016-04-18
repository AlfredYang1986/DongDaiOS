//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureStartCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureStartCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    [f.stillCamera startCameraCapture];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
