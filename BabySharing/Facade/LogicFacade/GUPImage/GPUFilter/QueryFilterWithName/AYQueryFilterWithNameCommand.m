//
//  AYQueryFilterWithNameCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryFilterWithNameCommand.h"
#import "GPUImage.h"
#import "AYGPUFilterFacade.h"
#import "AYFactoryManager.h"
#import "AYGPUFilterDefines.h"

@implementation AYQueryFilterWithNameCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSString* str = (NSString*)*obj;
    
    AYGPUFilterFacade* f = GPUFILTER;

    id result = nil;
    if ([str isEqualToString:@"BlackAndWhiteFilter"]) {
        result = f.blackAndWhite;
    } else if ([str isEqualToString:@"SceneFilter"]) {
        result = f.scene;
    } else if ([str isEqualToString:@"AvaterFilter"]) {
        result = f.avater;
        
    } else if ([str isEqualToString:@"FoodFilter"]) {
        result = f.food;
    } else {
        
    }
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
