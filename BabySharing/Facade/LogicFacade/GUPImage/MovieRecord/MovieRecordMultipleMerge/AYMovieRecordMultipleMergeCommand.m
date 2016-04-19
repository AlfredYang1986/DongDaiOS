//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordMultipleMergeCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"
#import "MoviePlayTrait.h"
#import "AYNotifyDefines.h"

@implementation AYMovieRecordMultipleMergeCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;

    if (f.movie_lst.count == 0) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"cannot merge without content" userInfo:nil];
    } else if (f.movie_lst.count == 1) {
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifyDidMergeMovieRecord forKey:kAYNotifyFunctionKey];
        
        [notify setValue:f.movie_lst.lastObject forKey:kAYNotifyArgsKey];
        [f performWithResult:&notify];
    } else {
        [f.trait mergeMultipleAssertWithURLs:f.movie_lst andAudio:nil];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
