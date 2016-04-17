//
//  FoundSearchResultCell.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

typedef NS_ENUM(NSInteger, SearchType) {
    SearchSige,
    SearchRole,
};

@interface AYFoundSearchResultCellView : UITableViewCell <AYViewBase>

@property (nonatomic, assign) SearchType type;

+ (CGFloat)preferredHeight;
- (void)setUserPhotoImage:(NSArray*)img_arr;
- (void)setUserContentImages:(NSArray*)img_arr;
//- (void)setSearchTag:(NSString*)title andImage:(UIImage*)img;
- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type;
- (void)setSearchResultCount:(NSInteger)count;
@end
