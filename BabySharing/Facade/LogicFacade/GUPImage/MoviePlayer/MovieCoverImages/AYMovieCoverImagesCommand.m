//
//  AYMovieCoverImagesCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieCoverImagesCommand.h"
#import "GPUImage.h"

@implementation AYMovieCoverImagesCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {

    NSURL* url = (NSURL*)*obj;

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    /**
     * 1. get total length of the asset
     */
    CGFloat seconds = asset.duration.value / asset.duration.timescale;   // seconds
    NSInteger steps = 10;
    NSError *error = nil;
    CMTime actualTime;
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    /**
     * 2. get thumb through movie
     */
    NSMutableArray* thumbs = [[NSMutableArray alloc]initWithCapacity:steps];
    for (int index = 0; index < steps; ++index) {
        CMTime time = CMTimeMakeWithSeconds(seconds / steps * index, 600);
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        [thumbs addObject:[[UIImage alloc] initWithCGImage:image]];
        CGImageRelease(image);
    }
    
    *obj = [thumbs copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
