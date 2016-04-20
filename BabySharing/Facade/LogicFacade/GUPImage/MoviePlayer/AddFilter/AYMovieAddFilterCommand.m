//
//  AYMovieAddFilterCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieAddFilterCommand.h"
#import "GPUImage.h"
#import "AYMoviePlayerFacade.h"
#import "AYFactoryManager.h"
#import "AYCommandDefines.h"
#import "AYPlayMovieMeta.h"

@implementation AYMovieAddFilterCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
   
    NSDictionary* dic = (NSDictionary*)*obj;
    
    id filter = [dic objectForKey:@"filter"];
    NSURL* url = [dic objectForKey:@"url"];

    AYMoviePlayerFacade* f = MOVIEPLAYER;
    
    NSString* str = url.absoluteString;
    AYPlayMovieMeta* meta = [f.playing_items objectForKey:str];
    if (meta != nil) {
        
        if (filter == nil) {
            filter = [[GPUImageFilter alloc]init];
        }
        meta.filter = filter;
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
