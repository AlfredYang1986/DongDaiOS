//
//  AYMainInfoController.h
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"

@interface AYMainInfoController : AYViewController <UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableDictionary *service_change_dic;
@property (nonatomic, strong) NSMutableArray *noteAllArgs;

@end