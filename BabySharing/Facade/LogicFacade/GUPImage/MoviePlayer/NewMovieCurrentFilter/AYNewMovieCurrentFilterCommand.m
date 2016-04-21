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
#import "ImageFilterFactory.h"

@implementation AYNewMovieCurrentFilterCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {

    NSURL* url = [args objectForKey:@"url"];
    NSString* filter_name = [args objectForKey:@"filter"];
    
    GPUImageFilter* filter = nil;
    if ([filter_name isEqualToString:@"BlackAndWhite"]) {
        filter = [ImageFilterFactory blackWhite];
    } else if ([filter_name isEqualToString:@"Scene"]) {
        filter = [ImageFilterFactory scene];
    } else if ([filter_name isEqualToString:@"Avater"]) {
        filter = [ImageFilterFactory avater];
    } else if ([filter_name isEqualToString:@"Food"]) {
        filter = [ImageFilterFactory food];
    } else {
        filter = [[GPUImageFilter alloc]init];
    }
    
    AYMoviePlayerFacade* f = MOVIEPLAYER;
 
    NSString* str = url.absoluteString;
  
    AYPlayMovieMeta* meta = [f.playing_items objectForKey:str];
    if (meta != nil) {
        [f.playing_items removeObjectForKey:str];
    }
//        filter = [[GPUImageFilter alloc]init];
//    } else {
//        filter = meta.filter;
//        [meta releaseMovie];
//    }
    
    GPUImageMovie* movieFile = [[GPUImageMovie alloc] initWithURL:url];

    NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
    NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
    NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
    unlink([path UTF8String]);
    NSURL* url_new = [NSURL fileURLWithPath:path];
    
    GPUImageMovieWriter* movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url_new size:CGSizeMake(480.0, 640.0)];
    movieWriter.encodingLiveVideo = YES;
   
    [movieFile addTarget:filter];
    [filter removeAllTargets];
    [filter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];

    [movieWriter startRecording];
    [movieFile startProcessing];
  
    __block GPUImageMovieWriter* writer = movieWriter;
    [movieWriter setCompletionBlock:^{
        [filter removeAllTargets];
        [writer finishRecording];
        [movieFile endProcessing];
        [movieFile removeAllTargets];
        
//        AYPlayMovieMeta* meta = [f.playing_items objectForKey:str];
//        if (meta != nil) {
//            [meta resetMovie];
//            [filter addTarget:meta.filterView];
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
            [result setValue:url_new forKey:@"url"];
            [self endAsyncCall];
            block(YES, [result copy]);
        });
    }];
}
@end
