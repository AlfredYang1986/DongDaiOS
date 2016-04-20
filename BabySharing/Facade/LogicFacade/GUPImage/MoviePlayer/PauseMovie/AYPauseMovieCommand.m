//
//  AYPauseMovieCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPauseMovieCommand.h"
#import "GPUImage.h"
#import "AYMoviePlayerFacade.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYPlayMovieMeta.h"

@implementation AYPauseMovieCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    
    NSURL* url = (NSURL*)*obj;
    
    AYMoviePlayerFacade* f = MOVIEPLAYER;
    
    NSString* str = url.absoluteString;
    AYPlayMovieMeta* meta = [f.playing_items objectForKey:str];
    if (meta != nil) {
        [meta pause];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
