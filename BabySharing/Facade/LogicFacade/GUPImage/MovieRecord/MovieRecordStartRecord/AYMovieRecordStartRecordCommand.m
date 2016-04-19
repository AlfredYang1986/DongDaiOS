//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordStartRecordCommand.h"
#import "GPUImage.h"
#import "AYMovieRecordFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"
#import "AYNotifyDefines.h"

@implementation AYMovieRecordStartRecordCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYMovieRecordFacade* f = MOVIERECORD;
//    [f.videoCamera stopCameraCapture];
    if (!f.isRecording && f.seconds < kAYMovieRecordMaxMovieTime) {
        NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
        NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
        NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
        f.current_movie_url = [NSURL fileURLWithPath:path];
        f.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:f.current_movie_url size:CGSizeMake(480.0, 640.0)];
        f.movieWriter.encodingLiveVideo = YES;
        [f.filter addTarget:f.movieWriter];
        [f.videoCamera addAudioInputsAndOutputs];
        f.videoCamera.audioEncodingTarget = f.movieWriter;
        f.isRecording = true;
        [f.movieWriter startRecording];
       
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifyDidStartMovieRecording forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
        [f performWithResult:&notify];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
