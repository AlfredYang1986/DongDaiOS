//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordViewCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"

@implementation AYMovieRecordViewCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;
    id result = f.filterView;
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
