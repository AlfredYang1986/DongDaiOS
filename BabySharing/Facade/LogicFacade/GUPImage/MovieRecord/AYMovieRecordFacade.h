//
//  AYMovieRecordFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYFacade.h"

@class GPUImageOutput;
@protocol GPUImageInput;
@class GPUImageView;
@class GPUImageVideoCamera;
@class GPUImageMovieWriter;
@class MoviePlayTrait;
@protocol MovieActionProtocol;

static float const kAYMovieRecordMaxMovieTime = 15.0f;

@interface AYMovieRecordFacade : AYFacade <MovieActionProtocol>
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView* filterView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;

@property (nonatomic) BOOL isRecording;
@property (nonatomic) float seconds;
@property (nonatomic, strong) NSMutableArray* movie_lst;
@property (nonatomic, strong) NSURL* current_movie_url;
@property (nonatomic, strong) MoviePlayTrait* trait;
@end
