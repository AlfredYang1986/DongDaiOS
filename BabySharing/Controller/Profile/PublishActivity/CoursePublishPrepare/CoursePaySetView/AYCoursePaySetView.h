//
//  AYCoursePaySetView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCoursePaySetViewDelegate

-(void)payByTime;

-(void)payByMember;


@end

@interface AYCoursePaySetView : UIView

@property(nonatomic) id<AYCoursePaySetViewDelegate> delegate;

-(void)selectByTime;

-(void)selectByMember;



@end
