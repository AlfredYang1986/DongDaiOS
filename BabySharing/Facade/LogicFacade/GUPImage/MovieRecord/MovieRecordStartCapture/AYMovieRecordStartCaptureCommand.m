//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordStartCaptureCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"

@implementation AYMovieRecordStartCaptureCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;
    [f.videoCamera startCameraCapture];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
