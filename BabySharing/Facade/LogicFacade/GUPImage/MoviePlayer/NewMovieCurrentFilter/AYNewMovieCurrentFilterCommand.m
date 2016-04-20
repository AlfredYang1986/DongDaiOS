//
//  AYNewMovieCurrentFilterCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYNewMovieCurrentFilterCommand.h"
#import "GPUImage.h"
#import "AYMoviePlayerFacade.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYPlayMovieMeta.h"
#import "AYNotifyDefines.h"

#import "TmpFileStorageModel.h"

@implementation AYNewMovieCurrentFilterCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {

    NSURL* url = [args objectForKey:@"url"];
    
    AYMoviePlayerFacade* f = MOVIEPLAYER;
  
    NSString* str = url.absoluteString;
    AYPlayMovieMeta* meta = [f.playing_items objectForKey:str];
    if (meta == nil) {
        meta = [[AYPlayMovieMeta alloc]initWithURL:url];
        [f.playing_items setValue:meta forKey:str];
    }
   
    [meta pause];

    NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
    NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
    NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
    unlink([path UTF8String]);
    NSURL* url_new = [NSURL fileURLWithPath:path];
    
    meta.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url_new size:CGSizeMake(480.0, 640.0)];
    meta.movieWriter.encodingLiveVideo = YES;
  
    [meta.movieFile endProcessing];
    [meta.movieFile removeAllTargets];
    [meta.filter removeAllTargets];
    
    [meta.movieFile addTarget:meta.filter];
    [meta.filter addTarget:meta.movieWriter];
    
    meta.movieWriter.shouldPassthroughAudio = YES;
    meta.movieFile.audioEncodingTarget = meta.movieWriter;
    [meta.movieFile enableSynchronizedEncodingUsingMovieWriter:meta.movieWriter];

    [meta.movieWriter startRecording];
    [meta.movieFile startProcessing];
    
    [self beforeAsyncCall];

    [meta.movieWriter finishRecordingWithCompletionHandler:^{
        [meta.filter removeTarget:meta.movieWriter];
        meta.movieFile.audioEncodingTarget = nil;
        NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
        [result setValue:url_new forKey:@"url"];
        [self endAsyncCall];
        block(YES, [result copy]);
    }];
}
@end
