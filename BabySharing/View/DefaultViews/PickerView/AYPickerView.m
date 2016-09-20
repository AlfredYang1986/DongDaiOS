//
//  AYPickerView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPickerView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYHomeCellDefines.h"

#define SHOW_OFFSET_Y           SCREEN_HEIGHT - 196
#define kSelfHeight             196

@implementation AYPickerView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, kSelfHeight);
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *save = [[UIButton alloc]init];
    [self addSubview:save];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [save addTarget:self action:@selector(didSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [[UIButton alloc]init];
    [self addSubview:cancel];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [cancel addTarget:self action:@selector(didCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, kSelfHeight - 30)];
    [self addSubview:_pickerView];
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)didSaveClick:(UIButton*)btn {
    if (self.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kSelfHeight);
        }];
    }
    
    id<AYCommand> save = [self.notifies objectForKey:@"didSaveClick"];
    [save performWithResult:nil];
}

- (void)didCancelClick:(UIButton*)btn {
    
    if (self.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kSelfHeight);
        }];
    }
    
    id<AYCommand> cancel = [self.notifies objectForKey:@"didCancelClick"];
    [cancel performWithResult:nil];
}

#pragma mark -- view commands
- (id)registerDatasource:(id)obj {
    id<UIPickerViewDataSource> d = (id<UIPickerViewDataSource>)obj;
    _pickerView.dataSource = d;
    return nil;
}

- (id)registerDelegate:(id)obj {
    id<UIPickerViewDelegate> d = (id<UIPickerViewDelegate>)obj;
    _pickerView.delegate = d;
    return nil;
}

- (id)showPickerView {
    if (self.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, kSelfHeight);
        }];
    }
    return nil;
}

@end

@implementation AYPicker2View

//-(void)didSaveClick:(UIButton*)btn{
//    id<AYCommand> save = [self.notifies objectForKey:@"didSave2Click"];
//    [save performWithResult:nil];
//}

@end
