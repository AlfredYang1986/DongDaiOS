//
//  AYControllerBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYControllerBase_h
#define AYControllerBase_h

#import "AYCommand.h"
#import <UIKit/UIKit.h>

@protocol AYControllerBase <NSObject, AYCommand>

@property (nonatomic, strong) NSDictionary* commands;
@property (nonatomic, strong) NSDictionary* facades;
@property (nonatomic, strong) NSDictionary* views;

@property (nonatomic, readonly, getter=getControllerType) NSString* controller_type;
@property (nonatomic, readonly, getter=getControllerName) NSString* controller_name;
@end

#endif /* AYControllerBase_h */
