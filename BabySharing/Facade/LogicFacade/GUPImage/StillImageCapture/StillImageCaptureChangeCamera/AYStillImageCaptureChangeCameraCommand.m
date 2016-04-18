//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureChangeCameraCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureChangeCameraCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    [f.stillCamera rotateCamera];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
