//
//  AYLineView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYLineView : UIView

@property(nonatomic) NSInteger step;

-(instancetype) initWithNumber:(NSInteger)count;

@end
