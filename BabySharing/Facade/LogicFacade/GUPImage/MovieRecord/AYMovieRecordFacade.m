//
//  AYMovieRecordFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieRecordFacade.h"
#import "AYNotifyDefines.h"
#import "MoviePlayTrait.h"

@implementation AYMovieRecordFacade

@synthesize filter = _filter;
@synthesize movieWriter = _movieWriter;
@synthesize filterView = _filterView;
@synthesize videoCamera = _videoCamera;

@synthesize isRecording = _isRecording;
@synthesize seconds = _seconds;
@synthesize movie_lst = _movie_lst;
@synthesize current_movie_url = _current_movie_url;
@synthesize trait = _trait;

- (void)MergeMovieSuccessfulWithFinalURL:(NSURL *)url {
    NSLog(@"Merge Movie Successful");
//    PostPreViewEffectController * distination = [[PostPreViewEffectController alloc]init];
//    distination.editing_movie = url;
//    distination.type = PostPreViewMovie;
//    [self.navigationController pushViewController:distination animated:YES];
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyDidMergeMovieRecord forKey:kAYNotifyFunctionKey];
    
    [notify setValue:url forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}
@end
