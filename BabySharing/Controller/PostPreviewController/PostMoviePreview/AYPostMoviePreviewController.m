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
#import "AYRemoteCallCommand.h"
#import "AYFactoryManager.h"

@interface AYPostMoviePreviewController ()
@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYPostMoviePreviewController {
    NSURL* movie_url;
}

@synthesize filterView = _filterView;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    [super performWithResult:obj];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterView removeFromSuperview];
    self.filterView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    
    if (index.integerValue == 1) {
        [self playCurrentMovie];
    }
}

- (void)playCurrentMovie {
    NSLog(@"start play movie");
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
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
}

- (void)pauseCurrentMovie {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    id<AYCommand> cmd_play = [f.commands objectForKey:@"PauseMovie"];
    id url = movie_url;
    [cmd_play performWithResult:&url];
    self.filterView.hidden = YES;
}

- (NSString*)getNavTitle {
    return @"编辑视频";
}

- (NSArray*)getFunctionBarItems {
    return @[@"封面", @"滤镜"];
}

- (void)setCurrentStatus:(AYPostPhotoPreviewControllerType)status {
    [super setCurrentStatus:status];
    
    if (status == AYPostPhotoPreviewControllerTypeSegAtFilter) {
        [self playCurrentMovie];
    } else {
        [self pauseCurrentMovie];
    }
}

#pragma mark -- notifications
- (id)didSelectedFilterMovie:(id)obj {
    NSLog(@"filter command is %@", obj);
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:obj forKey:@"filter"];
    [dic setValue:movie_url forKey:@"url"];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieAddFilter"];
    [cmd performWithResult:&dic];
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

- (id)rightBtnSelected {
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"NewMovieCurrentFilter"];
   
    id<AYViewBase> view = [self.views objectForKey:@"FilterPreview"];
    NSString* str = nil;
    id<AYCommand> cmd_name = [view.commands objectForKey:@"queryCurrentFilterName"];
    [cmd_name performWithResult:&str];
                              
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:movie_url forKey:@"url"];
    [dic setValue:str forKey:@"filter"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSMutableDictionary* args = [result mutableCopy];
        [args setValue:self.mainContentView.image forKey:@"cover"];
        [args setValue:[self photoTagToDictionary] forKey:@"tags"];
        
        AYViewController* des = DEFAULTCONTROLLER(@"PostMoviePublish");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:[args copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }];
    
    return nil;
}
@end
