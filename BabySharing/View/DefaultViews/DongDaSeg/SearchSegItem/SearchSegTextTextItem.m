//
//  SearchSegTextTextItem.m
//  BabySharing
//
//  Created by Alfred Yang on 3/4/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchSegTextTextItem.h"

#define DEFAULT_MARGIN_HER          30
#define ITEM_WIDTH                  71
#define ITEM_HEIGHT                 44
#define ITME_LAYER_LINE_HEIGHT      4

@implementation SearchSegTextTextItem {
    //    UILabel* label;
    CALayer* layer;
}

@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize status = _status;
@synthesize isLayerHidden = _isLayerHidden;
@synthesize font_size = _font_size;
@synthesize select_font_color = _select_font_color;


- (id)init {
    self = [super init];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (void)changeItemTitle:(NSString *)title {
    _title = title;
    
    UILabel* label = [self viewWithTag:-1];
    label.text = _title;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_WIDTH / 2, ITEM_HEIGHT * 5 / 12);
    
    [self setNeedsDisplay];
}

- (void)changeItemSubTitle:(NSString *)title {
    _subTitle = title;
    
    UILabel* label = [self viewWithTag:-2];
    label.text = _subTitle;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_WIDTH / 2, ITEM_HEIGHT * 7 / 8);
    
    [self setNeedsDisplay];
}

- (void)setUpValues {
    
//    if (_font_size == 0) {
//        _font_size = 16.f;
//    }
    
    UILabel* label = [[UILabel alloc]init];
    label.font = kAYFontLight(20.f);
    label.tag = -1;
    [self addSubview:label];
    
    UILabel* label1 = [[UILabel alloc]init];
    label1.font = kAYFontLight(11.f);
    label1.tag = -2;
    [self addSubview:label1];
    
    layer = [CALayer layer];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"dongda_seg_selected" ofType:@"png"]];
    
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake(0, self.frame.size.height - ITME_LAYER_LINE_HEIGHT, ITEM_WIDTH, ITME_LAYER_LINE_HEIGHT);
    [self.layer addSublayer:layer];
    
    layer.hidden = _status == 0;
    label.textColor = _status == 0 ? _font_color : _select_font_color;
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
}

- (void)resetFontSize:(CGFloat)font_size {
    _font_size = font_size;
    UILabel* label = [self viewWithTag:-1];
    label.font = kAYFontLight(_font_size);
}

- (void)resetFontColor:(UIColor *)font_color {
    _font_color = font_color;
    if (_status == 0) {
        UILabel* label = [self viewWithTag:-1];
        UILabel* label1 = [self viewWithTag:-2];
        label.textColor = _font_color;
        label1.textColor = _font_color;
    }
}

- (void)resetSelectFontColor:(UIColor *)select_font_color {
    _select_font_color = select_font_color;
    if (_status == 1) {
        UILabel* label = [self viewWithTag:-1];
        UILabel* label1 = [self viewWithTag:-2];
        label.textColor = _select_font_color;
        label1.textColor = _select_font_color;
    }
}

- (void)changeStatus:(NSInteger)s {
    _status = s;
    layer.hidden = _status == 0;
    UILabel* label = [self viewWithTag:-1];
    label.textColor = _status == 0 ? _font_color : _select_font_color;

    UILabel* label1 = [self viewWithTag:-2];
    label1.textColor = _status == 0 ? _font_color : _select_font_color;
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
}

+ (CGSize)preferredSize {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}
@end
