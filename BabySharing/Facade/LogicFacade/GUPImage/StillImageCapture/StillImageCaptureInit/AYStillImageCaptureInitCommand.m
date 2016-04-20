//
//  AYStillImageCaptureInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureInitCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"

@implementation AYStillImageCaptureInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    
    f.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    f.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    f.filter = [[GPUImageFilter alloc]init];
    
    [f.stillCamera addTarget:f.filter];
    
    f.filterView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    [f.filter addTarget:f.filterView];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
