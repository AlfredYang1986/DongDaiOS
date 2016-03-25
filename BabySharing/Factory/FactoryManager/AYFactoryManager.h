//
//  AYFactoryManager.h
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"

@interface AYFactoryManager : NSObject

+ (AYFactoryManager*)sharedInstance;

- (id)enumObjectWithCatigory:(NSString*)cat type:(NSString*)type name:(NSString*)name;
- (id<AYCommand>)enumCommandWithType:(NSString*)command_type andName:(NSString*)command_name;

@end
