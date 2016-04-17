//
//  SearchDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 2/17/16.
//  Copyright © 2016 BM. All rights reserved.
//

#ifndef SearchDefines_h
#define SearchDefines_h

typedef enum : NSUInteger {
    SearchStatusUnknow,
    SearchStatusNoInput,
    SearchStatusInputWithResult,
    SearchStatusInputWithNoResult,
} SearchStatus;

static NSString* const FoundSearchHeader = @"FoundSearchHeader";
static NSString* const FoundHotCell = @"FoundHotTagsCell";

#endif /* SearchDefines_h */
