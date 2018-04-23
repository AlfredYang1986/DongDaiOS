//
//  AYCourseNumSetView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/12.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYCourseNumSetView : UIView <UITextFieldDelegate>

@property(nonatomic, readonly) NSInteger minNum;

@property(nonatomic, readonly) NSInteger maxNum;

@end
