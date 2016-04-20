//
//  AYPostMoviePreviewController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostMoviePreviewController.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"

@interface AYPostMoviePreviewController ()
@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYPostMoviePreviewController {
    NSURL* movie_url;
}

@synthesize filterView = _filterView;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        movie_url = (NSURL*)[dic objectForKey:kAYControllerChangeArgsKey];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    id<AYViewBase> view_movie_cover = [self.views objectForKey:@"MovieCover"];
    id<AYCommand> cmd_movie_cover = [view_movie_cover.commands objectForKey:@"setMovieUrl:"];
    id url = movie_url;
    [cmd_movie_cover performWithResult:&url];
}

- (void)clearController {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    id<AYCommand> cmd = [f.commands objectForKey:@"ReleaseMovie"];
    id url = movie_url;
    [cmd performWithResult:&url];
   
    [super clearController];
}

- (NSString*)getNavTitle {
    return @"编辑视频";
}

- (NSArray*)getFunctionBarItems {
    return @[@"封面", @"滤镜"];
}

- (void)setCurrentStatus:(AYPostPhotoPreviewControllerType)status {
    [super setCurrentStatus:status];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    if (status == AYPostPhotoPreviewControllerTypeSegAtFilter) {
        NSLog(@"start play movie");
    
        if (self.filterView == nil) {
            id<AYCommand> cmd_view = [f.commands objectForKey:@"MovieDisplayView"];
            id url = movie_url;
            [cmd_view performWithResult:&url];
            
            self.filterView = url;
#define FAKE_NAVIGATION_BAR_HEIGHT      64
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat img_height = width;
            self.filterView.frame = CGRectMake(0, -FAKE_NAVIGATION_BAR_HEIGHT, width, img_height + FAKE_NAVIGATION_BAR_HEIGHT);
            [self.mainContentView addSubview:self.filterView];
        }
        
        id<AYCommand> cmd_play = [f.commands objectForKey:@"PlayMovie"];
        id url = movie_url;
        [cmd_play performWithResult:&url];
        self.filterView.hidden = NO;
    } else {
        id<AYCommand> cmd_play = [f.commands objectForKey:@"PauseMovie"];
        id url = movie_url;
        [cmd_play performWithResult:&url];
        self.filterView.hidden = YES;
    }
}

#pragma mark -- notifications
- (id)didSelectedFilter:(id)obj {
    return nil;
}

- (id)didSelectedCover:(id)obj {
    UIImage* img = (UIImage*)obj;
    self.mainContentView.image = img;
    
    id<AYViewBase> view_filter = [self.views objectForKey:@"FilterPreview"];
    id<AYCommand> cmd_source = [view_filter.commands objectForKey:@"setOriginImage:"];
    id args = img;
    [cmd_source performWithResult:&args];
    return nil;
}
@end
