//
//  AYSearchController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

@interface AYSearchController : AYViewController
- (id<AYCommand>)queryDataCommand;
- (NSDictionary*)queryDataArgs;

- (NSArray*)handleRecommandResult:(id)result;
- (id)handleResultToString:(id)result;
- (id)queryHeaderTitle;
- (id)queryHandleCommand;
- (id)queryNoResultTitle;

- (id)SearchBarLayout:(UIView*)view;
- (id)TableLayout:(UIView*)view;
@end
