//
//  AYOpenDayChooseView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/16.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYOpenDayChooseView.h"
#import "AYOpenDayChooseCellView.h"

@implementation AYOpenDayChooseView {
    
    UICollectionView *calendarContentView;
    NSInteger month;
    NSInteger dayOfWeek;
    NSString *currentDate;
    
}


- (void)setSelectedDate:(NSMutableArray *)selectedDate {
    
    _selectedDate = selectedDate;
    
    [calendarContentView reloadData];
    
}


- (AYCalendarDate *)calendarDate {
    
    if (!_calendarDate) {
        _calendarDate = [[AYCalendarDate alloc]init];
    }
    return _calendarDate;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}

-(void)initialize {
    
    NSDate *current = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [formatter stringFromDate:current];
    
    CGFloat margin = 10.f;
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    
    CGFloat labelWidth = (SCREEN_WIDTH - margin * 2)/7;
    for (int i = 0; i<7; i++) {
        
        UILabel *label = [UILabel creatLabelWithText:[titleArr objectAtIndex:i] textColor:[Tools black] font:[UIFont regularFont:15] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_left).offset((margin + labelWidth * 0.5) + labelWidth * i);
            make.centerY.equalTo(self.mas_top).offset(15);
            
        }];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(labelWidth, labelWidth)];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    
    
    calendarContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(margin, 30, SCREEN_WIDTH - margin*2, SCREEN_HEIGHT - 105 ) collectionViewLayout:layout];
    
    [calendarContentView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:calendarContentView];
    
    [calendarContentView setDelegate:self];
    [calendarContentView setDataSource:self];
    
    [calendarContentView setAllowsMultipleSelection:YES];
    [calendarContentView setShowsVerticalScrollIndicator:NO];
    [calendarContentView setShowsHorizontalScrollIndicator:NO];
    
    CALayer *line_separator = [CALayer layer];
    [line_separator setFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    [line_separator setBackgroundColor:[UIColor garyLine].CGColor];
    [self.layer addSublayer:line_separator];
    
    [calendarContentView registerClass:[AYOpenDayChooseCellView classForCoder] forCellWithReuseIdentifier:@"AYOpenDayChooseCellView"];
    
    [calendarContentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
    [self scrollToCurrentDate];
}

- (void)scrollToCurrentDate {
    
    NSDate *Date = [[NSDate alloc]init];
    
    NSArray *calendar = [[self.calendarDate dataToString:Date] componentsSeparatedByString:@"-"];
    
    [self scrollToYear:calendar[0] month:calendar[1] day:calendar[2]];
    
    
}

- (void) scrollToYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, @1];
    // 获得这个月第一天是星期几
    NSInteger dayOfFirstWeek = [_calendarDate timeMonthWeekDayOfFirstDay:dateStr];
    NSInteger section = (year.integerValue - [_calendarDate getYear]) * 12 + (month.integerValue - 1);
    NSInteger item = day.integerValue + dayOfFirstWeek - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    [calendarContentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
    
    
}


#pragma mark -- UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return (2101 - [_calendarDate getYear]) * 12 - [_calendarDate getMonth];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //每个月的第一天
    NSString *strYear = [NSString stringWithFormat:@"%ld", section / 12 + [_calendarDate getYear]];
    NSString *strMonth = [NSString stringWithFormat:@"%ld", section % 12 + 1];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
    
    return [self.calendarDate timeFewWeekInMonth:dateStr] * 7;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AYOpenDayChooseCellView *cell = (AYOpenDayChooseCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYOpenDayChooseCellView" forIndexPath:indexPath];
    
    //每个月的第一天
    NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
    //获得这个月的天数
    month = [_calendarDate timeNumberOfDaysInString:dateStr];
    //获得这个月第一天是星期几
    dayOfWeek = [_calendarDate timeMonthWeekDayOfFirstDay:dateStr];
    
    NSInteger firstCorner = dayOfWeek;
    NSInteger lastCorner = dayOfWeek + month - 1;
    
    if (indexPath.item < firstCorner || indexPath.item > lastCorner) {
        
        [cell setHidden:YES];
        
    } else {
        
        [cell setHidden:NO];
        [cell setIsGone:NO];
        
        NSInteger day = indexPath.item - firstCorner + 1;
        
        cell.day = [NSString stringWithFormat:@"%ld", day];
        
        NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", indexPath.section / 12 + [_calendarDate getYear], indexPath.section % 12 + 1, (long)day];
        
        NSDate *cellDate = [_calendarDate strToDate:cellDateStr];
        NSTimeInterval cellTimeSpan = cellDate.timeIntervalSince1970;
        
        NSDate *today = [_calendarDate strToDate:currentDate];
        NSTimeInterval todayTimeSpan = today.timeIntervalSince1970;
        
        if (cellTimeSpan < todayTimeSpan) {
            
            cell.isGone = YES;
            
        } else if (cellTimeSpan == todayTimeSpan) {
            
            [cell today];
           
        }
        
        cell.timeSpan = cellTimeSpan;
        
        NSString * s = [NSString stringWithFormat:@"%f",cell.timeSpan ];
        
        for (NSString *temp in _selectedDate) {
            
            if (temp == s) {
                
                [cell setSelected:YES];
                
            }
            
        }
        
        
        
    }
    
    return cell;
    
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
    
    return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + [_calendarDate getYear], section%12 + 1, day];
    
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
        
        UILabel *label = [headerView viewWithTag:119];
        
        if (label == nil) {
            //添加日期
            label = [UILabel creatLabelWithText:@"" textColor:[UIColor black] font:[UIFont mediumFont:22.0f] backgroundColor:nil textAlignment:NSTextAlignmentLeft];
            label.tag = 119;
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(13);
            }];
        }
        
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld年 %.2ld月", indexPath.section/12 + [_calendarDate getYear], indexPath.section % 12 + 1];
        return headerView;
    }
    return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGFloat width = SCREEN_WIDTH - 10 * 2;
    return (CGSize){width, width / 7};
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AYOpenDayChooseCellView * cell = (AYOpenDayChooseCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isGone) {
        
        return;
        
    }
    
    if (_selectedDate) {
        
        [_selectedDate addObject:[NSString stringWithFormat:@"%f",cell.timeSpan]];
        
    }else {
        
        _selectedDate = [[NSMutableArray alloc] init];
        [_selectedDate addObject:[NSString stringWithFormat:@"%f",cell.timeSpan]];
        
    }
    
    [cell setIsSelected:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AYOpenDayChooseCellView * cell = (AYOpenDayChooseCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isGone) {
        
        return ;
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@",[NSString stringWithFormat:@"%f",cell.timeSpan]];
    [_selectedDate filterUsingPredicate:predicate];
    
    [cell setIsSelected:NO];
    

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AYOpenDayChooseCellView * cell = (AYOpenDayChooseCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isGone) {
        
        return NO;
        
    }
    
    NSDate *today = [_calendarDate strToDate:currentDate];
    NSTimeInterval todayTimeSpan = today.timeIntervalSince1970;
    
    if (cell.timeSpan == todayTimeSpan) {
        
        return NO;
        
    }
    
    return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}



@end
