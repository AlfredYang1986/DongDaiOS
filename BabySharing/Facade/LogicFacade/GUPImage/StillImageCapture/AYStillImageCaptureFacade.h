//
//  AYStillImageFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYFacade.h"

@class GPUImageOutput;
@protocol GPUImageInput;
@class GPUImageView;
@class GPUImageStillCamera;

@interface AYStillImageCaptureFacade : AYFacade
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageView* filterView;
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@end
