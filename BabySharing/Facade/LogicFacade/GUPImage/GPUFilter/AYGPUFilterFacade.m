//
//  AYGPUFilterFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGPUFilterFacade.h"
#import "ImageFilterFactory.h"

@implementation AYGPUFilterFacade
@synthesize blackAndWhite = _blackAndWhite;
@synthesize scene = _scene;
@synthesize avater = _avater;
@synthesize food = _food;

- (void)postPerform {
    if (!_blackAndWhite) {
        _blackAndWhite = [ImageFilterFactory blackWhite];
    }
    
    if (!_scene) {
        _scene = [ImageFilterFactory scene];
    }
    
    if (!_avater) {
        _avater = [ImageFilterFactory avater];
    }
    
    if (!_food) {
        _food = [ImageFilterFactory food];
    }
}
@end
