//
//  AYMovieRecordDeleteRecordCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordDeleteRecordCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"
#import "AYNotifyDefines.h"

@implementation AYMovieRecordDeleteRecordCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;

    if (f.movie_lst.count > 0) {
        NSURL* url = f.movie_lst.lastObject;
        [TmpFileStorageModel deleteOneMovieFileWithUrl:url];
        
        [f.movie_lst removeLastObject];
        
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifyDidDeleteMovieRecord forKey:kAYNotifyFunctionKey];
        
        [notify setValue:[NSNumber numberWithInteger:f.movie_lst.count] forKey:kAYNotifyArgsKey];
        [f performWithResult:&notify];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
