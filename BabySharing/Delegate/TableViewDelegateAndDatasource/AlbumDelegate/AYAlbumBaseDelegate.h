//
//  AYAlbumBaseDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYAlbumBaseDelegate : NSObject <AYDelegateBase, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* querydata;
@end
