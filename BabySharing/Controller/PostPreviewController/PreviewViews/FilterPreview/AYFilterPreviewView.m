//
//  AYFilterPreviewView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFilterPreviewView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "Tools.h"

#define CMDFORINDEX(index, cmd)         do { \
                                            switch (index) { \
                                                case 0: \
                                                    cmd = [f.commands objectForKey:@"BlackAndWhiteFilter"]; \
                                                    break; \
                                                case 1: \
                                                    cmd = [f.commands objectForKey:@"SceneFilter"]; \
                                                    break; \
                                                case 3: \
                                                    cmd = [f.commands objectForKey:@"AvaterFilter"]; \
                                                    break; \
                                                case 4: \
                                                    cmd = [f.commands objectForKey:@"FoodFilter"]; \
                                                    break; \
                                                default: \
                                                    break; \
                                            } \
                                        } while(0)

@interface AYFilterPreviewView ()
@property (nonatomic, setter=setCurrentSelected:) NSInteger current_selected;
@end

@implementation AYFilterPreviewView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)layoutSubviews {
#define MAGIC_NUMBER    0.4f
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat margin = 0;
    CGFloat button_height = (height - 2 * margin) * MAGIC_NUMBER;
    
    CGFloat preferred_width = MIN(width, 5 * (margin + button_height));
    CGFloat edge_margin = ABS(width - preferred_width) / 2;
    
    for (int index = 0; index < 5; ++index) {
        UIView* view = [self viewWithTag:index + 1];
        view.bounds = CGRectMake(0, 0, button_height, button_height);
        view.center = CGPointMake(edge_margin + (index + 1) * margin + (2 * index + 1) * button_height / 2, height / 2);
    }
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

- (UIButton*)addPhotoEffectBtn:(NSString*)title bounds:(CGRect)bounds tag:(NSInteger)tag image:(UIImage*)image {
    
    /**
     * it is magic, don't touch
     */
    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filterBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     * title text
     */
    CATextLayer* tl = [CATextLayer layer];
    tl.string = title;
    tl.foregroundColor = [UIColor whiteColor].CGColor; //[UIColor colorWithRed:0.1373 green:0.1255 blue:0.1216 alpha:1.f].CGColor;
    tl.backgroundColor = [UIColor clearColor].CGColor;
    tl.fontSize = 11.f;
    
    CGSize s = [Tools sizeWithString:title withFont:[UIFont systemFontOfSize:11.f] andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    tl.frame = CGRectMake(0, bounds.size.height - s.height, bounds.size.width, s.height);
    tl.alignmentMode = @"center";
    tl.contentsScale = 2.f;
    [btn.layer addSublayer:tl];
    
    /**
     * image preview
     */
    UIImageView* il = [[UIImageView alloc]init];
    CGFloat mar = 0;
    CGFloat len = MIN(bounds.size.height - s.height - mar, bounds.size.width);
    il.frame = CGRectMake((bounds.size.width - len) / 2, (bounds.size.height - s.height - mar - len) / 2, len, len);
    il.image = image;
    il.layer.cornerRadius = 4.f;
    il.layer.borderColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f].CGColor;

    il.layer.masksToBounds = YES;
    il.tag = -99;
    [btn addSubview:il];
    btn.tag = tag;
    
    return btn;
}

#pragma mark -- message
- (id)setOriginImage:(id)obj {
  
    for (UIView* sub in self.subviews) {
        [sub removeFromSuperview];
    }
    
    UIImage* source = (UIImage*)obj;

    CGFloat height = self.frame.size.height;
    CGFloat margin = 0;
    CGFloat button_height = (height - 2 * margin) * MAGIC_NUMBER;
  
    NSArray* const title = @[@"黑白", @"美景", @"原图", @"美肤", @"美食"];
    
    id<AYFacadeBase> f = GPUFILTER;
    for (int index = 0; index < 5; ++index) {
        id<AYCommand> cmd = nil;
        CMDFORINDEX(index, cmd);
        UIImage* args = source;
        if (cmd != nil) {
            [cmd performWithResult:&args];
        }
        [self addSubview:[self addPhotoEffectBtn:[title objectAtIndex:index] bounds:CGRectMake(0, 0, button_height, button_height) tag:1 + index image:args]];
    }
    
//    {
//        id<AYCommand> cmd = [f.commands objectForKey:@"BlackAndWhiteFilter"];
//        UIImage* args = source;
//        [cmd performWithResult:&args];
//        [self addSubview:[self addPhotoEffectBtn:@"黑白" bounds:CGRectMake(0, 0, button_height, button_height) tag:1 image:args]];
//    }
//    
//    {
//        id<AYCommand> cmd = [f.commands objectForKey:@"SceneFilter"];
//        UIImage* args = source;
//        [cmd performWithResult:&args];
//        [self addSubview:[self addPhotoEffectBtn:@"美景" bounds:CGRectMake(0, 0, button_height, button_height) tag:2 image:args]];
//    }
//    
//    {
//        UIImage* args = source;
//        [self addSubview:[self addPhotoEffectBtn:@"原图" bounds:CGRectMake(0, 0, button_height, button_height) tag:3 image:args]];
//    }
//
//    {
//        id<AYCommand> cmd = [f.commands objectForKey:@"AvaterFilter"];
//        UIImage* args = source;
//        [cmd performWithResult:&args];
//        [self addSubview:[self addPhotoEffectBtn:@"美肤" bounds:CGRectMake(0, 0, button_height, button_height) tag:4 image:args]];
//    }
//
//    {
//        id<AYCommand> cmd = [f.commands objectForKey:@"FoodFilter"];
//        UIImage* args = source;
//        [cmd performWithResult:&args];
//        [self addSubview:[self addPhotoEffectBtn:@"美食" bounds:CGRectMake(0, 0, button_height, button_height) tag:5 image:args]];
//    }
    
    self.current_selected = 2;
    
    return nil;
}

- (void)setCurrentSelected:(NSInteger)index {
    if (index != _current_selected) {
        _current_selected = index;
       
        for (UIView* iter in self.subviews) {
            UIImageView* img = [iter viewWithTag:-99];
            img.layer.borderWidth = 0.f;
        }
        
        UIView* btn = [self viewWithTag:_current_selected + 1];
        UIImageView* img = [btn viewWithTag:-99];
        img.layer.borderWidth = 2.f;
    }
}

- (id)queryFilterWithIndex:(NSInteger)index {
    id<AYFacadeBase> f = GPUFILTER;
    id<AYCommand> c = [f.commands objectForKey:@"QueryFilterWithName"];
    NSString* str = nil;
    switch (index) {
        case 0:
            str = @"BlackAndWhiteFilter";
            break;
        case 1:
            str = @"SceneFilter";
            break;
        case 3:
            str = @"AvaterFilter";
            break;
        case 4:
            str = @"FoodFilter";
            break;
        default:
            break;
    }
    [c performWithResult:&str];
    return (id)str;
}

- (void)filterBtnSelected:(UIButton*)sender {
    NSInteger index = sender.tag - 1;
    
    if (index != _current_selected) {
        self.current_selected = index;

        UIView* btn = [self viewWithTag:_current_selected + 1];
        UIImageView* img = [btn viewWithTag:-99];

        id result = img.image;
        id<AYCommand> cmd_photo = [self.notifies objectForKey:@"didSelectedFilterPhoto:"];
        [cmd_photo performWithResult:&result];

        id filter = [self queryFilterWithIndex:index];
        id<AYCommand> cmd_movie = [self.notifies objectForKey:@"didSelectedFilterMovie:"];
        [cmd_movie performWithResult:&filter];
    }
}
@end
