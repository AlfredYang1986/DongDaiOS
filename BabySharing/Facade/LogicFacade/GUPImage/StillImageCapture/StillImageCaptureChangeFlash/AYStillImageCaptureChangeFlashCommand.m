//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureChangeFlashCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureChangeFlashCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    
    AVCaptureSession* session = [f.stillCamera captureSession];
    AVCaptureDevice* device = [f.stillCamera inputCamera];
    
    [session beginConfiguration];
    [device lockForConfiguration:nil];
    
    int flashMode = ((NSNumber*)*obj).intValue;
    int tmp = (++flashMode) % 3;
    [device setFlashMode:tmp];
   
    [device unlockForConfiguration];
    [session commitConfiguration];
    
    *obj = [NSNumber numberWithInt:tmp];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
