//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordStopRecordCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"
#import "AYNotifyDefines.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation AYMovieRecordStopRecordCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;
    if (f.isRecording) {
        [f.filter removeTarget:f.movieWriter];
        f.videoCamera.audioEncodingTarget = nil;
        [f.movieWriter finishRecordingWithCompletionHandler:^{
            // save to photo Album
            ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:f.current_movie_url completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"captured video saved with no error.");
                } else {
                    NSLog(@"error occured while saving the video:%@", error);
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [f.movie_lst addObject:f.current_movie_url];
                f.current_movie_url = nil;
                f.isRecording   = false;
                
                NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                [notify setValue:kAYNotifyDidEndMovieRecording forKey:kAYNotifyFunctionKey];
                
                NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                [f performWithResult:&notify];
            });
        }];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
