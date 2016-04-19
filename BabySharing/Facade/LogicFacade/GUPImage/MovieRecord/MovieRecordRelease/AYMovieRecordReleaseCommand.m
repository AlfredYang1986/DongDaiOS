//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordReleaseCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

@implementation AYMovieRecordReleaseCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;
    [f.filterView removeFromSuperview];
    [f.videoCamera stopCameraCapture];
    f.filterView = nil;
    f.filter = nil;
    f.videoCamera = nil;
    
    for (NSURL* iter in f.movie_lst) {
        [TmpFileStorageModel deleteOneMovieFileWithUrl:iter];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
