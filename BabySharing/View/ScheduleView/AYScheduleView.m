//
//  AYScheduleView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleView.h"
#import "AYCalendarDefines.h"

#define HEIGHT              self.frame.size.height
#define MARGIN              10.f
#define COLLECTIONROWNUMB   7
#define operableWeeksLimit        1

static NSString * const tipsLabelInitStr = @"点击日期\n选择您不可以提供服务的时间";

@implementation AYScheduleView {
    NSMutableArray *selectedItemArray;
    NSMutableArray *timeSpanArray;
    NSString *currentDate;
    AYCalendarCellView *tmp;
//    UILabel *tips;
	
}

@synthesize calendarContentView = _calendarContentView;
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (AYCalendarDate*)useTime {
    if (!_useTime) {
        _useTime = [[AYCalendarDate alloc]init];
    }
    return _useTime;
}

#pragma mark -- life cycle
- (void)postPerform {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    
    if (!selectedItemArray) {
        selectedItemArray = [[NSMutableArray alloc]init];
    }
    
    if (!timeSpanArray) {
        timeSpanArray = [[NSMutableArray alloc]init];
    }
    
    [self addCollectionView];
    NSDate *current = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [formatter stringFromDate:current];
}

#pragma mark -- commands
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

#pragma mark -- layout
- (void)addCollectionView {
	
	CGFloat margin = 10.f;
	
	NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
	
	CGFloat labelWidth = (SCREEN_WIDTH - margin * 2)/7;
	for (int i = 0; i<7; i++) {
		UILabel *label = [Tools creatUILabelWithText:[titleArr objectAtIndex:i] andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset((margin+labelWidth*0.5)+labelWidth*i);
			make.centerY.equalTo(self.mas_top).offset(15);
		}];
	}
	
	/******************/
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(labelWidth, labelWidth);
	layout.minimumLineSpacing = 0;
	layout.minimumInteritemSpacing = 0;
	
	_calendarContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(margin, 30, SCREEN_WIDTH - margin*2, SCREEN_HEIGHT - 120 - 130) collectionViewLayout:layout];
	_calendarContentView.backgroundColor = [UIColor clearColor];
	[self addSubview:_calendarContentView];
	_calendarContentView.delegate = self;
	_calendarContentView.dataSource = self;
	_calendarContentView.allowsMultipleSelection = YES;
	_calendarContentView.showsVerticalScrollIndicator = NO;
//	[_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self);
//		make.left.equalTo(self).offset(margin);
//		make.right.equalTo(self).offset(-margin);
//		make.top.equalTo(self).offset(30);
//	}];
	
	CALayer *line_separator = [CALayer layer];
	line_separator.frame = CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5);
	line_separator.backgroundColor = [Tools garyLineColor].CGColor;
	[self.layer addSublayer:line_separator];
	
	[_calendarContentView registerClass:[AYDayCollectionCellView class] forCellWithReuseIdentifier:@"AYDayCollectionCellView"];
	//注册头部
	[_calendarContentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
	
	[self refreshScrollPositionCurrentDate];
	
}

- (void)refreshScrollPositionCurrentDate {
	NSDate *Date = [[NSDate alloc]init];
	NSArray *calendar = [[self.useTime dataToString:Date] componentsSeparatedByString:@"-"];
	[self refreshControlWithYear:calendar[0] month:calendar[1] day:calendar[2]];
}

