//
//  AYReleaseAllMoviesCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYReleaseAllMoviesCommand.h"
#import "GPUImage.h"
#import "AYMoviePlayerFacade.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYPlayMovieMeta.h"

@implementation AYReleaseAllMoviesCommand
@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    AYMoviePlayerFacade* f = MOVIEPLAYER;
    [f.playing_items removeAllObjects];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
