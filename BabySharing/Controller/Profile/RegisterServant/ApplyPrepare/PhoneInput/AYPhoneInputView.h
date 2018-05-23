//
//  AYPhoneInputView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYPhoneInputViewDelegate

-(void)updatePhone:(NSString *)phone valid:(Boolean)value;


@end

@interface AYPhoneInputView : UIView <UITextFieldDelegate>


-(instancetype)initWithName:(NSString *)name city:(NSString *)city;

@property(nonatomic, strong) id<AYPhoneInputViewDelegate> delegate;


@end
