//
//  AYRemoteCallCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYCommandDefines.h"

@interface AYRemoteCallCommand : NSObject <AYCommand>

@property (nonatomic, strong) NSString* route;

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block;
@end