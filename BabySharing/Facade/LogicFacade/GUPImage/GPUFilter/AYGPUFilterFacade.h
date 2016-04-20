//
//  AYGPUFilterFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYFacade.h"

@class GPUImageFilter;

@interface AYGPUFilterFacade : AYFacade
@property (nonatomic, strong) GPUImageFilter* blackAndWhite;
@property (nonatomic, strong) GPUImageFilter* scene;
@property (nonatomic, strong) GPUImageFilter* avater;
@property (nonatomic, strong) GPUImageFilter* food;
@end
