//
//  AYCarePaySetView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCarePaySetViewDelegate

-(void)payFlexible;

-(void)payFixed;


@end

@interface AYCarePaySetView : UIView


@property(nonatomic) id<AYCarePaySetViewDelegate> delegate;

-(void)selectFlexible;

-(void)selectFixed;


@end
