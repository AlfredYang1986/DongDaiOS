//
//  AYMovieCoverView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYMovieCoverView.h"
#import "AYCommandDefines.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

#define THUMB_SMALL_HEIGHT          31
#define THUMB_SMALL_WIDTH           THUMB_SMALL_HEIGHT
    
#define THUMB_LARGE_WIDTH           61
#define THUMB_LARGE_HEIGHT          THUMB_LARGE_WIDTH

@interface AYMovieCoverView ()
@property (nonatomic, setter=setCurrentIndex:) NSInteger current_index;
@end

@implementation AYMovieCoverView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- layout
- (void)layoutSubviews {
    UIView* container = [self viewWithTag:-99];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(THUMB_SMALL_WIDTH * 8);
        make.height.mas_equalTo(THUMB_SMALL_HEIGHT);
    }];
//    container.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

}

#pragma mark -- commands
- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- messages
- (id)setMovieUrl:(id)args {
    
    id<AYFacadeBase> f = MOVIEPLAYER;
    id<AYCommand> cmd = [f.commands objectForKey:@"MovieCoverImages"];
    id thumbs = args;
    [cmd performWithResult:&thumbs];
    
    NSInteger steps = 8;
    UIView* container = [[UIView alloc]init];
    container.tag = -99;
    [self addSubview:container];
    
    for (int index = 0; index < steps; ++index) {
        UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(index * THUMB_SMALL_WIDTH, 0, THUMB_SMALL_WIDTH, THUMB_SMALL_HEIGHT)];
        tmp.image = [thumbs objectAtIndex:index];
        tmp.userInteractionEnabled = YES;
        tmp.tag = index + 1;
        tmp.layer.borderColor = [UIColor colorWithRed:0.2745 green:0.8566 blue:0.7922 alpha:1.f].CGColor;
        [container addSubview:tmp];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickThumb:)];
        [tmp addGestureRecognizer:tap];
    }
    
    self.current_index = 1;
    return nil;
}

- (void)setCurrentIndex:(NSInteger)current_index {
    if (_current_index != current_index) {
        _current_index = current_index;
        UIView* container = [self viewWithTag:-99];
        
        for (UIView* iter in container.subviews) {
            iter.bounds = CGRectMake(0, 0, THUMB_SMALL_WIDTH, THUMB_SMALL_HEIGHT);
            iter.layer.borderWidth = 0.f;
        }
        
        UIView* tmp = [container viewWithTag:_current_index + 1];
        CGPoint ct = tmp.center;
        tmp.bounds = CGRectMake(0, 0, THUMB_LARGE_WIDTH, THUMB_LARGE_HEIGHT);
        tmp.center = ct;
        tmp.layer.borderWidth = 2.f;
        
        [container bringSubviewToFront:tmp];
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"didSelectedCover:"];
        id img = ((UIImageView*)tmp).image;
        [cmd performWithResult:&img];
    }
}

- (void)didClickThumb:(UITapGestureRecognizer*)gesture {
    self.current_index = gesture.view.tag - 1;
}
@end