- (void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
	// 每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, @1];
	// 获得这个月第一天是星期几
	NSInteger dayOfFirstWeek = [_useTime timeMonthWeekDayOfFirstDay:dateStr];
	NSInteger section = (year.integerValue - [_useTime getYear])*12 + (month.integerValue - 1);
	NSInteger item = day.integerValue + dayOfFirstWeek - 1;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
	//    [_calendarContentView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
	[_calendarContentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -- actions
- (void)getClickDate:(AYCalendarCellView*)view {
    if (tmp) {
        tmp.backgroundColor = [UIColor clearColor];
        if ([tmp.numLabel.text isEqualToString:[NSString stringWithFormat:@"%d",self.day]]) {
            tmp.numLabel.textColor = [Tools themeColor];
        }
        else {
            tmp.numLabel.textColor = [UIColor blackColor];
        }
    }
    view.numLabel.textColor = [UIColor whiteColor];
    view.backgroundColor = [Tools themeColor];
    tmp = view;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [format dateFromString:view.dateString];
    
    NSDateFormatter *unformat = [[NSDateFormatter alloc] init];
    [unformat setDateFormat:@"MM月dd日 EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [unformat setTimeZone:timeZone];
    NSString *undate = [unformat stringFromDate:startDate];
    id<AYCommand> cmd = [self.notifies objectForKey:@"changeNavTitle:"];
    if (view == nil) {
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM月dd日 EEEE"];
        NSString* title = [formatter stringFromDate:todayDate];
        [cmd performWithResult:&title];
    } else
        [cmd performWithResult:&undate];
}

- (void)didChangedAvilableDate {
    
    kAYViewSendNotify(self, @"ChangeOfSchedule", nil)
}

#pragma mark -- commands
-(id)queryFiterArgs:(NSDictionary*)args{
	
    return nil;
}

- (id)queryUnavluableDate:(id)args {
    
    NSMutableArray *offer_date = [NSMutableArray array];
    
    for (int i = 0; i < 7; ++i) {
        NSMutableDictionary *date_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        NSMutableDictionary *times_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [times_dic setValue:[NSNumber numberWithInt:0] forKey:@"start"];
        [times_dic setValue:[NSNumber numberWithInt:2400] forKey:@"end"];
        NSMutableArray *occurance = [[NSMutableArray alloc]initWithObjects:times_dic, nil];
        [date_dic setValue:occurance forKey:@"occurance"];
        
        [date_dic setValue:[NSNumber numberWithInt:i] forKey:@"day"];
        [offer_date addObject:date_dic];
    }
    
    NSMutableArray *noteArr = [NSMutableArray array];
    
    for (NSNumber *timeSpan in timeSpanArray) {
        NSDateFormatter *weekFormatter = [Tools creatDateFormatterWithString:@"EEEE"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSpan.doubleValue];
        NSString *dateStr = [weekFormatter stringFromDate:date];
        
        if ([dateStr isEqualToString:@"星期日"] || [dateStr isEqualToString:@"星期天"]) {
            [noteArr addObject:[offer_date objectAtIndex:0]];
        }
        else if ([dateStr isEqualToString:@"星期一"]) {
            [noteArr addObject:[offer_date objectAtIndex:1]];
        }
        else if ([dateStr isEqualToString:@"星期二"]) {
            [noteArr addObject:[offer_date objectAtIndex:2]];
        }
        else if ([dateStr isEqualToString:@"星期三"]) {
            [noteArr addObject:[offer_date objectAtIndex:3]];
        }
        else if ([dateStr isEqualToString:@"星期四"]) {
            [noteArr addObject:[offer_date objectAtIndex:4]];
        }
        else if ([dateStr isEqualToString:@"星期五"]) {
            [noteArr addObject:[offer_date objectAtIndex:5]];
        }
        else if ([dateStr isEqualToString:@"星期六"]) {
            [noteArr addObject:[offer_date objectAtIndex:6]];
        }
    }
    
    for (NSDictionary *item in noteArr) {
        [offer_date removeObject:item];
    }
    
    return [offer_date copy];
}

- (id)changeQueryData:(id)args {
    
    NSDate *Date = [[NSDate alloc]init];
    NSTimeInterval interval_note = Date.timeIntervalSince1970;
    
    NSArray *tmp_args = [(NSDictionary*)args objectForKey:@"offer_date"];
    
    for (int i = 0; i < 7; ++i) {
        NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
        NSDate *date_note = [NSDate dateWithTimeIntervalSince1970:interval_note];
        NSString *dateStr = [formatter stringFromDate:date_note];
        
        NSArray *dateStrArr = [dateStr componentsSeparatedByString:@"-"];
        NSString *year = dateStrArr[0];
        NSString *month = dateStrArr[1];
        NSString *day = dateStrArr[2];
        
        NSString *firstDayStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, @1];
        NSInteger dayOfFirstWeek = [_useTime timeMonthWeekDayOfFirstDay:firstDayStr];			// 获得这个月第一天是星期几
        NSInteger section = (year.integerValue - [_useTime getYear])*12 + (month.integerValue - 1);
        NSInteger item = day.integerValue + dayOfFirstWeek - 1;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        int weekd = indexPath.row % 7;
        
        NSPredicate *pred_contains = [NSPredicate predicateWithFormat:@"SELF.day=%d",weekd];
        NSArray *result_contains = [tmp_args filteredArrayUsingPredicate:pred_contains];
        if (result_contains.count == 0) {
            
            [timeSpanArray addObject:[NSNumber numberWithDouble:interval_note]];
            [_calendarContentView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        interval_note += 86400 ;
    }
    
    if (timeSpanArray.count != 0) {
        [self setAbilityDateTextWith:nil];
    }
    
    return nil;
}

#pragma mark -- scrollView delegate

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (2101-[_useTime getYear]) * 12 - [_useTime getMonth];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //每个月的第一天
    NSString *strYear = [NSString stringWithFormat:@"%ld", section / 12 + [_useTime getYear]];
    NSString *strMonth = [NSString stringWithFormat:@"%ld", section % 12 + 1];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
    
    return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView *cell = (AYDayCollectionCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYDayCollectionCellView" forIndexPath:indexPath];
    
    //每个月的第一天
    NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
    //获得这个月的天数
    self.monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
    //获得这个月第一天是星期几
    self.dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
    
    NSInteger firstCorner = self.dayOfWeek;
    NSInteger lastConter = self.dayOfWeek + self.monthNumber - 1;
    if (indexPath.item < firstCorner || indexPath.item > lastConter) {
        cell.hidden = YES;
    }else {
        cell.hidden = NO;
        cell.isGone = NO;
        
        NSInteger gregoiain = indexPath.item - firstCorner+1;
        NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", indexPath.section/12 + [_useTime getYear], indexPath.section%12 + 1, (long)gregoiain];
        NSDate *cellDate = [_useTime strToDate:cellDateStr];
        NSTimeInterval cellData = cellDate.timeIntervalSince1970;
        NSDate *today = [_useTime strToDate:currentDate];
        NSTimeInterval todayData = today.timeIntervalSince1970;
        NSTimeInterval twoWeeksLater = todayData + operableWeeksLimit * 7 * 86400;
        if (cellData < todayData || cellData >= twoWeeksLater) {
            cell.isGone = YES;
        }
        //阳历
        cell.gregoiainDay = [NSString stringWithFormat:@"%ld", gregoiain];
        //日期属性
        cell.timeSpan = cellData;
        cell.gregoiainCalendar = dateStr;
        cell.chineseCalendar = [self.useTime timeChineseCalendarWithString:dateStr];
        
        UIView *selectBgView = [[UIView alloc] init];
//        selectBgView.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"unavilable_bg")];
        selectBgView.layer.contents = (id)IMGRESOURCE(@"unavilable_bg").CGImage;
        cell.selectedBackgroundView = selectBgView;
    }
    return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
    return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + [_useTime getYear], section%12 + 1, day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
        
        UILabel *label = [headerView viewWithTag:119];
        if (label == nil) {
            //添加日期
            label = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
            label.tag = 119;
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(13);
            }];
        }
        
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld年 %.2ld月", indexPath.section/12 + [_useTime getYear], indexPath.section % 12 + 1];
        return headerView;
    }
    return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	CGFloat width = SCREEN_WIDTH - 10 * 2;
    return (CGSize){width, width / 7};
}

#pragma mark -- cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return ;
    }
    
    long time_p = cell.timeSpan;
    [selectedItemArray addObject:indexPath];
    [timeSpanArray addObject:[NSNumber numberWithDouble:time_p]];
    
    [self setAbilityDateTextWith:nil];
    [self didChangedAvilableDate];
}

