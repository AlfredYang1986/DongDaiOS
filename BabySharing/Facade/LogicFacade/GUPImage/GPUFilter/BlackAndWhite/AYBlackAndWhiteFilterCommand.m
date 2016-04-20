//
//  AYBlackAndWhiteFilterCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYBlackAndWhiteFilterCommand.h"
#import "GPUImage.h"
#import "AYGPUFilterFacade.h"
#import "AYFactoryManager.h"
#import "AYGPUFilterDefines.h"

@implementation AYBlackAndWhiteFilterCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
  
    UIImage* source = (UIImage*)*obj;
   
    AYGPUFilterFacade* f = GPUFILTER;
    
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:f.blackAndWhite];
    [f.blackAndWhite useNextFrameForImageCapture];
    [tmp processImage];
    *obj = [f.blackAndWhite imageFromCurrentFramebuffer];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
