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

@interface AYMovieRecordFacade : AYFacade
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView* filterView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@end