#pragma mark -- cell反选
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return ;
    }
    
    long time_p = cell.timeSpan;
    [selectedItemArray removeObject:indexPath];
    [timeSpanArray removeObject:[NSNumber numberWithDouble:time_p]];
    if (timeSpanArray.count == 0) {
		
        return;
    }
    
    [self setAbilityDateTextWith:nil];
    [self didChangedAvilableDate];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone ) {
        return NO;
    } else
        return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (id)dateScrollToCenter:(NSString*)str {
    str = [str substringToIndex:10];
    NSArray *calendar = [str componentsSeparatedByString:@"年"];
    NSArray *calendar2 = [calendar[1] componentsSeparatedByString:@"月"];
    [self refreshControlWithYear:calendar[0] month:calendar2[0] day:calendar2[1]];
    return nil;
}

- (NSString*)transformTimespanToMouthAndDayWithDate:(NSTimeInterval)timespan {
    
    NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:timespan];
    NSDateFormatter *unformat = [Tools creatDateFormatterWithString:@"MM月dd日"];
    NSString *date_string = [unformat stringFromDate:itemDate];
    
    return date_string;
}

- (void)setAbilityDateTextWith:(NSArray*)array {
    NSArray *tmpTimeArray = [timeSpanArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSTimeInterval first = ((NSNumber*)obj1).longValue;
        NSTimeInterval second = ((NSNumber*)obj2).longValue;
        if (first < second) return  NSOrderedAscending;
        else if (first > second) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    NSString *ability_dateString;
    if (tmpTimeArray.count == 1) {
        long first = ((NSNumber*)[tmpTimeArray firstObject]).longValue;
        NSString *first_string = [self transformTimespanToMouthAndDayWithDate:first];
        
        ability_dateString = [NSString stringWithFormat:@"%@",first_string];
        
    } else if ([self isMilitaryWithArray:tmpTimeArray]) {
        long first = ((NSNumber*)[tmpTimeArray firstObject]).longValue;
        NSString *first_string = [self transformTimespanToMouthAndDayWithDate:first];
        
        long last = ((NSNumber*)[tmpTimeArray lastObject]).longValue;
        NSString *last_string = [self transformTimespanToMouthAndDayWithDate:last];
        
        ability_dateString = [NSString stringWithFormat:@"%@ - %@",first_string, last_string];
        
    } else if (tmpTimeArray.count <= 4) {
        
        ability_dateString = [self transformTimespanToMouthAndDayWithDate:((NSNumber*)[tmpTimeArray objectAtIndex:0]).longValue];
        for (int i = 1; i < (tmpTimeArray.count > 4 ? 4 : tmpTimeArray.count) ; ++i) {
            long timeDate = ((NSNumber*)[tmpTimeArray objectAtIndex:i]).longValue;
            NSString *date_string = [self transformTimespanToMouthAndDayWithDate:timeDate];
            ability_dateString = [ability_dateString stringByAppendingString:[NSString stringWithFormat:@", %@",date_string]];
        }
    } else
		ability_dateString = @"多个日期";
	
}

- (BOOL)isMilitaryWithArray:(NSArray*)array {
    
    NSTimeInterval conpare = ((NSNumber*)array.firstObject).longValue;
    for (int i = 1; i < array.count; ++i) {
        NSTimeInterval conpareB = ((NSNumber*)[array objectAtIndex:i]).longValue;
        if ((conpareB - conpare) != 86400) {
            return NO;
        }
        conpare = conpareB;
    }
    return YES;
}

@end
