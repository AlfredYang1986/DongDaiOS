//
//  AYCityInputView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCityInputViewDelegate

-(void) updateCity:(NSString *)city;

@end

@interface AYCityInputView : UIView <UITextFieldDelegate>

-(instancetype)initWithName:(NSString *)name;

@property(nonatomic, strong) id<AYCityInputViewDelegate> delegate;

@end
