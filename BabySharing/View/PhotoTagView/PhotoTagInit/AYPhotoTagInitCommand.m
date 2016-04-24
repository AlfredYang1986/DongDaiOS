//
//  AYPhotoTagInitCommand.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPhotoTagInitCommand.h"
#import "AYCommandDefines.h"
#import "PhotoTagEnumDefines.h"
#import "AYPhotoTagView.h"
//#import "Masonry.h"

@implementation AYPhotoTagInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {

    NSDictionary* args = (NSDictionary*)*obj;
    NSString* tag_text = [args objectForKey:@"tag_text"];
    TagType tag_type = ((NSNumber*)[args objectForKey:@"tag_type"]).integerValue;
    CGFloat width = ((NSNumber*)[args objectForKey:@"width"]).floatValue;
    CGFloat height = ((NSNumber*)[args objectForKey:@"height"]).floatValue;
    NSNumber* offset_x = [args objectForKey:@"offsetX"];
    NSNumber* offset_y = [args objectForKey:@"offsetY"];
    
    AYPhotoTagView *tmp = [[AYPhotoTagView alloc] initWithTagName:tag_text andType:tag_type];
    CGPoint point_tmp;
    
    if (offset_x && offset_y) {
        point_tmp = CGPointMake(width * offset_x.floatValue, height * offset_x.floatValue);
    } else {
        switch (tag_type) {
            case TagTypeLocation:
                point_tmp = CGPointMake(width / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            case TagTypeTime:
                point_tmp = CGPointMake(width / 2 - tmp.bounds.size.width / 2, height * 3 / 4);
                break;
            case TagTypeTags:
                point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            case TagTypeBrand:
                point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
                break;
            default:
                break;
        }       
    }

    tmp.frame = CGRectMake(point_tmp.x, point_tmp.y, tmp.bounds.size.width, tmp.bounds.size.height);
    
    *obj = tmp;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
