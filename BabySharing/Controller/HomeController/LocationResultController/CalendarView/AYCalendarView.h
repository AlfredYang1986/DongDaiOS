//
//  AYCalendarView.h
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

//@interface AYCalendarView : UIScrollView <AYViewBase>
@interface AYCalendarView : UIView <AYViewBase>

-(void)getClickDate:(NSString*)date;
@end
