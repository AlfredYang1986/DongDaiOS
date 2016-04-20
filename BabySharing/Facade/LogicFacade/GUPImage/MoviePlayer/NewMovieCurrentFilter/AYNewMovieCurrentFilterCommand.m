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
    
    NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
    NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
    NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
    NSURL* url_new = [NSURL fileURLWithPath:path];
    
    GPUImageMovieWriter* movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url_new size:CGSizeMake(480.0, 640.0)];
    movieWriter.encodingLiveVideo = NO;
   
    [meta.movieFile addTarget:meta.filter];
    [meta.filter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    meta.movieFile.audioEncodingTarget = movieWriter;
    [meta.movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];

    [movieWriter startRecording];
    [meta.movieFile startProcessing];
    
    [self beforeAsyncCall];
    
    [movieWriter setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
            [result setValue:url_new forKey:@"url"];
            [self endAsyncCall];
            block(YES, [result copy]);
        });
    }];
    
//    [f.filter addTarget:f.movieWriter];
//    [f.videoCamera addAudioInputsAndOutputs];
//    f.videoCamera.audioEncodingTarget = f.movieWriter;
//    f.isRecording = true;
//    [f.movieWriter startRecording];
}
@end
