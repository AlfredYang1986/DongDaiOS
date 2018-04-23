//
//  AYNameInputView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AYNameInputViewDelegate

-(void)updateName:(NSString *)name andBrand:(NSString *)brand;

@end

@interface AYNameInputView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) id<AYNameInputViewDelegate> delegate;


@end
