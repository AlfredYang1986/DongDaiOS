//
//  AYPlayMovieMeta.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPlayMovieMeta.h"
#import "GPUImage.h"
#import <AVFoundation/AVFoundation.h>

@implementation AYPlayMovieMeta {
    BOOL direct_play;
}

@synthesize movieFile = _movieFile;
@synthesize filterView = _filterView;
@synthesize filter = _filter;
@synthesize player = _player;
@synthesize avPlayerItem = _avPlayerItem;

- (instancetype)initWithURL:(NSURL*)url {
    self = [super init];
    if (self) {
        _avPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:_avPlayerItem];
        
        _movieFile = [[GPUImageMovie alloc] initWithPlayerItem:_avPlayerItem];
        _movieFile.runBenchmark = YES;
        _movieFile.playAtActualSpeed = NO;
        _movieFile.shouldRepeat = YES;
        
        _filter = [[GPUImageFilter alloc] init];
        [_movieFile addTarget:_filter];
        
        _filterView = [[GPUImageView alloc]init];
        _filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [_filter addTarget:_filterView];

        [_avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerItem];
    }
    return self;
}

- (void)play {
    direct_play = NO;
    if (_avPlayerItem.status != AVPlayerItemStatusReadyToPlay) {
        direct_play = YES;
        
    } else {
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [_movieFile startProcessing];
            [_player play];
        }];
    }
    
}

- (void)pause {
    [_movieFile endProcessing];
    [_player pause];
}

- (void)addMovieFilter:(GPUImageFilter*)filter {
    if (_filter != filter) {
        _filter = filter;
       
        [_movieFile endProcessing];
        
        [_filter removeAllTargets];
        [_movieFile removeAllTargets];

        [_movieFile addTarget:_filter];
        [_filter addTarget:_filterView];
        
        [_movieFile startProcessing];
    }
}

- (void)dealloc {
    [_movieFile endProcessing];
    [_player pause];
    [_avPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerItem];
}

-(void)moviePlayDidEnd:(NSNotification*)notification{
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [_player play];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (AVPlayerItemStatusReadyToPlay == _avPlayerItem.status) {
            NSLog(@"item is ready");
            if (direct_play) {
                [self play];
            }
        }
    }
}
@end
