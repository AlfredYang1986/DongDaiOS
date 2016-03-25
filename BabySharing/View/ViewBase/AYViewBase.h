//
//  AYViewBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYViewBase_h
#define AYViewBase_h

#import "AYCommand.h"

@protocol AYViewBase <NSObject, AYCommand>

@property (nonatomic, readonly, getter=getViewType) NSString* view_type;
@property (nonatomic, readonly, getter=getViewName) NSString* view_name;
@end

#endif /* AYViewBase_h */
