//
//  AYServiceChooseView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/23.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceChooseView.h"
#import "AYServiceChooseViewCell.h"

@implementation AYServiceChooseView {
    
    UITableView *tableView;
    NSArray *titles;
    NSInteger index;
}

@synthesize delegate = _delegate;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        index = -1;
        
        titles = [NSArray arrayWithObjects:@"看顾",@"课程",@"体验", nil];
        
        UILabel *head = [UILabel creatLabelWithText:@"最后，请告诉我\n你希望在咚哒上线的服务类型？" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [self addSubview:head];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
            
        }];
        
        tableView = [[UITableView alloc] init];
        [self addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(head.mas_bottom).offset(40);
            make.left.right.bottom.equalTo(self);
            
        }];
        
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [tableView registerClass:[AYServiceChooseViewCell class] forCellReuseIdentifier:@"AYServiceChooseViewCell"];
        
        
        UILabel *tip = [UILabel creatLabelWithText:nil textColor:[UIColor gary166] font:[UIFont regularFont:13] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tip];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-16);
            
        }];
        
        [tip setUserInteractionEnabled:YES];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"我是哪种服务类型？" attributes:@{NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        
        [tip setAttributedText:attributedString];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipTapped)];
        [tip addGestureRecognizer:tap];
        

        
    }
    return self;
}

-(void)tipTapped {
    
    [_delegate tipTapped];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AYServiceChooseViewCell *cell = (AYServiceChooseViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AYServiceChooseViewCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    [cell setCategory:titles[indexPath.row]];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AYServiceChooseViewCell *new_cell = (AYServiceChooseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (new_cell.isSelected) {
        
        if (index == indexPath.row) {
            
            [new_cell setIsSelected: NO];
            [_delegate updateCategory:@""];
            
        }else {
            
            NSIndexPath *old = [NSIndexPath indexPathForRow:index inSection:0];
            AYServiceChooseViewCell *old_cell = (AYServiceChooseViewCell *)[tableView cellForRowAtIndexPath:old];
            [old_cell setIsSelected:NO];
            
            [_delegate updateCategory:new_cell.category];
            [new_cell setIsSelected:YES];
            
        }
        
        
    }else{
        
        if (index == indexPath.row) {
            
            [new_cell setIsSelected:YES];
            
            
        }else {
            
            NSIndexPath *old = [NSIndexPath indexPathForRow:index inSection:0];
            AYServiceChooseViewCell *old_cell = (AYServiceChooseViewCell *)[tableView cellForRowAtIndexPath:old];
            [old_cell setIsSelected:NO];
            
            [new_cell setIsSelected:YES];
            
            
            
        }
        
        [_delegate updateCategory:new_cell.category];
        
    }
    
    index = indexPath.row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
    
}

@end
