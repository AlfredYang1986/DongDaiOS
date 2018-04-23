//
//  AYServiceChooseView.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYServiceChooseViewDelegate

-(void)tipTapped;

-(void)updateCategory:(NSString *)s;


@end

@interface AYServiceChooseView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) id<AYServiceChooseViewDelegate> delegate;

@end
