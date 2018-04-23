//
//  AYPublishConfirmView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYPublishConfirmViewDelegate

-(void)setOpenDay;


@end

@interface AYPublishConfirmView : UIView

@property(nonatomic,strong) id<AYPublishConfirmViewDelegate> delegate;

-(void)setUp:(NSDictionary *)dic;

@end
