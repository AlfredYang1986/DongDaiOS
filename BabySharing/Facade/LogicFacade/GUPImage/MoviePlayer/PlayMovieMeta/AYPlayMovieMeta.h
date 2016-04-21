//
//  AYPlayMovieMeta.h
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPUImageMovie;
@class GPUImageView;
@class GPUImageFilter;
@class GPUImageMovieWriter;
@class AVPlayer;
@class AVPlayerItem;

@interface AYPlayMovieMeta : NSObject
@property (nonatomic, strong) GPUImageMovie* movieFile;
@property (nonatomic, strong) GPUImageView* filterView;
@property (nonatomic, strong, setter=addMovieFilter:) GPUImageFilter* filter;
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;

@property (nonatomic, strong, readonly) NSURL* movie_url;

- (instancetype)initWithURL:(NSURL*)url;
- (void)resetMovie;
- (void)play;
- (void)pause;
- (void)releaseMovie;
@end
